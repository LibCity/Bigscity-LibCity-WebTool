from loguru import logger

from business.enums import TaskEnum
from business.show import map_matching_show, road_learning_show, traffic_predict, eta_show
from business.models import File


def generate_result_map(task):
    """
    根据task对象的类型，生成不同的地图

    :param task: task对象
    """
    task_type = task.task
    try:
        dataset = File.objects.get(file_name=task.dataset)
    except Exception as ex:
        logger.error("generate_result_map: get dataset exception")
        logger.error(ex)
    else:
        if task_type == TaskEnum.MAP_MATCHING.value:
            # 路网匹配
            map_matching_show.matching_result_map(dataset, task, dataset.background_id)
        elif task_type == TaskEnum.ROAD_REPRESENTATION.value:
            # 路网表征学习
            road_learning_show.learning_result_map(dataset, task, dataset.background_id)
        elif task_type == TaskEnum.TRAFFIC_STATE_PRED.value:
            # 交通状态预测
            traffic_predict.matching_result_map(dataset, task, dataset.background_id)
        elif task_type == TaskEnum.ETA.value:
            # 到达时间估计
            eta_show.eta_result_map(dataset, task, dataset.background_id)
        else:
            logger.error("generate_result_map: Unknown task type")
