package org.example.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.example.entity.CampusPOI;
import org.example.mapper.CampusPOIMapper;
import org.example.service.CampusPOIService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class CampusPOIServiceImpl extends ServiceImpl<CampusPOIMapper, CampusPOI> implements CampusPOIService {

    @Override
    public List<CampusPOI> listInBounds(Map<String, Double> params) {
        return baseMapper.listInBounds(params);
    }

    @Override
    public List<CampusPOI> search(String keyword) {
        return baseMapper.search(keyword);
    }

    @Override
    public CampusPOI getById(Long id) {
        return baseMapper.selectById(id);
    }
}