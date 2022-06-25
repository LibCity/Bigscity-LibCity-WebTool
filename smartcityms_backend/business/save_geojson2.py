import time
from copy import copy
from string import Template
from pyecharts import options as opts
from pyecharts.charts import Scatter, HeatMap as Heat_Statis
import dask.dataframe as dd
import branca
import folium
import pandas as pd
import ujson as json
import os
from django.conf import settings
from folium.plugins import HeatMap
from business.enums import DatasetStatusEnum
from common.utils import random_style, get_background_url, get_geojson_properties
from loguru import logger
from sklearn import preprocessing
import numpy as np


def transfer_geo_json(url, file, background_id, error_message_list):
    """
    通过文件路径获取geojson文件，根据文件的类型进行可视化
    """
    for json_file in os.listdir(url):
        # 只接收json文件
        if not json_file.endswith('.json'):
            continue
        if json_file.count('dyna') > 0:
            if json_file.count('_truth_dyna') > 0:
                pass
            else:
                file_view_status = show_geo_view(url, json_file, file, background_id, error_message_list)
                return file_view_status
        elif json_file.count('grid') > 0:
            file_view_status = show_geo_view(url, json_file, file, background_id, error_message_list)
            return file_view_status
        elif json_file.count('od') > 0:
            file_view_status = show_geo_view(url, json_file, file, background_id, error_message_list)
            return file_view_status
        elif json_file.count('geo') > 0:
            file_view_status = show_geo_view(url, json_file, file, background_id, error_message_list)
            return file_view_status
        else:
            file_view_status = show_data_statis(url, file, error_message_list)
            return file_view_status


def make_map_only(_, heat, marker_cluster, tag, mean_or_not=True):
    """
    针对只有一个变量需要展示的数据集进行展示
    :param
    _: geojson文件当中的一个feature块
    heat：用来存储热力图列表
    marker_cluster：用来添加cluster的cluster池
    tag：用来展示的目标数据标签（不能改为json中没有的名字）
    mean_or_not：是否要求tag均值
    """
    location_str = return_location(_)
    loc1 = location_str[0]
    loc = location_str[1:]
    loc.append(loc1)
    heatmap = copy(loc)
    heatmap.append(_['properties'][tag])
    heat.append(heatmap)
    # 构造popup
    properties_dict = _['properties']
    coordinates_list = _['geometry']['coordinates']
    # popup模板
    mean_template = Template("mean of ${property}: ${value}<br>")
    simple_template = Template("${property}: ${value}<br>")
    popup = ''
    if mean_or_not:
        # 遍历dict加入popup
        for key in properties_dict:
            if key == tag:
                popup += mean_template.safe_substitute(property=key, value=properties_dict[key])
            else:
                popup += simple_template.safe_substitute(property=key, value=properties_dict[key])
    else:
        for key in properties_dict:
            popup += simple_template.safe_substitute(property=key, value=properties_dict[key])
    # 最后附加经纬度相关信息
    popup += 'Latitude: ' + str(loc[0]) + '<br>'
    popup += 'Longitude: ' + str(loc[1]) + '<br>'
    folium.Marker(
        location=loc,
        popup=folium.Popup(popup, max_width=300),
    ).add_to(marker_cluster)


def make_map_double(_, heat, marker_cluster, tag1, tag2, mean_or_not=True):
    """
    针对有两个变量需要联合展示的数据集进行展示
    :param
    _: geojson文件当中的一个feature块
    heat：用来存储热力图列表
    marker_cluster：用来添加cluster的cluster池
    tag1，2：用来展示的目标数据标签（不能改为json中没有的名字）
    mean_or_not：是否要求tag均值
    """
    location_str = return_location(_)
    loc1 = location_str[0]
    loc = location_str[1:]
    loc.append(loc1)
    heatmap = copy(loc)
    heatmap.append(abs(_['properties'][tag1] + _['properties'][tag2]))
    heat.append(heatmap)
    # 构造popup
    properties_dict = _['properties']
    coordinates_list = _['geometry']['coordinates']
    # popup模板
    mean_template = Template("mean of ${property}: ${value}<br>")
    simple_template = Template("${property}: ${value}<br>")
    popup = ''
    if mean_or_not:
        # 遍历dict加入popup
        for key in properties_dict:
            if key == tag1 or key == tag2:
                popup += mean_template.safe_substitute(property=key, value=properties_dict[key])
            else:
                popup += simple_template.safe_substitute(property=key, value=properties_dict[key])
    else:
        for key in properties_dict:
            popup += simple_template.safe_substitute(property=key, value=properties_dict[key])
        # 最后附加经纬度相关信息
    popup += 'Latitude: ' + str(loc[0]) + '<br>'
    popup += 'Longitude: ' + str(loc[1]) + '<br>'
    folium.Marker(
        location=loc,
        popup=folium.Popup(popup, max_width=300),
    ).add_to(marker_cluster)


def make_heat(heat):
    """
    为热力图数据进行归一化处理
    """
    np_heat = np.array(heat[:])
    heat_value = np_heat[:, -1]
    i = 0
    for item in heat_value:
        heat_value[i] = abs(item)
        i += 1
    min_max_scaler = preprocessing.MinMaxScaler()
    X_minMax = min_max_scaler.fit_transform(heat_value.reshape(-1, 1))
    i = 0
    for item in X_minMax:
        np_heat[i, -1] = item[0]
        i += 1
    heat = np_heat.tolist()
    return heat


def make_Choropleth_csv(view_json, file, url, tag1=None, tag2=None):
    """
    生成分级图的预制csv
    :param
    view_json: 解析好的geojson文件
    file：文件名称
    url：保存的上级路径
    tag1-2：用来展示的目标数据标签（不能改为json中没有的名字）
    """
    csv_raw_data = []
    if tag2 is None:
        tag_name = tag1
        i = 0
        for _ in view_json['features']:
            geo_id = _['properties']['geo_id']
            tag_value = _['properties'][tag1]
            csv_raw_data.append([geo_id, tag_value])
            i += 1
    else:
        tag_name = 'total_' + tag1 + '_' + tag2
        i = 0
        for _ in view_json['features']:
            geo_id = _['properties']['geo_id']
            tag_value = _['properties'][tag1] + _['properties'][tag2]
            csv_raw_data.append([geo_id, tag_value])
            i += 1
    csv_column_name = ['geo_id', tag_name]
    csv_pd = pd.DataFrame(columns=csv_column_name, data=csv_raw_data)
    csv_path = f"{url}" + os.sep + f"{file}" + '.csv'
    csv_pd.to_csv(csv_path, index=False)
    return csv_path


