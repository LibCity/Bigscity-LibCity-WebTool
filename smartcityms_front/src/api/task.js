import request from '@/utils/request'

// 列表数据查询
export function getTaskList(queryParam) {
  return request({
    url: '/business/task/',
    method: 'get',
    params: queryParam
  })
}

// 回显单个数据
export function getTaskById(taskId) {
  return request({
    url: `/business/task/${taskId}/`,
    method: 'get'
  })
}

// 新增
export function addTask(data) {
  return request({
    url: '/business/task/',
    method: 'post',
    data
  })
}

// 任务是否存在
export function taskExists(data) {
  return request({
    url: '/business/task/exists/',
    method: 'post',
    data
  })
}

// 更新
export function updateTaskById(taskId, data) {
  return request({
    url: `/business/task/${taskId}/`,
    method: 'patch',
    data
  })
}

// 更新任务公开私有状态
export function updateTaskVisibility(taskId, visibility) {
  return request({
    url: `/business/task/${taskId}/update_visibility/`,
    method: 'get',
    params: { visibility: visibility }
  })
}

// 中断实验
export function interruptExp(taskId) {
  return request({
    url: `/business/task/${taskId}/interrupt_exp/`,
    method: 'get'
  })
}

// 删除
export function deleteTaskById(taskId) {
  return request({
    url: `/business/task/${taskId}/delete/`,
    method: 'get'
  })
}

// 执行
export function executeTaskById(taskId, execute_time) {
  return request({
    url: `/business/task/${taskId}/execute/`,
    method: 'get',
    params: { execute_time: execute_time }
  })
}

// 下载
export function download_config() {
  return request({
    url: `/business/task/download/`,
    method: 'get'
  })
}

// 查看运行日志
export function getExecuteLogById(taskId) {
  return request({
    url: `/business/task/${taskId}/get_log/`,
    method: 'get'
  })
}

export function getConfigDataById(taskId) {
  return request({
    url: `/business/task/${taskId}/get_config/`,
    method: 'get'
  })
}

// 交通状态预测、到达时间估计，根据任务id获取相应指标数据
export function getStateEvaluateList(queryParam) {
  return request({
    url: '/business/evaluate/',
    method: 'get',
    params: queryParam
  })
}

// 路网匹配
export function getMapMatchingEvaluateList(queryParam) {
  return request({
    url: '/business/map_matching/',
    method: 'get',
    params: queryParam
  })
}

// 轨迹下一跳
export function getTrajEvaluateList(queryParam) {
  return request({
    url: '/business/traj_loc/',
    method: 'get',
    params: queryParam
  })
}

// 交通状态预测折线图返回数据
export function getStateLineData(queryParam) {
  return request({
    url: '/business/evaluate/contrast_line',
    method: 'get',
    params: queryParam
  })
}

// 轨迹下一跳、到达时间估计和路网匹配折线图返回数据
export function getOtherLineData(queryParam) {
  return request({
    url: '/business/evaluate/other_contrast_line',
    method: 'get',
    params: queryParam
  })
}

// 评价指标mode 交通状态预测
export function getStateMode(taskId) {
  return request({
    url: '/business/evaluate/get_evaluate_mode/',
    method: 'get',
    params: { task: taskId }
  })
}

// 更新任务状态 get_task_statue
export function getTaskStatus(taskId) {
  return request({
    url: `/business/task/${taskId}/get_task_status/`,
    method: 'get'
  })
}

// 获取任务模型对应关系字典
export function getTaskModelConfig() {
  return request({
    url: `/business/task/get_task_model_dict/`,
    method: 'get'
  })
}
