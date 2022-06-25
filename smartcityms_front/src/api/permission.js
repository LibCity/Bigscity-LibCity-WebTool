import request from '@/utils/request'

export function getPermissionList(queryParam) {
  return request({
    url: '/auth/permission/',
    method: 'get',
    params: queryParam
  })
}

export function getPermissionTree() {
  return request({
    url: '/auth/permission/tree/',
    method: 'get'
  })
}
