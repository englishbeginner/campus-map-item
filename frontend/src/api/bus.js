import request from '@/utils/request'

export function getBusRoutes() {
  return request({
    url: '/api/v1/bus/routes',
    method: 'get'
  })
}

export function getBusRouteStops(id) {
  return request({
    url: `/api/v1/bus/routes/${id}/stops`,
    method: 'get'
  })
}