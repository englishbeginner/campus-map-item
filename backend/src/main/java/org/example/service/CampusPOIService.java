package org.example.service;

import com.baomidou.mybatisplus.extension.service.IService;
import org.example.entity.CampusPOI;

import java.util.List;
import java.util.Map;

public interface CampusPOIService extends IService<CampusPOI> {
    /**
     * 根据经纬度范围获取POI列表
     */
    List<CampusPOI> listInBounds(Map<String, Double> params);

    /**
     * 关键词搜索POI
     */
    List<CampusPOI> search(String keyword);

    /**
     * 根据ID获取POI详情
     */
    CampusPOI getById(Long id);
}