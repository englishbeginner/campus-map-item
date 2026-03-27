package org.example.service;

import com.baomidou.mybatisplus.extension.service.IService;
import org.example.entity.BusRoute;
import org.example.entity.BusStop;

import java.util.List;
import java.util.Map;

public interface BusRouteService extends IService<BusRoute> {
    /**
     * 获取所有线路列表
     */
    List<BusRoute> getAllRoutes();

    /**
     * 获取某线路的所有站点及轨迹
     */
    Map<String, Object> getRouteWithStops(Long routeId);
}