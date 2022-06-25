import json
import os
from string import Template

from pyecharts import options as opts
from pyecharts.charts import Line, HeatMap as Heat_Statis
import geojson
import pandas as pd
from django.conf import settings
import folium
from folium.plugins import HeatMapWithTime
from loguru import logger
import numpy as np

import business.save_geojson
# from business.models import Task
from business.save_geojson import make_heat, make_map_only, get_colormap_gradient
from common.utils import return_location, get_background_url


def matching_result_map(dataset_file, task, background_id):
    """
    交通预测，生成结果地图文件，文件名：数据集名称_task_id_result.html

    :param dataset_file: 数据集文件对象 对应表 tb_file
    :param task_id: 任务expid
    :param background_id: 地图底图id
    """
    dataset_dir = dataset_file.extract_path
    result_template = Template("${task_id}_${model}_${dataset}_result.${suffix}")
    result_file_name = result_template.safe_substitute(task_id=task.id, model=task.model,
                                                       dataset=task.dataset, suffix='npz')
    # 准备result.json
    result_json_path = None
    result_dir = settings.EVALUATE_PATH_PREFIX + str(task.exp_id) + settings.EVALUATE_PATH_SUFFIX
    file_list = os.listdir(result_dir)
    for file in file_list:
        if file == result_file_name:
            result_json_path = result_dir + file
    logger.info("result_json_path: {}", result_json_path)
    # 准备dataset dyna json
    dataset_dir = dataset_dir + "_geo_json"
    dataset_json_path = None
    dataset_grid_json_path = None
    dataset_gridod_json_path = None
    file_list = os.listdir(dataset_dir)
    for file in file_list:
        if file.count('dyna') > 0 and file.count("truth_dyna") == 0:
            dataset_json_path = dataset_dir + os.sep + file
        elif file.count('grid') > 0:
            # grid 暂时和 dyna 走一个策略 常规json可视化策略
            dataset_json_path = dataset_dir + os.sep + file
        elif file.count('gridod') > 0:
            dataset_gridod_json_path = dataset_dir + os.sep + file
    # print(dataset_json_path)
    # 生成地图
    if result_json_path and dataset_json_path:
        logger.info("The result json path is: " + result_json_path)
        logger.info("The dataset json path is: " + dataset_json_path)
        map_save_path = settings.ADMIN_FRONT_HTML_PATH + dataset_file.file_name + "_" + str(task.exp_id) + "_result.html"
        try:
            render_to_map(dataset_json_path, result_json_path, background_id, map_save_path, dataset_dir)
        except Exception as ex:
            logger.error('render_to_map异常：{}', ex)
    elif result_json_path and dataset_gridod_json_path:
        logger.info("The result json path is: " + result_json_path)
        logger.info("The dataset grid json path is: " + dataset_gridod_json_path)
        map_save_path = settings.ADMIN_FRONT_HTML_PATH + dataset_file.file_name + "_" + str(task.exp_id) + "_result.html"
        try:
            render_grid_to_map(dataset_grid_json_path, result_json_path, background_id, map_save_path, dataset_dir)
        except Exception as ex:
            logger.error('render_grid_to_map异常：{}', ex)
    else:
        logger.info("result json not found")


