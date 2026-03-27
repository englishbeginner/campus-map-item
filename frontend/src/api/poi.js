import request from '@/utils/request'

export function getPOIListInBounds(params) {
  return request({
    url: '/api/v1/pois/list-in-bounds',
    method: 'get',
    params
  })
}

export function searchPOI(keyword) {
  return request({
    url: '/api/v1/pois/search',
    method: 'get',
    params: { keyword }
  })
}

export function getPOIDetail(id) {
  return request({
    url: `/api/v1/pois/${id}`,
    method: 'get'
  })
}