def add_choropleth(csv_url, m, state_geo, tag1=None, tag2=None, name="choropleth"):
    """
    生成分级图
    :param
    csv_url: csv文件地址
    m：地图名称
    state_geo：geojson文件地址
    tag1-2：用来展示的目标数据标签（不能改为json中没有的名字）
    name:显示在页面上的layer名称
    """
    choropleth_data = pd.read_csv(csv_url)
    if tag2 is None:
        logger.info('only one tag provided,will use this tag to search csv')
        cp = folium.Choropleth(
            geo_data=state_geo,
            name=name,
            data=choropleth_data,
            columns=["geo_id", tag1],
            key_on="feature.id",
            fill_color="YlGn",
            fill_opacity=0.7,
            line_opacity=0.2,
            legend_name=tag1,
            highlight=True
        ).add_to(m)
        # 添加分级图 tooltip 显示
        folium.GeoJsonTooltip(fields=['geo_id', tag1],).add_to(cp.geojson)
    else:
        cp = folium.Choropleth(
            geo_data=state_geo,
            name=name,
            data=choropleth_data,
            columns=["geo_id", 'total_' + tag1 + '_' + tag2],
            key_on="feature.id",
            fill_color="YlGn",
            fill_opacity=0.7,
            line_opacity=0.2,
            legend_name='total_' + tag1 + '_' + tag2,
            highlight=True
        ).add_to(m)
        # 添加分级图 tooltip 显示
        folium.GeoJsonTooltip(fields=['geo_id', tag1, tag2],).add_to(cp.geojson)


def show_geo_view(url, json_file, file, background_id, error_message_list):
    """
    解析json文件并按照不同的展示规则进行展示
    """
    geo_layer = f"{url}" + os.sep + f"{json_file}"
    view_json = json.load(open(geo_layer, 'r'))
    _ = view_json['features'][0]
    origin_location = return_location(_)
    if origin_location is not None:
        logger.info('尝试绘制' + geo_layer + '文件的地理图象')
        background_url = get_background_url(background_id)
        try:
            feature_properties_dict = get_geojson_properties(view_json)
            feature_list = list(feature_properties_dict.keys())
            loc1 = origin_location[0]
            loc = origin_location[1:]
            loc.append(loc1)
            heat = []
            m = folium.Map(
                location=loc,
                tiles=background_url,
                zoom_start=12, attr='default'
            )
            # 去除点聚合
            # marker_cluster = MarkerCluster(name='Cluster').add_to(m)
            logger.info('background select:' + background_url)
            #   所有可能的展示组合
            #   traffic_speed / inflow, outflow / length / highway / usr_id / (last property in list)
            if 'traffic_speed' in feature_list:
                for _ in view_json['features']:
                    make_map_only(_, heat, m, tag='traffic_speed')
                heat_minmax = make_heat(heat)
                # 获取colormap 和 gradient_map
                colormap, gradient_map = get_colormap_gradient(view_json['features'], 'traffic_speed')
                colormap.add_to(m)
                HeatMap(heat_minmax, name='traffic_speed_heatmap', gradient=gradient_map).add_to(m)
            elif 'inflow' and 'outflow' in feature_list:
                # 分级图显示不加打点信息
                # for _ in view_json['features']:
                #     if _['geometry']['type'] == 'MultiPolygon':
                #         pass
                #     else:
                #         make_map_double(_, heat, m, tag1='inflow', tag2='outflow')
                # 有分级图就不加热力图了
                # heat_minmax = make_heat(heat)
                csv_url = make_Choropleth_csv(view_json, file, url, tag1='inflow', tag2='outflow')
                try:
                    add_choropleth(csv_url, m, state_geo=geo_layer, tag1='inflow', tag2='outflow', name='Cor')
                except Exception as ex:
                    logger.error('show_geo_view add_Choropleth 异常：{}', ex)
                    error_message_list.append('数据集添加分级图异常：{}'.format(ex))
                # 有分级图就不加热力图了
                # HeatMap(heat_minmax, name='total_flow_heatmap').add_to(m)
                # 分级图就不加原来的geojson了，直接显示分级图
                # folium.GeoJson(geo_layer, name=f"{json_file}", tooltip=f"{json_file}").add_to(m)
            elif 'flow' in feature_list:
                # 分级图显示不加打点信息
                # for _ in view_json['features']:
                #     if _['geometry']['type'] == 'MultiPolygon':
                #         pass
                #     else:
                #         make_map_only(_, heat, m, tag='flow')
                csv_url = make_Choropleth_csv(view_json, file, url, tag1='flow')
                try:
                    add_choropleth(csv_url, m, state_geo=geo_layer, tag1='flow', name='Choropleth of outflow')
                except Exception as ex:
                    logger.error('show_geo_view add_Choropleth 异常：{}', ex)
                    error_message_list.append('数据集添加分级图异常：{}'.format(ex))
                # 分级图就不加原来的geojson了，直接显示分级图
                # folium.GeoJson(geo_layer, name=f"{json_file}", tooltip=f"{json_file}").add_to(m)
            elif 'length' in feature_list:
                # length 移除打点，打点的话 bj_edge_roadmap 会变得鬼畜
                # for _ in view_json['features']:
                #     make_map_only(_, heat, m, 'length', mean_or_not=False)
                folium.GeoJson(geo_layer, name=f"{json_file}").add_to(m)
            elif 'traj_id' in feature_list:
                # 轨迹数据
                for _ in view_json['features']:
                    make_map_only(_, heat, m, 'traj_id', mean_or_not=False)
                # 轨迹数据添加popup和tooltip区分轨迹
                # 自定义tooltip
                tooltip = folium.GeoJsonTooltip(
                    fields=["traj_id"],
                    aliases=["轨迹id: "], )
                # 自定义popup
                popup = folium.GeoJsonPopup(
                    fields=["traj_id"],
                    aliases=["轨迹id: "],
                    localize=True,
                    labels=True,
                )
                # 轨迹数据添加颜色区分轨迹
                folium.GeoJson(geo_layer,
                               name=f"{json_file}",
                               tooltip=tooltip,
                               popup=popup,
                               style_function=random_style).add_to(m)
            elif 'usr_id' in feature_list:
                # 用户轨迹不打点
                # for _ in view_json['features']:
                #     make_map_only(_, heat, m, 'usr_id', mean_or_not=False)
                # 自定义tooltip
                usr_tooltip = folium.GeoJsonTooltip(
                    fields=["usr_id"],
                    aliases=["usr_id: "], )
                # 自定义popup
                usr_popup = folium.GeoJsonPopup(
                    fields=["usr_id"],
                    aliases=["usr_id: "],
                    localize=True,
                    labels=True,
                )
                folium.GeoJson(
                    geo_layer, name=f"{json_file}",
                    tooltip=usr_tooltip, popup=usr_popup, style_function=random_style).add_to(m)
            elif 'highway' in feature_list:
                for _ in view_json['features']:
                    make_map_only(_, heat, m, 'highway', mean_or_not=False)
                folium.GeoJson(geo_layer, name=f"{json_file}").add_to(m)
            else:
                property = str(feature_list[-1])
                for _ in view_json['features']:
                    make_map_only(_, heat, m, property, mean_or_not=False)
                folium.GeoJson(geo_layer, name=f"{json_file}").add_to(m)
            # add data point to the mark cluster
            folium.LayerControl().add_to(m)
            # 添加鼠标点击显示经纬度函数
            m.add_child(folium.LatLngPopup())
            geo_view_path = settings.ADMIN_FRONT_HTML_PATH + str(file) + ".html"
            m.save(geo_view_path)
            file_view_status = DatasetStatusEnum.SUCCESS.value
            logger.info(geo_layer + '文件的地理图象绘制成功')
        except Exception as ex:
            logger.error('show_geo_view异常：{}', ex)
            error_message_list.append('地理图象绘制异常：{}'.format(ex))
            file_view_status = show_data_statis(url, file, error_message_list)
    else:
        file_view_status = show_data_statis(url, file, error_message_list)
    return file_view_status


