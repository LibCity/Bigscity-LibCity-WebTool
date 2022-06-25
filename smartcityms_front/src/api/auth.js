import request from '@/utils/request'

export function login(data) {
  return request({
    url: '/auth/token/',
    method: 'post',
    data: data
  })
}

export function getInfo() {
  return request({
    url: '/auth/account/info/',
    method: 'get'
  })
}

export function logout() {
  return request({
    url: '/auth/token/black/',
    method: 'get'
  })
}