def render_to_map(dataset_json_path, result_json_path, background_id, map_save_path, dataset_dir):
    """
    非网格型数据生成html

    :param dataset_json_path: 数据集原本生成的geojson
    :param result_json_path: 结果集json
    :param background_id: 地图底图id
    :param map_save_path:保存地址
    :param dataset_dir:原始数据集解压地址
    """
    dataset_json_content = json.load(open(dataset_json_path, 'r'))
    file_data = np.load(result_json_path)
    prediction = file_data['prediction']
    truth = file_data['truth']
    try:
        return_location(dataset_json_content)
        if prediction.ndim == 5:
            name_list = return_data_names(dataset_dir)
            pre = ((prediction.mean(axis=0)).mean(axis=0)).mean(axis=1).reshape(-1)
            tru = ((truth.mean(axis=0)).mean(axis=0)).mean(axis=1).reshape(-1)
            dif = pre-tru
            value1_list_pre, value1_list_truth, value1_list_dif = [], [], []
            for item in pre:
                value1_list_pre.append(float(item))
            for item in tru:
                value1_list_truth.append(float(item))
            for item in dif:
                value1_list_dif.append(float(item))
            value_dict = [value1_list_pre, value1_list_truth,value1_list_dif]
            try:
                asix_x = []
                for i in range(len(pre)):
                    asix_x.append(str(i))
                logger.info('value_dict[0]: {} len(value_dict[0]: {}',value_dict[0], len(value_dict[0]))
                logger.info("name_list: {}", name_list)
                logger.info("asix_x: {}", asix_x)
                form_line_statis(value_dict, asix_x, map_save_path, name_list)
                logger.info('结果统计图象html已经生成')
            except Exception as ex:
                logger.info('结果统计图象html生成失败，异常信息：{}', ex)
        else:
            dif = prediction - truth
            if len(prediction[0][0][0]) == 2:
                dif = prediction - truth
                prediction = prediction.sum(axis=3)
                truth = truth.sum(axis=3)
                dif = dif.sum(axis=3)
            list_hm_pre, geo_pre = make_series_list(prediction, dataset_json_path)
            list_hm_tru, geo_tru = make_series_list(truth, dataset_json_path)
            list_hm_dif, geo_dif = make_series_list(dif, dataset_json_path)
            m = folium.Map(
                location=return_location(dataset_json_content),
                tiles=get_background_url(background_id),
                zoom_start=12, attr='default'
            )
            colormap, gradient_map = get_colormap_gradient(geo_pre['features'], 'traffic_speed')
            HeatMapWithTime(list_hm_tru, name='truth', min_opacity=1,
                            radius=25, gradient=gradient_map).add_to(m)
            HeatMapWithTime(list_hm_pre, name='prediction', min_opacity=1,
                            radius=25, gradient=gradient_map).add_to(m)
            HeatMapWithTime(list_hm_dif, name='difference', min_opacity=1,
                            radius=25, gradient=gradient_map).add_to(m)
            colormap.add_to(m)
            for feature in geo_pre['features']:
                make_map_only(feature, [], m, 'traffic_speed')
            # folium.GeoJson(data=geo_pre, name='prediction').add_to(m)
            folium.LayerControl(sortLayers=True).add_to(m)
            logger.info("The task result file was generated successfully, html path: " + map_save_path)
            m.save(map_save_path)
    except Exception as ex:
        logger.info("非网格型数据生成html，没有坐标点，开始绘制统计图像，异常信息：{}", ex)
        dif = prediction-truth
        name_list = return_data_names(dataset_dir)
        prediction_mean = (prediction.mean(axis=0)).mean(axis=0)
        truth_mean = (truth.mean(axis=0)).mean(axis=0)
        dif_mean = (dif.mean(axis=0)).mean(axis=0)
        asix_x = []
        for i in range(len(prediction_mean)):
            asix_x.append(str(i))
        if len(prediction_mean[0]) == 2:
            prediction_mean, truth_mean, dif_mean = list(prediction_mean), list(truth_mean), list(dif_mean)
            value1_list_pre, value2_list_pre, value1_list_truth, value2_list_truth, value1_list_dif, value2_list_dif \
                = [], [], [], [], [], []
            for item in prediction_mean:
                value1_list_pre.append(int(item[0]))
                value2_list_pre.append(int(item[1]))
            for item in truth_mean:
                value1_list_truth.append(int(item[0]))
                value2_list_truth.append(int(item[1]))
            for item in dif_mean:
                value1_list_dif.append(int(item[0]))
                value2_list_dif.append(int(item[1]))
            value_dict = [value1_list_pre, value2_list_pre, value1_list_truth, value2_list_truth, value1_list_dif,
                          value2_list_dif]
        else:
            value1_list_pre, value1_list_truth, value1_list_dif = [], [], []
            if name_list[0] == 'risk':
                for item_list in prediction_mean:
                    value1_list_pre.append(int(item_list[0] * 100))
                for item_list in truth_mean:
                    value1_list_truth.append(int(item_list[0] * 100))
                for item_list in dif_mean:
                    value1_list_dif.append(int(item_list[0] * 100))
            else:
                for item_list in prediction_mean:
                    value1_list_pre.append(int(item_list[0]))
                for item_list in truth_mean:
                    value1_list_truth.append(int(item_list[0]))
                for item_list in dif_mean:
                    value1_list_dif.append(int(item_list[0]))
            value_dict = [value1_list_pre, value1_list_truth, value1_list_dif]
        try:
            logger.info('value_dict[0]: {} len(value_dict[0]: {}', value_dict[0], len(value_dict[0]))
            logger.info("name_list: {}", name_list)
            logger.info("asix_x: {}", asix_x)
            form_line_statis(value_dict, asix_x, map_save_path, name_list)
            logger.info('结果统计图象html已经生成')
        except Exception as ex:
            logger.info('结果统计图象html生成失败，异常信息：{}', ex)