def return_location(block):
    """
    获取一个feature的geometry-coordinates内容并按照它是点线面来返回其定位坐标点
    """
    location = None
    if len(block['geometry']['coordinates']) > 0:
        if type(block['geometry']['coordinates'][0]) is not list:
            location = block['geometry']['coordinates']
        elif len(block['geometry']['coordinates'][0]) > 0:
            if type(block['geometry']['coordinates'][0][0]) is not list:
                location = block['geometry']['coordinates'][0]
            elif len(block['geometry']['coordinates'][0][0]) > 0:
                if type(block['geometry']['coordinates'][0][0][0]) is not list:
                    location = block['geometry']['coordinates'][0][0]
                else:
                    location = block['geometry']['coordinates'][0][0][0]
    return location


def make_statis_only(data, file, tag, name, error_message_list, grid=False, gridod=False):
    """
    利用只有一个参数，获取统计图象
    """
    if not grid and not gridod:
        try:
            x_axis = []
            value_dict = []
            for i in data.entity_id.unique():
                tag_value = getattr(data, tag)[data.entity_id == int(i)].mean()
                x_axis.append(str(i))
                value_dict.append(round(tag_value, 1))
            form_statis_html(value_dict, x_axis, file, name1=name)
            file_view_status = DatasetStatusEnum.SUCCESS_stat.value
        except Exception as ex:
            file_view_status = DatasetStatusEnum.ERROR.value
            logger.error('make_statis_only: 统计图象绘制异常(not grid)：{}', ex)
            error_message_list.append('统计图象绘制异常(not grid)：{}'.format(ex))
    elif grid:
        try:
            grid_pic_value = []
            for i in data.row_id.unique():
                for j in data.column_id.unique():
                    if name == 'risk':
                        tag_value = (getattr(data, tag)[data.row_id == int(i)][data.column_id == int(j)].mean()) * 100
                    else:
                        tag_value = getattr(data, tag)[data.row_id == int(i)][data.column_id == int(j)].mean()
                    grid_pic_value.append([int(i), int(j), tag_value])
            form_grid_statis_html(grid_pic_value, name, file)
            file_view_status = DatasetStatusEnum.SUCCESS_stat.value
            logger.info('统计图象绘制完成')
        except Exception as ex:
            file_view_status = DatasetStatusEnum.ERROR.value
            logger.error('make_statis_only: 统计图象绘制异常(grid)：{}', ex)
            error_message_list.append('统计图象绘制异常(grid)：{}'.format(ex))
    elif gridod:
        try:
            grid_pic_value = []
            for i in data.origin_row_id.unique():
                for j in data.origin_column_id.unique():
                    tag_value = getattr(data, tag)[data.origin_row_id == int(i)][
                        data.origin_column_id == int(j)].mean().compute()
                    grid_pic_value.append([int(i), int(j), tag_value])
            form_grid_statis_html(grid_pic_value, name, file)
            file_view_status = DatasetStatusEnum.SUCCESS_stat.value
            logger.info('统计图象绘制完成')
        except Exception as ex:
            file_view_status = DatasetStatusEnum.ERROR.value
            logger.error('make_statis_only: 统计图象绘制异常(gridod)：{}', ex)
            error_message_list.append('统计图象绘制异常(gridod)：{}'.format(ex))
    else:
        file_view_status = DatasetStatusEnum.ERROR.value
        logger.error('make_statis_only: 统计图象绘制异常(grid)：{}')
        error_message_list.append('统计图象绘制异常，无法识别文件类型')
    return file_view_status


