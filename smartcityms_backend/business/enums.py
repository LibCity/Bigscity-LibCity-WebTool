from enum import Enum


class TaskEnum(Enum):
    """
    任务类型枚举类
    """
    TRAFFIC_STATE_PRED = 'traffic_state_pred'  # 交通状态预测
    TRAJ_LOC_PRED = 'traj_loc_pred'  # 轨迹下一跳预测
    ROAD_REPRESENTATION = 'road_representation'  # 路网表征学习
    ETA = 'eta'  # 到达时间估计
    MAP_MATCHING = 'map_matching'  # 路网匹配


class TaskStatusEnum(Enum):
    """
    任务状态枚举类
    """
    NOT_STARTED = 0  # 未开始
    IN_PROGRESS = 1  # 进行中
    COMPLETED = 2  # 已完成
    SELECTED_EXECUTE_TIME = 3  # 已选择执行时间
    ERROR = -1  # 出错


class DatasetStatusEnum(Enum):
    """
    数据集状态枚举类
    """
    ERROR = -1
    PROCESSING = 0
    PROCESSING_COMPLETE = 1  # 用来表示完成geojson文件生成
    SUCCESS = 2  # 用来表示完成html文件生成
    UN_PROCESS = 3  # 已经生成geojson但是没有进行可视化处理
    CHECK = 4  # 正在生成geojson（检查是否可以进行可视化处理）
    SUCCESS_stat = 5  # 用来表示完成html文件生成
