package org.example.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@Data
@TableName("t_bus_stop")
public class BusStop {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long routeId;
    private String stopName;
    private Double lng;
    private Double lat;
    private Integer sortOrder;
}