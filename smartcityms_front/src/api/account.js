import request from '@/utils/request'

// 列表数据查询
export function getAccountList(queryParam) {
  return request({
    url: '/auth/account/',
    method: 'get',
    params: queryParam
  })
}

// 列表数据查询 只返回 id 和 account number
export function getSimpleAccountList(queryParam) {
  return request({
    url: '/auth/account/list_all/',
    method: 'get',
    params: queryParam
  })
}

// 回显单个数据
export function getAccountById(accountId) {
  return request({
    url: `/auth/account/${accountId}/`,
    method: 'get'
  })
}

// 新增
export function addAccount(data) {
  return request({
    url: '/auth/account/',
    method: 'post',
    data
  })
}

// 删除
export function deleteAccountById(accountId) {
  return request({
    url: `/auth/account/${accountId}/delete/`,
    method: 'get'
  })
}

// 更新
export function updateAccountById(accountId, data) {
  return request({
    url: `/auth/account/${accountId}/`,
    method: 'patch',
    data
  })
}

// 修改密码
export function updatePassword(data) {
  return request({
    url: `/auth/account/password/`,
    method: 'post',
    data
  })
}

// 账号是否存在
export function accountExists(data) {
  return request({
    url: '/auth/account/exists/',
    method: 'post',
    data
  })
}

// 获取验证码
export function getAuthCode(data) {
  return request({
    url: '/auth/account/send_code/',
    method: 'post',
    data
  })
}

// 绑定邮箱
export function bindMail(accountId, data) {
  return request({
    url: `/auth/account/${accountId}/bind_mail/`,
    method: 'post',
    data
  })
}
