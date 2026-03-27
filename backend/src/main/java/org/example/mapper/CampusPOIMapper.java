package org.example.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.example.entity.CampusPOI;

import java.util.List;
import java.util.Map;

public interface CampusPOIMapper extends BaseMapper<CampusPOI> {
    /**
     * 根据经纬度范围获取POI列表
     */
    List<CampusPOI> listInBounds(Map<String, Double> params);

    /**
     * 关键词搜索POI
     */
    List<CampusPOI> search(String keyword);
}