def form_line_statis(value_dict, asix_x, map_save_path, namelist):
    """
    根据统计数据形成一个固定宽度的html页面
    """
    if len(namelist) == 1 and len(value_dict) == 3:
        Line(init_opts=opts.InitOpts(width="1600px", height="700px")).add_xaxis(xaxis_data=asix_x). \
            add_yaxis(series_name="mean of predict " + str(namelist[0]), y_axis=value_dict[0],
                      markline_opts=opts.MarkLineOpts(
                          data=[opts.MarkLineItem(type_="average", name="平均值")]), ). \
            add_yaxis(series_name="mean of truth " + str(namelist[0]), y_axis=value_dict[1],
                      markline_opts=opts.MarkLineOpts(
                          data=[opts.MarkLineItem(type_="average", name="平均值")]), ). \
            add_yaxis(series_name="mean of differ " + str(namelist[0]), y_axis=value_dict[2],
                      markline_opts=opts.MarkLineOpts(
                          data=[opts.MarkLineItem(type_="average", name="平均值")]), ). \
            set_global_opts(
            title_opts=opts.TitleOpts(title=str("mean of " + namelist[0]), subtitle="Keep 1 decimal place (0.1)",
                                      pos_left='80%', ),
            legend_opts=opts.LegendOpts(orient = 'vertical',pos_left = '40%',),
            xaxis_opts=opts.AxisOpts(name='geo_id', is_show=True),
            yaxis_opts=opts.AxisOpts(name='value of ' + str(namelist[0]),
                                     splitline_opts=opts.SplitLineOpts(is_show=True)),
            toolbox_opts=opts.ToolboxOpts(
                is_show=True,
                orient="vertical",
                pos_left="90%",
            )).render(map_save_path)
    elif len(namelist) == 1 and len(value_dict) == 2:
        Line(init_opts=opts.InitOpts(width="1200px", height="800px")).add_xaxis(xaxis_data=asix_x). \
            add_yaxis(series_name="mean of predict " + str(namelist[0]), y_axis=value_dict[0],
                      markline_opts=opts.MarkLineOpts(
                          data=[opts.MarkLineItem(type_="average", name="平均值")]), ). \
            add_yaxis(series_name="mean of truth " + str(namelist[0]), y_axis=value_dict[1],
                      markline_opts=opts.MarkLineOpts(
                          data=[opts.MarkLineItem(type_="average", name="平均值")]), ). \
            set_global_opts(
            title_opts=opts.TitleOpts(title=str("mean of " + namelist[0]),
                                      pos_left='80%', ),
            legend_opts=opts.LegendOpts(orient = 'vertical',pos_left = '40%',),
            xaxis_opts=opts.AxisOpts(name='geo_id'),
            yaxis_opts=opts.AxisOpts(name='value of ' + str(namelist[0]),
                                     splitline_opts=opts.SplitLineOpts(is_show=True)),
            toolbox_opts=opts.ToolboxOpts(
                is_show=True,
                orient="vertical",
                pos_left="90%",
            )).render(map_save_path)
    elif len(namelist) == 2 and len(value_dict) == 6:
        Line(init_opts=opts.InitOpts(width="1200px", height="800px")).add_xaxis(xaxis_data=asix_x). \
            add_yaxis("mean of predict " + str(namelist[0]), value_dict[0], markline_opts=opts.MarkLineOpts(
            data=[opts.MarkLineItem(type_="average", name="平均值")]), ). \
            add_yaxis("mean of predict " + str(namelist[1]), value_dict[1], markline_opts=opts.MarkLineOpts(
            data=[opts.MarkLineItem(type_="average", name="平均值")]), ). \
            add_yaxis("mean of truth " + str(namelist[0]), value_dict[2], markline_opts=opts.MarkLineOpts(
            data=[opts.MarkLineItem(type_="average", name="平均值")]), ). \
            add_yaxis("mean of truth " + str(namelist[1]), value_dict[3], markline_opts=opts.MarkLineOpts(
            data=[opts.MarkLineItem(type_="average", name="平均值")]), ). \
            add_yaxis("mean of differ " + str(namelist[0]), value_dict[4], markline_opts=opts.MarkLineOpts(
            data=[opts.MarkLineItem(type_="average", name="平均值")]), ). \
            add_yaxis("mean of differ " + str(namelist[1]), value_dict[5], markline_opts=opts.MarkLineOpts(
            data=[opts.MarkLineItem(type_="average", name="平均值")]), ). \
            set_global_opts(
            title_opts=opts.TitleOpts(title=str("mean of " + str(namelist[0]) + ' & ' + str(namelist[1])),
                                      subtitle="Keep 1 decimal place (0.1)", pos_left='80%', ),
            xaxis_opts=opts.AxisOpts(name='geo_id', is_show=True,),
            yaxis_opts=opts.AxisOpts(name=str(namelist[0]) + ' & ' + str(namelist[1]) + ' value',
                                     splitline_opts=opts.SplitLineOpts(is_show=True)),
            legend_opts=opts.LegendOpts(orient='vertical', pos_left='40%', ),
            toolbox_opts=opts.ToolboxOpts(
                is_show=True,
                orient="vertical",
                pos_left="90%",
            )).render(map_save_path)


