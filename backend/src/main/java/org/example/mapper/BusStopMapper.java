package org.example.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.example.entity.BusStop;

import java.util.List;

public interface BusStopMapper extends BaseMapper<BusStop> {
    /**
     * 根据线路ID获取站点列表
     */
    List<BusStop> getStopsByRouteId(Long routeId);
}