def make_statis_double(data, file, tag1, tag2, name, error_message_list, grid=False):
    """
    利用两个参数，获取统计图象
    """
    if not grid:
        try:
            x_axis = []
            value_dict = [[], []]
            for i in data.entity_id.unique():
                tag1_value = getattr(data, tag1)[data.entity_id == int(i)].mean()
                tag2_value = getattr(data, tag2)[data.entity_id == int(i)].mean()
                x_axis.append(str(i))
                value_dict[0].append(round(tag1_value, 1))
                value_dict[1].append(round(tag2_value, 1))
            form_statis_html(value_dict, x_axis, file, name1=tag1, name2=tag2)
            file_view_status = DatasetStatusEnum.SUCCESS_stat.value
        except Exception as ex:
            file_view_status = DatasetStatusEnum.ERROR.value
            logger.error('make_statis_double: 统计图象绘制异常(not grid)：{}', ex)
            error_message_list.append('统计图象绘制异常(not grid)：{}'.format(ex))
    else:
        try:
            grid_pic_value = []
            for i in data.row_id.unique():
                for j in data.column_id.unique():
                    tag1_value = getattr(data, tag1)[data.row_id == int(i)][data.column_id == int(j)].mean()
                    tag2_value = getattr(data, tag2)[data.row_id == int(i)][data.column_id == int(j)].mean()
                    grid_pic_value.append([int(i), int(j), tag1_value + tag2_value])
            form_grid_statis_html(grid_pic_value, name, file)
            file_view_status = DatasetStatusEnum.SUCCESS_stat.value
            logger.info('统计图象绘制完成')
        except Exception as ex:
            file_view_status = DatasetStatusEnum.ERROR.value
            logger.error('make_statis_double: 统计图象绘制异常(grid)：{}', ex)
            error_message_list.append('统计图象绘制异常(grid)：{}'.format(ex))
    return file_view_status


def show_data_statis(url, file, error_message_list):
    """
    如果无法展示其地理图象则将其描述性统计数据展示
    """
    file_path = url.replace('_geo_json', '')
    for files in os.listdir(file_path):
        if files.count('dyna') > 0:
            logger.info('尝试绘制' + files + '文件的[dyna]统计图象')
            data = pd.read_csv(settings.DATASET_PATH + file + os.sep + files, index_col='dyna_id')
            if 'traffic_flow' in data:
                file_view_status = make_statis_only(data, file, tag='traffic_flow', name='total_traffic_flow',
                                                    error_message_list=error_message_list)
                return file_view_status
            elif 'in_flow' in data and 'out_flow' in data:
                file_view_status = make_statis_double(data, file, 'in_flow', 'out_flow', 'total_flow',
                                                      error_message_list)
                return file_view_status
            elif 'inflow' in data and 'outflow' in data:
                file_view_status = make_statis_double(data, file, 'inflow', 'outflow', 'total_flow', error_message_list)
                return file_view_status
            elif 'pickup' in data and 'dropoff' in data:
                file_view_status = make_statis_double(data, file, 'pickup', 'dropoff', 'total_quantity', error_message_list)
                return file_view_status
            elif 'traffic_speed' in data:
                file_view_status = make_statis_only(data, file, tag='traffic_speed', name='traffic_speed',
                                                    error_message_list=error_message_list)
                return file_view_status
            elif 'traffic_intensity' in data:
                file_view_status = make_statis_only(data, file, tag='traffic_intensity', name='traffic_intensity',
                                                    error_message_list=error_message_list)
                return file_view_status
            else:
                file_view_status = DatasetStatusEnum.ERROR.value
                logger.error('show_data_statis dyna 未找到可绘制的属性：{}', data)
                error_message_list.append('dyna 未找到可绘制的属性：{}'.format(data))
                return file_view_status
        elif files.count('grid') > 0 and files.count('gridod') == 0:
            logger.info('尝试绘制' + files + '文件的[grid]统计图象')
            data = pd.read_csv(settings.DATASET_PATH + file + '/' + files, index_col='dyna_id')
            # test_dict = {'id': [], 'inflow': [], 'outflow': [], 'abs_flow': []}
            if 'risk' in data:
                file_view_status = make_statis_only(data, file, tag='risk', name='risk', grid=True,
                                                    error_message_list=error_message_list)
                return file_view_status
            elif 'inflow' in data and 'outflow' in data:
                file_view_status = make_statis_double(data, file, 'inflow', 'outflow', 'total_flow',
                                                      error_message_list=error_message_list, grid=True)
                return file_view_status
            elif 'new_flow' in data and 'end_flow' in data:
                file_view_status = make_statis_double(data, file, 'new_flow', 'end_flow', 'new&end_flow',
                                                      error_message_list=error_message_list, grid=True)
                return file_view_status
            elif 'pickup' in data and 'dropoff' in data:
                file_view_status = make_statis_double(data, file, 'pickup', 'dropoff', 'total_quantity',
                                                      error_message_list=error_message_list, grid=True)
                return file_view_status
            elif 'departing_volume' in data and 'arriving_volume' in data:
                file_view_status = make_statis_double(data, file, 'departing_volume', 'arriving_volume', 'total_volume',
                                                      error_message_list=error_message_list, grid=True)
                return file_view_status
            elif 'flow' in data:
                file_view_status = make_statis_only(data, file, tag='flow', name='flow',
                                                    error_message_list=error_message_list, grid=True)
                return file_view_status
            else:
                file_view_status = DatasetStatusEnum.ERROR.value
                logger.error('show_data_statis grid 未找到可绘制的属性：{}', data)
                error_message_list.append('grid 未找到可绘制的属性：{}'.format(data))
                return file_view_status
        elif files.count('gridod') > 0:
            logger.info('尝试绘制' + files + '文件的[gridod]统计图象')
            try:
                data = dd.read_csv(settings.DATASET_PATH + file + '/' + files)
                # test_dict = {'id': [], 'inflow': [], 'outflow': [], 'abs_flow': []}
                if 'flow' in data:
                    file_view_status = make_statis_only(data, file, tag='flow', name='flow(daily)',
                                                        error_message_list=error_message_list, gridod=True)
                    return file_view_status
            except Exception as ex:
                logger.error("{} gridod 文件读取错误，异常信息：{}", settings.DATASET_PATH + file + '/' + files, ex)
                continue


