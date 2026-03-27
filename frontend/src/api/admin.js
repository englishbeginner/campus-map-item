import request from '@/utils/request'

export function adminLogin(username, password) {
  return request({
    url: '/api/admin/login',
    method: 'post',
    params: { username, password }
  })
}

export function addPOI(data) {
  return request({
    url: '/api/admin/poi',
    method: 'post',
    data
  })
}