def return_data_names(file_path):
    """
    给出数据集的预测内容名称
    """
    logger.info("file_path: {}", file_path)
    path = file_path.replace('_geo_json', '')
    for files in os.listdir(path):
        if files.count('dyna') > 0:
            data = pd.read_csv(path + os.sep + files, index_col='dyna_id')
            # data = pd.read_csv('D:/PycharmProjects/Bigscity-LibCity-master/raw_data/PEMSD3/PEMSD3.dyna',index_col='dyna_id')
            if 'traffic_flow' in data:
                return ['traffic_flow']
            elif 'in_flow' in data and 'out_flow' in data:
                return ['in_flow', 'out_flow']
            elif 'inflow' in data and 'outflow' in data:
                return ['inflow', 'outflow']
            elif 'pickup' in data and 'dropoff' in data:
                return ['pickup', 'dropoff']
            elif 'traffic_speed' in data:
                return ['traffic_speed']
            elif 'traffic_intensity' in data:
                return ['traffic_intensity']
            else:
                logger.error('show_data_statis dyna 未找到可绘制的属性：{}', data)
                return ['value']
        if files.count('grid') > 0 and files.count('gridod') == 0:
            data = pd.read_csv(path + '/' + files, index_col='dyna_id')
            # test_dict = {'id': [], 'inflow': [], 'outflow': [], 'abs_flow': []}
            if 'risk' in data:
                return ['risk']
            elif 'inflow' in data and 'outflow' in data:
                return ['inflow', 'outflow']
            elif 'new_flow' in data and 'end_flow' in data:
                return ['new_flow', 'end_flow']
            elif 'pickup' in data and 'dropoff' in data:
                return ['pickup', 'dropoff']
            elif 'departing_volume' in data and 'arriving_volume' in data:
                return ['departing_volume', 'arriving_volume']
            elif 'flow' in data:
                return ['flow']
            else:
                logger.error('show_data_statis grid 未找到可绘制的属性：{}', data)
                return ['value']
        if files.count('od') > 0 or files.count('gridod') > 0:
            try:
                data = pd.read_csv(path + '/' + files, index_col='dyna_id')
                if 'outflow' in data:
                    return ['outflow']
            except Exception as ex:
                logger.error("给出数据集的预测内容名称异常：{}", ex)
                continue