def form_statis_html(value_dict, asix_x, file, name1=None, name2=None):
    """
    根据统计数据形成一个固定宽度的html页面
    """
    if name2 is None:
        pic = (Scatter()
               .add_xaxis(asix_x)
               .add_yaxis("mean of " + name1, value_dict, label_opts=opts.LabelOpts(is_show=False), )
               .set_global_opts(
            title_opts=opts.TitleOpts(title=str("mean of " + name1), subtitle="Keep 1 decimal place (0.1)",
                                      pos_left='80%', ),
            xaxis_opts=opts.AxisOpts(name='entity_id', splitline_opts=opts.SplitLineOpts(is_show=True)),
            yaxis_opts=opts.AxisOpts(name='value of ' + name1, splitline_opts=opts.SplitLineOpts(is_show=True)),
            toolbox_opts=opts.ToolboxOpts(
                is_show=True,
                orient="vertical",
                pos_left="90%",
            ))
               .render(settings.ADMIN_FRONT_HTML_PATH + str(file) + ".html"))
    else:
        pic = (Scatter()
               .add_xaxis(asix_x)
               .add_yaxis("mean of " + name1, value_dict[0], label_opts=opts.LabelOpts(is_show=False), )
               .add_yaxis("mean of " + name2, value_dict[1], label_opts=opts.LabelOpts(is_show=False), )
               .set_global_opts(
            title_opts=opts.TitleOpts(title=str("mean of " + name1 + ' & ' + name2),
                                      subtitle="Keep 1 decimal place (0.1)", pos_left='80%', ),
            xaxis_opts=opts.AxisOpts(name='entity_id', splitline_opts=opts.SplitLineOpts(is_show=True)),
            yaxis_opts=opts.AxisOpts(name=name1 + ' & ' + name2 + ' value',
                                     splitline_opts=opts.SplitLineOpts(is_show=True)),
            toolbox_opts=opts.ToolboxOpts(
                is_show=True,
                orient="vertical",
                pos_left="90%",
            )).render(settings.ADMIN_FRONT_HTML_PATH + str(file) + ".html"))


def form_grid_statis_html(grid_pic_value, name, file):
    """
    根据统计数据形成一个固定宽度的html页面
    """
    # os.remove(settings.ADMIN_FRONT_HTML_PATH + str(file) + ".html")

    list_x, list_y = [], []
    for item in np.unique(np.array(grid_pic_value)[:, 0]):
        list_x.append(str(item))
    for item in np.unique(np.array(grid_pic_value)[:, 1]):
        list_y.append(str(item))
    if name == 'risk':
        name = 'risk (%)'
    pic = (
        Heat_Statis()
            .add_xaxis(list_x)
            .add_yaxis(
            name,
            list_y,
            grid_pic_value,
        )
            .set_global_opts(
            yaxis_opts=opts.AxisOpts(name='grid_y'),
            xaxis_opts=opts.AxisOpts(name='grid_x'),
            title_opts=opts.TitleOpts(title="mean of " + name),
            visualmap_opts=opts.VisualMapOpts(),
            toolbox_opts=opts.ToolboxOpts(
                is_show=True,
                orient="vertical",
                pos_left="90%",
            ),
        )
            .render(settings.ADMIN_FRONT_HTML_PATH + str(file) + ".html")
    )


