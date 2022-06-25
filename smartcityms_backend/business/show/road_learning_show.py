import os
from string import Template

from loguru import logger
from shapely import wkt
import pandas as pd
from django.conf import settings
import geojson
import folium

from business.models import Task
from common.utils import return_location, get_background_url, random_style


def dataframe_to_geojson(df):
    """
    解析dataframe对象（dataframe必须得有 wkt字段），转换为geojson数据
    """
    features = []
    for idx, row in df.iterrows():
        p = wkt.loads(row['wkt'])
        properties = row.to_dict()
        del properties['wkt']
        feature_json = geojson.Feature(geometry=p, properties=properties)
        features.append(feature_json)
    return geojson.FeatureCollection(features)


def learning_result_map(dataset_file, task, background_id):
    """
    路网表征学习 生成结果地图文件，文件名：数据集名称_task_id_result.html
    """
    # 准备csv文件路径
    csv_path = None
    result_dir = settings.EVALUATE_PATH_PREFIX + str(task.exp_id) + settings.EVALUATE_PATH_SUFFIX
    result_template = Template("${task_id}_${model}_${dataset}_result.${suffix}")
    result_file_name = result_template.safe_substitute(task_id=task.id, model=task.model,
                                                       dataset=task.dataset, suffix='csv')
    file_list = os.listdir(result_dir)
    for file in file_list:
        if file == result_file_name:
            csv_path = result_dir + file
    if not csv_path:
        logger.error('The task result csv file not found')
        return
    logger.info('learning_result_map: result file path is ' + csv_path)
    # 根据class分组
    df = pd.read_csv(csv_path)
    grouped = df.groupby('class')
    map = None
    for name, group in grouped:
        map = folium.Map(
            location=return_location(dataframe_to_geojson(group)),
            zoom_start=12,
            tiles=get_background_url(background_id),
            attr='default'
        )
        break
    if not map:
        logger.error('csv file format error')
    # 把每组的数据单独渲染一份geojson
    for name, group in grouped:
        folium.GeoJson(dataframe_to_geojson(group),
                       name=name,
                       tooltip=name,
                       style_function=random_style).add_to(map)
    # 所有geojson加完，生成html
    folium.LayerControl().add_to(map)
    map_save_path = settings.ADMIN_FRONT_HTML_PATH + dataset_file.file_name + "_" + str(task.exp_id) + "_result.html"
    map.save(map_save_path)
    logger.info('learning_result_map: the html file path is ' + map_save_path)