def make_series_list(result, dataset_json_path):
    """
    二维数据+原数据json地址生成供热力图使用的时间序列
    """
    # result [B,T,N,F] T个时间，N个位置，F个特征
    if result.ndim == 4:
        result = result.reshape(len(result), len(result[0]), len(result[0][0]))
    # result = result.reshape(len(result), len(result[0]), len(result[0][0]))
    # 一共count_time个时间步和每个时间步geo_count个位置
    count_time = len(result[0])
    geo_count = len(result[0][0])
    result = np.array(result)
    result_mean1 = result.mean(axis=0)
    geo_mean = result_mean1.mean(axis=0)
    heat_list = []
    geo_list = []
    for i in result_mean1:
        time_list = []
        for j in i:
            item = [j]
            time_list.append(item)
        heat_list.append(time_list)
    for e in geo_mean:
        geo_list.append([e])
    view_json = json.load(open(dataset_json_path, 'r'))
    # 将坐标和特征值组合
    for i in range(len(heat_list)):
        k = 0
        for _ in view_json['features']:
            location = business.save_geojson.return_location(_)
            # print(location)
            heat_list[i][k].insert(0, location[1])
            heat_list[i][k].insert(1, location[0])
            k += 1
    index = 0
    for feature in view_json['features']:
        location = business.save_geojson.return_location(feature)
        # print(location)
        geo_list[index].insert(0, location[1])
        geo_list[index].insert(1, location[0])
        index += 1
    heat_time_list = []
    # 在通过heat_list构造geojson、
    geo = generate_geojson(geo_list)
    # 二维heat_list降为一维heat_time_list
    for loc in range(len(heat_list[0])):
        for time in range(len(heat_list)):
            heat_time_list.append(heat_list[time][loc])
    # 归一化
    heat_time_list = make_heat(heat_time_list)
    list_hm = []
    for i in range(count_time):
        list_item = []
        for k in range(geo_count):
            list_k = heat_time_list[k * count_time:(k + 1) * count_time]
            list_item.append(list_k[i])
        list_hm.append(list_item)
    return list_hm, geo


def generate_geojson(geo_list):
    # geo_list 207 * 3[lat, lng, speed]
    # 构造geojson数据，经纬度要反转一下，特征值放properties里面
    features = []
    for e in geo_list:
        # 是否特征值只有traffic_speed
        properties = {'traffic_speed': float(e[2])}
        point = geojson.Point((float(e[1]), float(e[0])))
        feature_json = geojson.Feature(geometry=point, properties=properties)
        features.append(feature_json)
    return geojson.FeatureCollection(features)


def render_grid_to_map(dataset_grid_json_path, result_json_path, background_id, map_save_path, dataset_dir):
    """
    网格型数据生成html

    :param dataset_grid_json_path: 数据集原本生成的geojson
    :param result_json_path: 结果集json
    :param background_id: 地图底图id
    :param map_save_path:保存地址
    :param dataset_dir:原始数据集解压地址
    """
    dataset_json_content = json.load(open(dataset_grid_json_path, 'r'))
    logger.info("网格型数据生成html-dataset_grid_json_path: {}", dataset_grid_json_path)
    file_data = np.load(result_json_path)
    prediction = file_data['prediction']
    truth = file_data['truth']
    dif = prediction - truth
    try:
        assert len(return_location(dataset_json_content)) > 0
        m = folium.Map(
            location=return_location(dataset_json_content),
            tiles=get_background_url(background_id),
            zoom_start=12, attr='default'
        )
        make_cor(prediction, m, dataset_json_content, dataset_dir, name='pre_Choropleth')
        make_cor(truth, m, dataset_json_content, dataset_dir, name='truth_Choropleth')
        make_cor(dif, m, dataset_json_content, dataset_dir, name='differ_Choropleth')
        folium.LayerControl().add_to(m)
        logger.info("The task result file was generated successfully, html path: " + map_save_path)
        m.save(map_save_path)
    except Exception as ex:
        logger.info("实验结果渲染 render_grid_to_map 异常：{}", ex)
        name_list = return_data_names(dataset_dir)
        pre = ((prediction.mean(axis=0)).mean(axis=0)).mean(axis=2)
        tru = ((truth.mean(axis=0)).mean(axis=0)).mean(axis=2)
        dif = ((dif.mean(axis=0)).mean(axis=0)).mean(axis=2)
        grid_pic_value_pre = []
        grid_pic_value_tru = []
        grid_pic_value_dif = []
        for i in range(len(pre)):
            for j in range(len(pre[0])):
                grid_pic_value_pre.append([int(i), int(j), round(float(pre[i][j]), 2)])
        for i in range(len(tru)):
            for j in range(len(tru[0])):
                grid_pic_value_tru.append([int(i), int(j), round(float(tru[i][j]), 2)])
        for i in range(len(dif)):
            for j in range(len(dif[0])):
                grid_pic_value_dif.append([int(i), int(j), round(float(dif[i][j]), 2)])
        grid_pic_value = [grid_pic_value_pre, grid_pic_value_tru, grid_pic_value_dif]
        form_grid_statis_html(grid_pic_value, name_list, map_save_path)


