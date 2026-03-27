package org.example.controller;

import org.example.common.Result;
import org.example.service.CampusPOIService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/v1/pois")
public class POIController {

    @Autowired
    private CampusPOIService campusPOIService;

    /**
     * 根据经纬度范围获取POI列表
     * @param minLng 最小经度
     * @param maxLng 最大经度
     * @param minLat 最小纬度
     * @param maxLat 最大纬度
     * @return POI列表
     */
    @GetMapping("/list-in-bounds")
    public Result<?> listInBounds(@RequestParam Double minLng, @RequestParam Double maxLng,
                                 @RequestParam Double minLat, @RequestParam Double maxLat) {
        Map<String, Double> params = Map.of(
                "minLng", minLng,
                "maxLng", maxLng,
                "minLat", minLat,
                "maxLat", maxLat
        );
        return Result.success(campusPOIService.listInBounds(params));
    }

    /**
     * 关键词搜索POI
     * @param keyword 搜索关键词
     * @return 搜索结果列表
     */
    @GetMapping("/search")
    public Result<?> search(@RequestParam String keyword) {
        return Result.success(campusPOIService.search(keyword));
    }

    /**
     * 获取POI详情
     * @param id POI ID
     * @return POI详情
     */
    @GetMapping("/{id}")
    public Result<?> getById(@PathVariable Long id) {
        return Result.success(campusPOIService.getById(id));
    }
}