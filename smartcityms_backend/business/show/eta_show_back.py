import os
from string import Template

import folium
import numpy as np
import pandas as pd
import geojson
from loguru import logger
from django.conf import settings

from business.models import Task
from common.utils import get_background_url, random_style


def get_dyna_path(dataset_file):
    """
    获取数据集原始文件 .dyna 绝对路径

    :param dataset_file: 数据集文件对象 对应表 tb_file
    :return: 数据集原始文件 .dyna 绝对路径
    """
    dataset_dir = dataset_file.extract_path
    dataset_dir = dataset_dir
    file_list = os.listdir(dataset_dir)
    for file in file_list:
        if file.endswith('.dyna'):
            dyna_path = dataset_dir + os.sep + file
            logger.info('the dyna file path: ' + dyna_path)
            return dyna_path
    logger.error("eta_show get_dyna_path error")
    return None


def get_result_path(task):
    """
    获取任务结果文件npz的路径
    任务结果文件结果名称固定：result_template = Template("${task_id}_${model}_${dataset}_result.${suffix}")

    :param task: 任务对象
    :return: 结果文件npz绝对路径
    """
    result_dir = settings.EVALUATE_PATH_PREFIX + str(task.exp_id) + settings.EVALUATE_PATH_SUFFIX
    result_template = Template("${task_id}_${model}_${dataset}_result.${suffix}")
    result_file_name = result_template.safe_substitute(task_id=task.id, model=task.model,
                                               dataset=task.dataset, suffix='npz')
    file_list = os.listdir(result_dir)
    for file in file_list:
        if file == result_file_name:
            result_file_path = result_dir + file
            logger.info('the npz file path: ' + result_file_path)
            return result_file_path
    logger.error("eta_show get_result_path error, .npz not found")
    return None


def eta_result_map(dataset_file, task, background_id):
    """
    到达时间估计，生成结果地图文件，文件名：数据集名称_task_id_result.html

    :param dataset_file: 数据集文件对象 对应表 tb_file
    :param task: 任务对象
    :param background_id: 地图底图id
    """
    # 获取dyna_path
    dyna_path = get_dyna_path(dataset_file)
    # 获取结果文件npz路径
    npz_path = get_result_path(task)
    # 加载结果文件
    file_data = np.load(npz_path)
    prediction = file_data['prediction']
    truth = file_data['truth']
    traj_id = file_data['traj_id']
    # 解析npz 获取前五条轨迹数据信息
    result_traj_ids = []
    truth_and_pred = {}
    # 默认展示20条轨迹
    for i in range(20):
        truth_and_pred[traj_id[i][0]] = []
        truth_and_pred[traj_id[i][0]].append(truth[i][0])
        truth_and_pred[traj_id[i][0]].append(prediction[i][0])
        result_traj_ids.append(traj_id[i][0])
    # 加载原始数据集文件
    dyna_df = pd.read_csv(dyna_path)
    dyna_reserved_lst = ['dyna_id', 'type', 'time', 'entity_id', 'traj_id', 'coordinates']
    extra_feature = [_ for _ in list(dyna_df.columns) if _ not in dyna_reserved_lst]
    map_save_path = settings.ADMIN_FRONT_HTML_PATH + dataset_file.file_name + "_" + str(task.exp_id) + "_result.html"
    # 绘制地图
    render_to_map(dyna_df=dyna_df,
                  result_traj_ids=result_traj_ids,
                  extra_feature=extra_feature,
                  truth_and_pred=truth_and_pred,
                  save_path=map_save_path,
                  background_id=background_id)


def render_to_map(dyna_df, result_traj_ids, extra_feature, truth_and_pred, save_path, background_id):
    """
    地图绘制

    :param background_id: 底图id
    :param dyna_df: dyna dataframe
    :param result_traj_ids: 要画轨迹的id列表
    :param extra_feature: 额外的feature列表
    :param truth_and_pred: 每条轨迹的预测时间和实际时间字典
    :param save_path: 保存路径
    """
    map = None
    entity_id_groups = dyna_df.groupby('entity_id')
    # 一个用户有多条轨迹，每条轨迹刻画一个geojson渲染到地图上
    for entity_id, entity_value in entity_id_groups:
        traj_id_groups = entity_value.groupby('traj_id')
        for traj_id, traj_value in traj_id_groups:
            if traj_id in result_traj_ids:
                # 构造geojson
                result_features = []
                # properties dict
                feature_dict = {"usr_id": entity_id, "traj_id": traj_id}
                for feature in extra_feature:
                    feature_dict[feature] = float(traj_value[feature].mean())
                feature_dict['truth'] = str(truth_and_pred[traj_id][0])
                feature_dict['prediction'] = str(truth_and_pred[traj_id][1])
                # 轨迹线坐标list
                coordinates = []
                for idx, row in traj_value.iterrows():
                    coordinates.append(eval(row['coordinates']))
                feature = geojson.Feature(geometry=geojson.LineString(coordinates), properties=feature_dict)
                result_features.append(feature)
                result_json = geojson.FeatureCollection(result_features)
                # 自定义tooltip
                tooltip = folium.GeoJsonTooltip(
                    fields=["traj_id", "truth", "prediction"],
                    aliases=["轨迹id: ", "实际耗时: ", "预计耗时: "], )
                # 自定义popup
                popup = folium.GeoJsonPopup(
                    fields=["traj_id", "truth", "prediction"],
                    aliases=["轨迹id: ", "实际耗时: ", "预计耗时: "],
                    localize=True,
                    labels=True,
                )
                # 建地图
                if map is None:
                    location = coordinates[0]
                    location.reverse()
                    map = folium.Map(
                        location=location,
                        zoom_start=12,
                        tiles=get_background_url(background_id),
                        attr='default'
                    )
                folium.GeoJson(result_json,
                               name=traj_id,
                               tooltip=tooltip,
                               popup=popup,
                               style_function=random_style).add_to(map)
    folium.LayerControl().add_to(map)
    map.save(save_path)
    logger.info("eta_show result map saved, path: " + save_path)