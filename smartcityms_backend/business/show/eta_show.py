import ujson as json
import os
from string import Template

import folium
import geojson
from django.conf import settings
from loguru import logger

from common.utils import random_style, get_background_url


def get_result_path(task):
    """
    获取任务结果文件 json 的路径
    任务结果文件结果名称固定：result_template = Template("${task_id}_${model}_${dataset}_result.${suffix}")

    :param task: 任务对象
    :return: 结果文件 json 绝对路径
    """
    result_dir = settings.EVALUATE_PATH_PREFIX + str(task.exp_id) + settings.EVALUATE_PATH_SUFFIX
    result_template = Template("${task_id}_${model}_${dataset}_result.${suffix}")
    result_file_name = result_template.safe_substitute(task_id=task.id, model=task.model,
                                               dataset=task.dataset, suffix='json')
    file_list = os.listdir(result_dir)
    for file in file_list:
        if file == result_file_name:
            result_file_path = result_dir + file
            logger.info('the task result json file path: ' + result_file_path)
            return result_file_path
    logger.error("eta_show get_result_path error, .json not found")
    return None


def eta_result_map(dataset_file, task, background_id):
    """
    到达时间估计结果 gis 可视化

    :param dataset_file: 数据集文件对象
    :param task: 任务对象
    :param background_id: 地图底图 id
    """
    map = None
    json_file_path = get_result_path(task)
    # 加载解析此 json 文件 并且遍历
    with open(json_file_path, 'r') as f:
        users_and_trajs = json.load(f)
        for user_id in users_and_trajs:
            # 构造geojson
            all_features = []
            trajs = users_and_trajs[user_id]
            for traj_id in trajs:
                tarj_obj = trajs[traj_id]
                # 2013-10-27T18:45:00Z 时间格式 转为标准格式
                tarj_obj['start_time'] = tarj_obj['start_time'].replace('Z', '').replace('T', ' ')
                coordinates = tarj_obj['coordinates']
                # 去除 traj_id 没用的字段 添加有用的字段 构造为 properties
                del tarj_obj['coordinates']
                tarj_obj['user_id'] = user_id
                tarj_obj['traj_id'] = traj_id
                feature = geojson.Feature(geometry=geojson.LineString(coordinates), properties=tarj_obj)
                all_features.append(feature)
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
            # 所有轨迹都加到了features中 绘制地图
            result_geo_json = geojson.FeatureCollection(all_features)
            # 自定义tooltip
            tooltip = folium.GeoJsonTooltip(
                fields=["truth", "prediction", "user_id", "traj_id", "start_time"],
                aliases=["实际耗时: ", "预计耗时: ", "用户ID: ", "轨迹ID: ", "开始时间："], )
            # 自定义popup
            popup = folium.GeoJsonPopup(
                fields=["truth", "prediction", "user_id", "traj_id", "start_time"],
                aliases=["实际耗时: ", "预计耗时: ", "用户ID: ", "轨迹ID: ", "开始时间："],
                localize=True,
                labels=True,
            )

            folium.GeoJson(result_geo_json,
                           name=traj_id,
                           tooltip=tooltip,
                           popup=popup,
                           style_function=random_style).add_to(map)
    map.save(settings.ADMIN_FRONT_HTML_PATH + dataset_file.file_name + "_" + str(task.exp_id) + "_result.html")
