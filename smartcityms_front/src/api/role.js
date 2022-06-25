import request from '@/utils/request'

// 列表数据查询
export function getRoleList(queryParam) {
  return request({
    url: '/auth/role/',
    method: 'get',
    params: queryParam
  })
}

// 回显单个权限数据
export function getRoleById(roleId) {
  return request({
    url: `/auth/role/${roleId}/`,
    method: 'get'
  })
}

// 新增
export function addRole(data) {
  return request({
    url: '/auth/role/',
    method: 'post',
    data
  })
}

// 删除
export function deleteRoleById(roleId) {
  return request({
    url: `/auth/role/${roleId}/delete/`,
    method: 'get'
  })
}

// 更新
export function updateRoleById(roleId, data) {
  return request({
    url: `/auth/role/${roleId}/`,
    method: 'patch',
    data
  })
}

// 角色是否存在
export function roleExists(data) {
  return request({
    url: '/auth/role/exists/',
    method: 'post',
    data
  })
}
