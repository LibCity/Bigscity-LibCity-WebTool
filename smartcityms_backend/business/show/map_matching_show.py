import json
import os
from string import Template

from django.conf import settings
import folium
from loguru import logger

from business.models import Task
from common.utils import return_location, get_background_url, red_style


def matching_result_map(dataset_file, task, background_id):
    """
    路网匹配，生成结果地图文件，文件名：数据集名称_task_id_result.html

    :param dataset_file: 数据集文件对象 对应表 tb_file
    :param task_id: 任务expid
    :param background_id: 地图底图id
    :return:
    """
    dataset_dir = dataset_file.extract_path
    # 准备result.json
    result_json_path = None
    result_dir = settings.EVALUATE_PATH_PREFIX + str(task.exp_id) + settings.EVALUATE_PATH_SUFFIX
    result_template = Template("${task_id}_${model}_${dataset}_result.${suffix}")
    result_file_name = result_template.safe_substitute(task_id=task.id, model=task.model,
                                                       dataset=task.dataset, suffix='json')
    file_list = os.listdir(result_dir)
    for file in file_list:
        if file == result_file_name:
            result_json_path = result_dir + file
    # 准备dataset dyna json
    dataset_dir = dataset_dir + "_geo_json"
    dataset_json_path = None
    file_list = os.listdir(dataset_dir)
    for file in file_list:
        if file.count('dyna') > 0 and file.count("truth_dyna") == 0:
            dataset_json_path = dataset_dir + os.sep + file
    # 生成地图
    if result_json_path and dataset_json_path:
        logger.info("The result json path is: " + result_json_path)
        logger.info("The dataset json path is: " + dataset_json_path)
        map_save_path = settings.ADMIN_FRONT_HTML_PATH + dataset_file.file_name + "_" + str(task.exp_id) + "_result.html"
        render_to_map(dataset_json_path, result_json_path, background_id, map_save_path)
    else:
        logger.error("result json not found")


def render_to_map(dataset_json, result_json, background_id, map_save_path):
    """
    渲染dataset_json和result_json到地图上
    """
    dataset_json_content = json.load(open(dataset_json, 'r'))
    map = folium.Map(
        location=return_location(dataset_json_content),
        zoom_start=12,
        tiles=get_background_url(background_id),
        attr='default'
    )
    # result json 渲染
    folium.GeoJson(result_json,
                   name="prediction",
                   tooltip="prediction",
                   style_function=red_style).add_to(map)
    # dataset json 渲染
    folium.GeoJson(dataset_json,
                   name="truth",
                   tooltip="truth").add_to(map)
    folium.LayerControl().add_to(map)
    logger.info("The task result file was generated successfully, html path: " + map_save_path)
    map.save(map_save_path)
