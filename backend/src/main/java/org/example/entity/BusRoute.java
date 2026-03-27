package org.example.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

@Data
@TableName("t_bus_route")
public class BusRoute {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String routeName;
    private String startTime;
    private String endTime;
    private String pathCoords;
    private Integer status;
}