def form_grid_statis_html(grid_pic_value, name_list, map_save_path):
    """
    根据统计数据形成一个固定宽度的html页面
    """
    # os.remove(settings.ADMIN_FRONT_HTML_PATH + str(file) + ".html")

    list_x, list_y = [], []
    for item in np.unique(np.array(grid_pic_value[0])[:, 0]):
        list_x.append(str(item))
    for item in np.unique(np.array(grid_pic_value[0])[:, 1]):
        list_y.append(str(item))
    # print(list_x,list_y)
    # print(grid_pic_value[0])
    # print(name_list)
    if len(name_list) == 1:
        name = str(name_list[0])
    else:
        name = 'total ' + str(name_list[0]) + '_' + str(name_list[1])
    Heat_Statis().add_xaxis(list_x) \
        .add_yaxis('predict ' + str(name), list_y, grid_pic_value[0], ) \
        .add_yaxis('truth ' + str(name), list_y, grid_pic_value[1], ) \
        .add_yaxis('differ ' + str(name), list_y, grid_pic_value[2], ) \
        .set_global_opts(
        yaxis_opts=opts.AxisOpts(name='grid_y'),
        xaxis_opts=opts.AxisOpts(name='grid_x'),
        title_opts=opts.TitleOpts(title="mean of " + name),
        visualmap_opts=opts.VisualMapOpts(),
        legend_opts=opts.LegendOpts(orient='vertical', pos_left='40%', ),
        toolbox_opts=opts.ToolboxOpts(
            is_show=True,
            orient="vertical",
            pos_left="90%",
        ),
    ).render(map_save_path)


def make_cor(data, m, dataset_json_content, dataset_dir, name):
    """
    生成分级图
    """
    data = data.reshape(len(data), -1, 2)
    data_mean = data.mean(axis=0)
    data_mean = data_mean.mean(axis=1)
    data_list = []
    for item in data_mean:
        data_list.append([item])
    # data_list = np.array(data_list)
    list_geoid = []
    for _ in dataset_json_content['features']:
        list_geoid.append(int(_['id']))
    # list_geoid = np.array(list_geoid)
    i = 0
    for item in list_geoid:
        data_list[i].insert(0, item)
        i += 1
    # np.insert(data_list, 0, list_geoid,axis=1)
    data_list = np.array(data_list)
    csv_url = dataset_dir + "/form_cor.csv"
    np.savetxt(csv_url, X=data_list, delimiter=',')
    name_list = return_data_names(dataset_dir)
    logger.info("生成分级图-name_list: {}", name_list)
    try:
        if len(name_list) == 1:
            df = pd.read_csv(csv_url, header=None, names=['geo_id', str(name_list[0])])
            df.to_csv(csv_url, index=False)
            business.save_geojson.add_Choropleth(csv_url, m, state_geo=dataset_json_content, tag1=str(name_list[0]),
                                                 name=name)
        else:
            df = pd.read_csv(csv_url, header=None,
                             names=['geo_id', 'total_' + str(name_list[0]) + '_' + str(name_list[1])])
            df.to_csv(csv_url, index=False)
            business.save_geojson.add_Choropleth(csv_url, m, state_geo=dataset_json_content, tag1=str(name_list[0]),
                                                 tag2=str(name_list[1]),
                                                 name=name)
    except Exception:
        logger.info('该结果无法生成分级地理图')


