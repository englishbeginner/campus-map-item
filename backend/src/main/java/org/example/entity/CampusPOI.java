package org.example.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("t_campus_poi")
public class CampusPOI {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String name;
    private String alias;
    private Integer type;
    private Double centerLng;
    private Double centerLat;
    private String boundary;
    private String photoUrl;
    private String description;
    private Integer status;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}