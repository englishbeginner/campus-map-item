package org.example.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.example.entity.BusRoute;
import org.example.entity.BusStop;
import org.example.mapper.BusRouteMapper;
import org.example.mapper.BusStopMapper;
import org.example.service.BusRouteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class BusRouteServiceImpl extends ServiceImpl<BusRouteMapper, BusRoute> implements BusRouteService {

    @Autowired
    private BusStopMapper busStopMapper;

    @Override
    public List<BusRoute> getAllRoutes() {
        return baseMapper.selectList(null);
    }

    @Override
    public Map<String, Object> getRouteWithStops(Long routeId) {
        Map<String, Object> result = new HashMap<>();
        BusRoute route = baseMapper.selectById(routeId);
        if (route != null) {
            result.put("route", route);
            List<BusStop> stops = busStopMapper.getStopsByRouteId(routeId);
            result.put("stops", stops);
        }
        return result;
    }
}