# dataset_json_path = 'D:/PycharmProjects/Bigscity-LibCity-master/raw_data/PEMSD3_geo_json/PEMSD3_dyna.json'
# result_json_path = 'D:/PycharmProjects/Bigscity-LibCity-master/libcity/cache/2022_03_07_09_47_20_RNN_PEMSD3_predictions.npz'
# background_id = 1
# map_save_path = 'D:/PycharmProjects/Bigscity-LibCity-master/test_result_statis.html'
# dataset_dir = 'D:/PycharmProjects/Bigscity-LibCity-master/raw_data/PEMSD3_geo_json'

# dataset_json_path = 'D:/PycharmProjects/Bigscity-LibCity-master/raw_data/HZMETRO_geo_json/HZMETRO_dyna.json'
# result_json_path = 'D:/PycharmProjects/Bigscity-LibCity-master/libcity/cache/112/evaluate_cache/2022_03_07_16_26_27_RNN_HZMETRO_predictions.npz'
# background_id = 1
# map_save_path = 'D:/PycharmProjects/Bigscity-LibCity-master/test_result_statis1.html'
# dataset_dir = 'D:/PycharmProjects/Bigscity-LibCity-master/raw_data/HZMETRO_geo_json'
#
# dataset_json_path = 'D:/PycharmProjects/Bigscity-LibCity-master/raw_data/NYCTAXI202004-202006_OD_geo_json/NYCTAXI202004-202006_od.json'
# result_json_path = 'D:/PycharmProjects/Bigscity-LibCity-master/libcity/cache/2021_12_03_12_06_45_GEML_NYCTAXI202004-202006_OD_predictions.npz'
# background_id = 1
# map_save_path = 'D:/PycharmProjects/Bigscity-LibCity-master/test_result_statis4.html'
# dataset_dir = 'D:/PycharmProjects/Bigscity-LibCity-master/raw_data/NYCTAXI202004-202006_OD_geo_json'
# render_to_map(dataset_json_path, result_json_path, background_id, map_save_path, dataset_dir)

# dataset_grid_json_path = 'D:/PycharmProjects/Bigscity-LibCity-master/raw_data/NYCTAXI201401-201403_GRID_geo_json/NYCTAXI201401-201403_grid.json'
# result_json_path = 'D:/PycharmProjects/Bigscity-LibCity-master/libcity/cache/92/evaluate_cache/2022_02_24_10_59_02_STResNet_NYCTAXI201401-201403_GRID_predictions.npz'
# background_id = 5
# map_save_path = 'D:/PycharmProjects/Bigscity-LibCity-master/test_result_statis2.html'
# dataset_dir = 'D:/PycharmProjects/Bigscity-LibCity-master/raw_data/NYCTAXI201401-201403_GRID_geo_json'
#
# dataset_grid_json_path = 'D:/PycharmProjects/Bigscity-LibCity-master/raw_data/NYCBike20140409_geo_json/NYCBIKE20140409_grid.json'
# result_json_path = 'D:/PycharmProjects/Bigscity-LibCity-master/libcity/cache/113/evaluate_cache/2022_03_07_20_27_03_DMVSTNet_NYCBike20140409_predictions.npz'
# background_id = 5
# map_save_path = 'D:/PycharmProjects/Bigscity-LibCity-master/test_result_statis3.html'
# dataset_dir = 'D:/PycharmProjects/Bigscity-LibCity-master/raw_data/NYCBike20140409_geo_json'

# dataset_grid_json_path = 'D:/PycharmProjects/Bigscity-LibCity-master/raw_data/NYC_TOD_geo_json/NYC_TOD_gridod.json'
# result_json_path = 'D:/PycharmProjects/Bigscity-LibCity-master/libcity/cache/2021_11_22_16_41_52_GEML_NYC_TOD_predictions.npz'
# background_id = 1
# map_save_path = 'D:/PycharmProjects/Bigscity-LibCity-master/test_result_statis5.html'
# dataset_dir = 'D:/PycharmProjects/Bigscity-LibCity-master/raw_data/NYC_TOD_geo_json'
# render_grid_to_map(dataset_grid_json_path, result_json_path, background_id, map_save_path, dataset_dir)
