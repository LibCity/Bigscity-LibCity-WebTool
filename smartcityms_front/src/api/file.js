import request from '@/utils/request'

// 列表数据查询
export function getFileList(queryParam) {
  return request({
    url: '/business/file/',
    method: 'get',
    params: queryParam
  })
}

// 查询所有
export function getFileListAll() {
  return request({
    url: '/business/file/get_all/',
    method: 'get'
  })
}

// 删除
export function deleteFileById(fileId) {
  return request({
    url: `/business/file/${fileId}/delete/`,
    method: 'get'
  })
}

// 更新文件公开 私有 状态
export function updateFileVisibility(fileId, visibility) {
  return request({
    url: `/business/file/${fileId}/update_visibility/`,
    method: 'get',
    params: { visibility: visibility }
  })
}

// 展示
export function showFileByFileName(file_name) {
  return request({
    url: `/business/file/${file_name}get_gis_view/`,
    method: 'get'
  })
}

// 新增展示
export function generate_background_byID(fileId, background) {
  return request({
    url: `/business/file/${fileId}/generate_gis_view/`,
    method: 'get',
    params: { background: background }
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

// 获取数据集状态
export function getFileStatus(fileId) {
  return request({
    url: `/business/file/${fileId}/get_file_status/`,
    method: 'get'
  })
}

// 通过数据集id下载数据集
export function downloadFileById(fileId) {
  return request({
    url: `/business/file/${fileId}/download_by_id/`,
    method: 'get'
  })
}
