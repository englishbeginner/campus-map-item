package org.example.controller;

import org.example.common.Result;
import org.example.service.BusRouteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/bus")
public class BusController {

    @Autowired
    private BusRouteService busRouteService;

    /**
     * 获取所有线路列表
     * @return 线路列表
     */
    @GetMapping("/routes")
    public Result<?> getAllRoutes() {
        return Result.success(busRouteService.getAllRoutes());
    }

    /**
     * 获取某线路的所有站点及轨迹
     * @param id 线路ID
     * @return 线路信息和站点列表
     */
    @GetMapping("/routes/{id}/stops")
    public Result<?> getRouteWithStops(@PathVariable Long id) {
        return Result.success(busRouteService.getRouteWithStops(id));
    }
}