class VisHelper:
    """
    生成json处理类
    """

    def __init__(self, dataset, save_path, error_message_list):
        try:
            self.raw_path = settings.DATASET_PATH
            logger.info('当前配置数据集存储路径 raw_data 路径为：{}', self.raw_path)
            self.dataset = dataset
            logger.info("当前数据集名称为：{}", self.dataset)
            self.save_path = save_path
            logger.info("当前数据集生成的 geojson 文件存储路径为：{}", self.save_path)
            self.file_form_status = DatasetStatusEnum.ERROR.value
            self.error_message_list = error_message_list
            # get type
            self.config_path = self.raw_path + self.dataset + os.sep + 'config.json'
            logger.info("当前数据集 config.json 文件路径为：{}", self.config_path)
            self.data_config = json.load(open(self.config_path, 'r'))
            if 'dyna' in self.data_config and ['state'] == self.data_config['dyna']['including_types']:
                self.type = 'state'
            elif 'grid' in self.data_config and ['state'] == self.data_config['grid']['including_types']:
                self.type = 'grid'
            elif 'gridod' in self.data_config and ['state'] == self.data_config['gridod']['including_types']:
                self.type = 'gridod'
            elif 'od' in self.data_config and ['state'] == self.data_config['od']['including_types']:
                self.type = 'od'
            elif 'dyna' in self.data_config and ['trajectory'] == self.data_config['dyna']['including_types']:
                self.type = 'trajectory'
            else:
                self.type = 'geo'
            # else:
            #     self.type = 'trajectory'
            logger.info('数据集类型: {}', self.type)
            # get geo and dyna files
            all_files = os.listdir(self.raw_path + self.dataset)
            self.geo_file = []
            self.geo_path = None
            self.dyna_file = []
            self.dyna_path = None
            self.grid_file = []
            self.grid_path = None
            self.gridod_file = []
            self.gridod_path = None
            self.od_file = []
            self.od_path = None
            for file in all_files:
                if file.split('.')[1] == 'geo':
                    self.geo_file.append(file)
                if file.split('.')[1] == 'dyna':
                    self.dyna_file.append(file)
                if file.split('.')[1] == 'grid':
                    self.grid_file.append(file)
                if file.split('.')[1] == 'gridod':
                    self.gridod_file.append(file)
                if file.split('.')[1] == 'od':
                    self.od_file.append(file)
            try:
                assert len(self.geo_file) == 1
            except Exception as ex:
                logger.error('文件当中没有geo文件, 异常信息：{}', ex)
                error_message_list.append('文件当中没有geo文件, 异常信息：{}'.format(ex))

            # reserved columns
            self.geo_reserved_lst = ['type', 'coordinates']
            self.dyna_reserved_lst = ['dyna_id', 'type', 'time', 'entity_id', 'traj_id', 'coordinates']
            self.grid_reserved_lst = ['dyna_id', 'type', 'time', 'row_id', 'column_id']
            self.od_reserved_lst = ['dyna_id', 'type', 'time', 'origin_id', 'destination_id']
            self.gridod_reserved_lst = ['dyna_id', 'type', 'time', 'origin_row_id', 'origin_column_id',
                                        'destination_row_id', 'destination_column_id']
        except Exception as ex:
            logger.error('解析数据集失败，config文件无法识别或文件夹为空, 异常信息：{}', ex)
            error_message_list.append('解析数据集失败，config文件无法识别或文件夹为空, 异常信息：{}'.format(ex))

    def visualize(self):
        """
        根据conf文件中的数据集类型生成json
        """
        try:
            if self.type == 'trajectory':
                # geo
                try:
                    self.geo_path = self.raw_path + self.dataset + '/' + self.geo_file[0]
                    self._visualize_geo()
                except Exception as ex:
                    logger.error('（trajectory）：文件当中没有geo文件或geo文件解析失败, 异常信息：{}', ex)
                    self.error_message_list.append('（trajectory）：文件当中没有geo文件或geo文件解析失败, 异常信息：{}'.format(ex))
                # dyna
                for dyna_file in self.dyna_file:
                    try:
                        self.dyna_path = self.raw_path + self.dataset + '/' + dyna_file
                        self._visualize_dyna()
                    except Exception as ex:
                        logger.error('（trajectory）：文件当中没有dyna文件或dyna文件解析失败, 异常信息：{}', ex)
                        self.error_message_list.append('（trajectory）：文件当中没有dyna文件或dyna文件解析失败, 异常信息：{}'.format(ex))
            elif self.type == 'state':
                self.geo_path = self.raw_path + self.dataset + '/' + self.geo_file[0]
                for dyna_file in self.dyna_file:
                    self.dyna_path = self.raw_path + self.dataset + '/' + dyna_file
                    self._visualize_state()
            elif self.type == 'grid':
                self.geo_path = self.raw_path + self.dataset + '/' + self.geo_file[0]
                for grid_file in self.grid_file:
                    self.grid_path = self.raw_path + self.dataset + '/' + grid_file
                    self._visualize_grid()
            elif self.type == 'gridod':
                self.geo_path = self.raw_path + self.dataset + '/' + self.geo_file[0]
                for gridod_file in self.gridod_file:
                    self.gridod_path = self.raw_path + self.dataset + '/' + gridod_file
                    self._visualize_gridod()
            elif self.type == 'od':
                self.geo_path = self.raw_path + self.dataset + '/' + self.geo_file[0]
                for od_file in self.od_file:
                    self.od_path = self.raw_path + self.dataset + '/' + od_file
                    self._visualize_od()
            elif self.type == 'geo':
                # geo
                self.geo_path = self.raw_path + self.dataset + '/' + self.geo_file[0]
                self._visualize_geo()
            self.file_form_status = DatasetStatusEnum.PROCESSING_COMPLETE.value
            return self.file_form_status
        except Exception as ex:
            logger.error("visualize：解析数据集失败，异常信息：{}", ex)
            self.error_message_list.append("可视化数据集失败，异常信息：{}".format(ex))
            return DatasetStatusEnum.ERROR.value

    def _visualize_state(self):
        """
        state-->json
        """
        geo_file = pd.read_csv(self.geo_path, index_col=None, nrows=500)
        dyna_file = pd.read_csv(self.dyna_path, index_col=None)
        geojson_obj = {'type': "FeatureCollection", 'features': []}

        # get feature_lst
        geo_feature_lst = [_ for _ in list(geo_file.columns) if _ not in self.geo_reserved_lst]
        dyna_feature_lst = [_ for _ in list(dyna_file.columns) if _ not in self.dyna_reserved_lst]

        geojson_obj = self._visualize_state_normal(geo_file, dyna_file, geo_feature_lst, dyna_feature_lst, geojson_obj)
        ensure_dir(self.save_path)
        save_name = "_".join(self.dyna_path.split('/')[-1].split('.')) + '.json'
        json.dump(geojson_obj, open(self.save_path + '/' + save_name, 'w',
                                    encoding='utf-8'),
                  ensure_ascii=False, indent=4)

    def _visualize_state_normal(self, geo_file, dyna_file, geo_feature_lst, dyna_feature_lst, geojson_obj):
        """
        state（not timeseries）-->json
        """
        for _, row in geo_file.iterrows():
            # get feature dictionary
            geo_id = row['geo_id']
            feature_dct = row[geo_feature_lst].to_dict()
            dyna_i = dyna_file[dyna_file['entity_id'] == geo_id]
            for f in dyna_feature_lst:
                feature_dct[f] = float(dyna_i[f].mean())

            # form a feature
            feature_i = dict()
            feature_i['type'] = 'Feature'
            feature_i['id'] = geo_id
            feature_i['properties'] = feature_dct
            feature_i['geometry'] = {}
            coordinates = eval(row['coordinates'])
            # 判断坐标是否是只有一个点LineString
            if row['type'] == 'LineString' and len(coordinates) == 1 and type(coordinates[0]) == list:
                feature_i['geometry']['type'] = 'Point'
                feature_i['geometry']['coordinates'] = coordinates[0]
            else:
                feature_i['geometry']['type'] = row['type']
                feature_i['geometry']['coordinates'] = eval(row['coordinates'])
            geojson_obj['features'].append(feature_i)
        return geojson_obj

    def _visualize_state_time(self, geo_file, dyna_file, geo_feature_lst, dyna_feature_lst, geojson_obj):
        """
        state（timeseries）-->json
        """
        for _, row in geo_file.iterrows():
            # get feature dictionary
            geo_id = row['geo_id']
            feature_dct = row[geo_feature_lst].to_dict()
            dyna_i = dyna_file[dyna_file['entity_id'] == geo_id]
            listi = []

            for f in dyna_feature_lst:
                time_count = dyna_i[f].size
                batch = int(time_count // 50)
                for i in range(50):
                    feature_dct[f] = float(dyna_i[f][i * batch:(i + 1) * batch].mean())
                    # for item in feature_dct[f]:
                    feature_dcti = row[geo_feature_lst].to_dict()
                    feature_dcti[f] = feature_dct[f] / 100
                    # 处理为0-1的数值
                    # print(feature_dcti[f])
                    listi.append(feature_dcti[f])
                    feature_i = dict()
                    feature_i['type'] = 'Feature'
                    feature_i['properties'] = feature_dcti
                    feature_i['geometry'] = {}
                    feature_i['geometry']['type'] = row['type']
                    feature_i['geometry']['coordinates'] = eval(row['coordinates'])
                    # print(feature_i)
                    geojson_obj['features'].append(feature_i)
        return geojson_obj

    def _visualize_grid(self):
        """
        grid-->json
        """
        geo_file = pd.read_csv(self.geo_path, index_col=None)
        grid_file = pd.read_csv(self.grid_path, index_col=None)
        geojson_obj = {'type': "FeatureCollection", 'features': []}

        # get feature_lst
        geo_feature_lst = [_ for _ in list(geo_file.columns) if _ not in self.geo_reserved_lst]
        grid_feature_lst = [_ for _ in list(grid_file.columns) if _ not in self.grid_reserved_lst]

        for _, row in geo_file.iterrows():
            geo_id = row['geo_id']
            # get feature dictionary
            row_id, column_id = row['row_id'], row['column_id']
            feature_dct = row[geo_feature_lst].to_dict()
            dyna_i = grid_file[(grid_file['row_id'] == row_id) & (grid_file['column_id'] == column_id)]
            for f in grid_feature_lst:
                feature_dct[f] = float(dyna_i[f].mean())

            # form a feature
            feature_i = dict()
            feature_i['type'] = 'Feature'
            feature_i['id'] = geo_id
            feature_i['properties'] = feature_dct
            feature_i['geometry'] = {}
            feature_i['geometry']['type'] = row['type']
            feature_i['geometry']['coordinates'] = eval(row['coordinates'])
            geojson_obj['features'].append(feature_i)

        ensure_dir(self.save_path)
        save_name = "_".join(self.grid_path.split('/')[-1].split('.')) + '.json'
        json.dump(geojson_obj, open(self.save_path + '/' + save_name, 'w',
                                    encoding='utf-8'),
                  ensure_ascii=False, indent=4)

    def _visualize_gridod(self):
        """
        gridod-->json
        """
        logger.info("gridod文件转geojson: self.geo_path: {} self.gridod_path: {}", self.geo_path, self.gridod_path)
        geo_file = pd.read_csv(self.geo_path, index_col=None, nrows=2)
        gridod_file = dd.read_csv(self.gridod_path)
        geojson_obj = {'type': "FeatureCollection", 'features': []}
        # get feature_lst
        geo_feature_lst = [_ for _ in list(geo_file.columns) if _ not in self.geo_reserved_lst]
        logger.info("gridod文件转geojson: geo_feature_lst: {}", geo_feature_lst)
        gridod_feature_lst = [_ for _ in list(gridod_file.columns) if _ not in self.gridod_reserved_lst]
        logger.info("gridod文件转geojson: gridod_feature_lst: {}", gridod_feature_lst)
        for _, row in geo_file.iterrows():
            geo_id = row['geo_id']
            # get feature dictionary origin_row_id', 'origin_column_id
            row_id, column_id = row['row_id'], row['column_id']
            feature_dct = row[geo_feature_lst].to_dict()
            dyna_i = gridod_file[
                (gridod_file['origin_row_id'] == row_id) & (gridod_file['origin_column_id'] == column_id)]
            for f in gridod_feature_lst:
                feature_dct[f] = float(dyna_i[f].mean().compute())

            # form a feature
            feature_i = dict()
            feature_i['type'] = 'Feature'
            feature_i['id'] = geo_id
            feature_i['properties'] = feature_dct
            feature_i['geometry'] = {}
            feature_i['geometry']['type'] = row['type']
            feature_i['geometry']['coordinates'] = eval(row['coordinates'])
            geojson_obj['features'].append(feature_i)

        ensure_dir(self.save_path)
        save_name = "_".join(self.gridod_path.split('/')[-1].split('.')) + '.json'
        json.dump(geojson_obj, open(self.save_path + '/' + save_name, 'w',
                                    encoding='utf-8'),
                  ensure_ascii=False, indent=4)

    def _visualize_od(self):
        """
        od-->json
        """
        geo_file = pd.read_csv(self.geo_path, index_col=None, nrows=3)
        od_file = dd.read_csv(self.od_path)
        geojson_obj = {'type': "FeatureCollection", 'features': []}
        # get feature_lst
        geo_feature_lst = [_ for _ in list(geo_file.columns) if _ not in self.geo_reserved_lst]
        logger.info("od文件转geojson: geo_feature_lst: {}", geo_feature_lst)
        od_feature_lst = [_ for _ in list(od_file.columns) if _ not in self.od_reserved_lst]
        logger.info("od文件转geojson: od_feature_lst: {}", od_feature_lst)
        for _, row in geo_file.iterrows():
            # get feature dictionary
            geo_id = row['geo_id']
            feature_dct = row[geo_feature_lst].to_dict()
            dyna_i = od_file[od_file['origin_id'] == geo_id]
            for f in od_feature_lst:
                feature_dct[f] = float(dyna_i[f].mean().compute())

            # form a feature
            feature_i = dict()
            feature_i['type'] = 'Feature'
            feature_i['id'] = geo_id
            feature_i['properties'] = feature_dct
            feature_i['geometry'] = {}
            feature_i['geometry']['type'] = row['type']
            feature_i['geometry']['coordinates'] = eval(row['coordinates'])
            geojson_obj['features'].append(feature_i)

        ensure_dir(self.save_path)
        save_name = "_".join(self.od_path.split('/')[-1].split('.')) + '.json'
        json.dump(geojson_obj, open(self.save_path + '/' + save_name, 'w',
                                    encoding='utf-8'),
                  ensure_ascii=False, indent=4)

    def _visualize_geo(self):
        """
        geo-->json
        """
        geo_file = pd.read_csv(self.geo_path, index_col=None)
        if "coordinates" not in list(geo_file.columns):
            return
        geojson_obj = {'type': "FeatureCollection", 'features': []}
        logger.info('加载的 geo 文件信息')
        geo_file.info(memory_usage='deep')
        extra_feature = [_ for _ in list(geo_file.columns) if _ not in self.geo_reserved_lst]
        # 按行遍历 性能优化
        for row in geo_file.itertuples():
            feature_dct = {}
            for property in extra_feature:
                feature_dct[property] = getattr(row, property)
            feature_i = dict()
            feature_i['type'] = 'Feature'
            feature_i['properties'] = feature_dct
            feature_i['geometry'] = {}
            feature_i['geometry']['type'] = row.type
            feature_i['geometry']['coordinates'] = eval(row.coordinates)
            if len(feature_i['geometry']['coordinates']) == 0:
                return
            geojson_obj['features'].append(feature_i)

        ensure_dir(self.save_path)
        save_name = "_".join(self.geo_path.split('/')[-1].split('.')) + '.json'
        # 写入磁盘，比较耗时
        json.dump(geojson_obj, open(self.save_path + '/' + save_name, 'w',
                                    encoding='utf-8'),
                  ensure_ascii=False, indent=4)

    def _visualize_dyna(self):
        """
        dyna-->json
        """
        dyna_file = pd.read_csv(self.dyna_path, index_col=None)

        dyna_feature_lst = [_ for _ in list(dyna_file.columns) if _ not in self.dyna_reserved_lst]
        geojson_obj = {'type': "FeatureCollection", 'features': []}
        GPS_traj = "coordinates" in dyna_file.columns
        geo_file = None
        if self.geo_path is not None:
            geo_file = pd.read_csv(self.geo_path, index_col=None)

        grouped_dyna_file = dyna_file.groupby("entity_id")
        if not GPS_traj and geo_file is not None:
            i = 0
            for entity_id, entity_value in grouped_dyna_file:
                feature_i = None
                if i < 3:
                    try:
                        feature_dct = {"usr_id": entity_id}
                        feature_i = dict()
                        feature_i['type'] = 'Feature'
                        feature_i['properties'] = feature_dct
                        feature_i['geometry'] = {}
                        feature_i['geometry']['type'] = "LineString"
                        feature_i['geometry']['coordinates'] = []
                        for _, row in entity_value.iterrows():
                            coor = eval(geo_file.loc[row['location'], 'coordinates'])
                            feature_i['geometry']['coordinates'].append(coor)
                        i += 1
                    except Exception as ex:
                        logger.error('dyna_file 无法找到位置信息，异常信息：{}', ex)
                        self.error_message_list.append('dyna 文件无法找到位置信息，异常信息：{}'.format(ex))
                else:
                    break
                if len(feature_i['geometry']['coordinates']) > 0:
                    geojson_obj['features'].append(feature_i)
        else:
            if "traj_id" in dyna_file.columns:
                trajectory = {}
                i = 0
                for entity_id, entity_value in grouped_dyna_file:
                    if i < 3:
                        trajectory[entity_id] = {}
                        entity_value = entity_value.groupby("traj_id")
                        for traj_id, traj_value in entity_value:
                            feature_dct = {"usr_id": entity_id, "traj_id": traj_id}
                            for f in dyna_feature_lst:
                                # 有的值是不能求平均的
                                try:
                                    feature_dct[f] = float(traj_value[f].mean())
                                except Exception as ex:
                                    logger.error("{} 值不能求平均, 异常信息 {}", f, ex)
                                    feature_dct[f] = None
                            feature_i = dict()
                            feature_i['type'] = 'Feature'
                            feature_i['properties'] = feature_dct
                            feature_i['geometry'] = {}
                            feature_i['geometry']['type'] = "LineString"
                            feature_i['geometry']['coordinates'] = []
                            for _, row in traj_value.iterrows():
                                feature_i['geometry']['coordinates'].append(eval(row['coordinates']))
                            geojson_obj['features'].append(feature_i)
                            i += 1
                    else:
                        break

            else:
                for entity_id, entity_value in grouped_dyna_file:
                    feature_dct = {"usr_id": entity_id}
                    feature_i = dict()
                    feature_i['type'] = 'Feature'
                    feature_i['properties'] = feature_dct
                    feature_i['geometry'] = {}
                    feature_i['geometry']['type'] = "LineString"
                    feature_i['geometry']['coordinates'] = []
                    for _, row in entity_value.iterrows():
                        feature_i['geometry']['coordinates'].append(eval(row['coordinates']))
                    geojson_obj['features'].append(feature_i)
        ensure_dir(self.save_path)
        save_name = "_".join(self.dyna_path.split('/')[-1].split('.')) + '.json'
        json.dump(geojson_obj, open(self.save_path + '/' + save_name, 'w',
                                    encoding='utf-8'),
                  ensure_ascii=False, indent=4)


def ensure_dir(dir_path):
    """Make sure the directory exists, if it does not exist, create it.

    Args:
        dir_path (str): directory path
    """
    if not os.path.exists(dir_path):
        os.makedirs(dir_path)


def get_geo_json(dataset, save_path, error_message_list):
    """
    生成geojson文件
    """
    try:
        helper = VisHelper(dataset, save_path, error_message_list)
        file_form_status = helper.visualize()
        return file_form_status
    except Exception as ex:
        file_form_status = DatasetStatusEnum.ERROR.value
        logger.error('get_geo_json生成geojson出现异常：{}', ex)
        error_message_list.append('数据集解析异常，请检查数据集格式，异常信息：{}'.format(ex))
        return file_form_status


def get_colormap_gradient(features, tag):
    """
    根据地图的features构造colormap和热力图的gradient_map

    :param features: features
    :param tag: properties中的key
    :return: colormap和热力图的gradient_map
    """
    weight_list = []
    for feature in features:
        weight = feature['properties'][tag]
        weight_list.append(weight)
    min_weight = np.min(weight_list)
    max_weight = np.max(weight_list)
    # 构造color_map
    steps = 5
    color_map = branca.colormap.linear.YlOrRd_09.scale(min_weight, max_weight).to_step(steps)
    color_map.caption = tag
    gradient_map = {}
    # 构造 gradient_map
    index_values = color_map.index
    logger.info('colormap index values: {}', index_values)
    res_values = []
    for x in index_values:
        x = float(x - np.min(index_values)) / (np.max(index_values) - np.min(index_values))
        res_values.append(x)
    for i in range(len(res_values)):
        gradient_map[res_values[i]] = color_map.rgb_hex_str(index_values[i])
    logger.info('gradient_map构造完毕：{}', gradient_map)
    return color_map, gradient_map


if __name__ == '__main__':
    file = 'NYC_TOD'
    background_id = 7
    extract_path = 'D:\\PycharmProjects\\Bigscity-LibCity-master\\raw_data\\NYC_TOD'
    file_form_status = get_geo_json(file, extract_path + '_geo_json')
    # url = extract_path + '_geo_json'
    # for json_file in os.listdir(url):
    #     if json_file.count('dyna') > 0:
    #         if json_file.count('_truth_dyna') > 0:
    #             pass
    #         else:
    #             file_view_status = show_geo_view(url, json_file, file, background_id)
    #     elif json_file.count('grid') > 0:
    #         file_view_status = show_geo_view(url, json_file, file, background_id)
    #     elif json_file.count('od') > 0:
    #         file_view_status = show_geo_view(url, json_file, file, background_id)
    #     elif json_file.count('geo') > 0:
    #         file_view_status = show_geo_view(url, json_file, file, background_id)
    #     else:
    #         file_view_status = show_data_statis(url, file)
    # print(file_view_status)
