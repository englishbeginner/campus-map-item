import request from '@/utils/request'

export function getAllBusRoutes() {
  return request({
    url: '/api/v1/bus/routes',
    method: 'get'
  })
}

export function getBusRouteWithStops(id) {
  return request({
    url: `/api/v1/bus/routes/${id}/stops`,
    method: 'get'
  })
}