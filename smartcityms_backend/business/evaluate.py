import csv
import json
import os
from string import Template

from django.conf import settings

from business.enums import TaskEnum
from business.models import TrafficStatePredAndEta, MapMatching, TrajLocPred


def evaluate_insert(task):
    """
    指标数据入库，指标文件名称固定：evaluate_template = Template("${task_id}_${model}_${dataset}.${suffix}")

    :param task: 评价指标所属任务对象
    """
    # 数据准备
    file_dir = settings.EVALUATE_PATH_PREFIX + str(task.exp_id) + settings.EVALUATE_PATH_SUFFIX
    evaluate_template = Template("${task_id}_${model}_${dataset}")
    evaluate_name = evaluate_template.safe_substitute(task_id=task.id, model=task.model,
                                                      dataset=task.dataset)
    # 扫描文件夹下所有文件
    file_list = os.listdir(file_dir)
    for file in file_list:
        if os.path.splitext(file)[0] == evaluate_name and os.path.splitext(file)[1] == '.csv':
            csv_insert(file_dir + file, task)
        if os.path.splitext(file)[0] == evaluate_name and os.path.splitext(file)[1] == '.json':
            json_insert(file_dir + file, task)


def csv_insert(csv_path, task):
    """
    读取csv评价指标文件，插入到相应表中

    :param csv_path: csv文件路径
    :param task: 评价指标所属任务对象
    """
    csv_reader = csv.reader(open(csv_path))
    # 首行表头打上索引，可以根据表头找索引，然后根据索引找具体指标的值
    evaluate_name_index = {k: v for v, k in enumerate(csv_reader.__next__())}
    values = []
    if task.task == TaskEnum.TRAFFIC_STATE_PRED.value or task.task == TaskEnum.ETA.value:
        # 指标 -> 指标值 字典
        evaluate_value = {'MAE': None, 'MAPE': None, 'MSE': None, 'RMSE': None, 'masked_MAE': None, 'masked_MAPE': None,
                          'masked_MSE': None, 'masked_RMSE': None, 'R2': None, 'EVAR': None, 'Precision': None,
                          'Recall': None, 'F1-Score': None, 'MAP': None, 'PCC': None}
        # 读取csv
        for line in csv_reader:
            # 获取指标数据，只获取有值的数据
            for evaluate_name in evaluate_value:
                evaluate_value[evaluate_name] = line[evaluate_name_index[evaluate_name]] \
                    if evaluate_name_index.get(evaluate_name) is not None else None
            values.append(TrafficStatePredAndEta
                          (MAE=evaluate_value['MAE'], MAPE=evaluate_value['MAPE'], MSE=evaluate_value['MSE'],
                           RMSE=evaluate_value['RMSE'], masked_MAE=evaluate_value['masked_MAE'],
                           masked_MAPE=evaluate_value['masked_MAPE'], masked_MSE=evaluate_value['masked_MSE'],
                           masked_RMSE=evaluate_value['masked_RMSE'], R2=evaluate_value['R2'],
                           EVAR=evaluate_value['EVAR'], Precision=evaluate_value['Precision'],
                           Recall=evaluate_value['Recall'], F1_Score=evaluate_value['F1-Score'],
                           MAP=evaluate_value['MAP'],PCC=evaluate_value['PCC'],task=task))
        TrafficStatePredAndEta.objects.bulk_create(values)
    if task.task == TaskEnum.MAP_MATCHING.value:
        # 指标 -> 指标值 字典
        evaluate_value = {'RMF': None, 'AN': None, 'AL': None}
        for line in csv_reader:
            # 获取指标数据，只获取有值的数据
            for evaluate_name in evaluate_value:
                evaluate_value[evaluate_name] = line[evaluate_name_index[evaluate_name]] \
                    if evaluate_name_index.get(evaluate_name) is not None else None
            values.append(MapMatching(RMF=evaluate_value['RMF'], AN=evaluate_value['AN'],AL=evaluate_value['AL'],
                                      task=task))
        MapMatching.objects.bulk_create(values)


def json_insert(json_path, task):
    # 轨迹下一跳预测任务指标为json文件，列同样是可配置
    if task.task == TaskEnum.TRAJ_LOC_PRED.value:
        evaluate_value = {'Precision': None, 'Recall': None, 'F1': None, 'MRR': None, 'MAP': None, 'NDCG': None}
        with open(json_path, 'r', encoding='UTF-8') as f:
            json_dict = json.load(f)
        # 读取指标数据到evaluate_value中
        for key in json_dict:
            original_key = key
            key = key.split('@')[0]
            for evaluate_name in evaluate_value:
                if evaluate_name == key:
                    evaluate_value[evaluate_name] = json_dict[original_key] \
                        if json_dict.get(original_key) is not None else None
        TrajLocPred(Recall=evaluate_value['Recall'], Precision=evaluate_value['Precision'],
                    F1=evaluate_value['F1'], MRR=evaluate_value['MRR'], MAP=evaluate_value['MAP'],
                    NDCG=evaluate_value['NDCG'], task=task).save()
