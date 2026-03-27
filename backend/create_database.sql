-- 校园地图数据库初始化脚本
-- 版本：1.0
-- 说明：创建数据库、表结构和测试数据

-- 创建数据库
CREATE DATABASE IF NOT EXISTS campus_map DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE campus_map;

-- 校园 POI 表
CREATE TABLE IF NOT EXISTS t_campus_poi (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL COMMENT '建筑/场所名称',
    alias VARCHAR(100) COMMENT '别名（用于搜索）',
    type TINYINT NOT NULL COMMENT '类型：1-教学楼，2-食堂，3-宿舍，4-图书馆，5-校门，6-其他',
    center_lng DECIMAL(10,7) NOT NULL COMMENT '中心点经度',
    center_lat DECIMAL(10,7) NOT NULL COMMENT '中心点纬度',
    boundary TEXT COMMENT '建筑轮廓坐标数组（JSON 格式）',
    photo_url VARCHAR(255) COMMENT '实景照片 URL',
    description VARCHAR(500) COMMENT '简介',
    status TINYINT DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_type_status (type, status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='校园 POI 表';

-- 校车线路表
CREATE TABLE IF NOT EXISTS t_bus_route (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    route_name VARCHAR(100) NOT NULL COMMENT '线路名称',
    start_time TIME COMMENT '首班车时间',
    end_time TIME COMMENT '末班车时间',
    path_coords TEXT COMMENT '行驶轨迹坐标串',
    status TINYINT DEFAULT 1 COMMENT '状态',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='校车线路表';

-- 校车站点表
CREATE TABLE IF NOT EXISTS t_bus_stop (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    route_id BIGINT NOT NULL COMMENT '所属线路 ID',
    stop_name VARCHAR(100) NOT NULL COMMENT '站点名称',
    lng DECIMAL(10,7) NOT NULL COMMENT '经度',
    lat DECIMAL(10,7) NOT NULL COMMENT '纬度',
    sort_order INT NOT NULL COMMENT '站点排序序号',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_route_id (route_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='校车站点表';

-- 系统用户表
CREATE TABLE IF NOT EXISTS t_sys_user (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '管理员账号',
    password VARCHAR(100) NOT NULL COMMENT '加密后的密码',
    role VARCHAR(20) DEFAULT 'ADMIN' COMMENT '角色',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统用户表';

-- 插入测试数据 - POI
INSERT INTO t_campus_poi (name, alias, type, center_lng, center_lat, boundary, photo_url, description) VALUES
('第一教学楼', '一教', 1, 116.327156, 39.984706, '[[116.326156, 39.984206], [116.328156, 39.984206], [116.328156, 39.985206], [116.326156, 39.985206]]', 'https://example.com/photo1.jpg', '学校主要教学楼之一'),
('图书馆', '图书馆', 4, 116.325156, 39.983706, '[[116.324156, 39.983206], [116.326156, 39.983206], [116.326156, 39.984206], [116.324156, 39.984206]]', 'https://example.com/photo2.jpg', '学校图书馆，藏书丰富'),
('第一食堂', '一食堂', 2, 116.323156, 39.982706, '[[116.322156, 39.982206], [116.324156, 39.982206], [116.324156, 39.983206], [116.322156, 39.983206]]', 'https://example.com/photo3.jpg', '学校第一食堂'),
('北门', '北门', 5, 116.329156, 39.985706, NULL, 'https://example.com/photo4.jpg', '学校北大门'),
('学生宿舍 A 区', 'A 区宿舍', 3, 116.321156, 39.981706, '[[116.320156, 39.981206], [116.322156, 39.981206], [116.322156, 39.982206], [116.320156, 39.982206]]', 'https://example.com/photo5.jpg', '学生宿舍 A 区');

-- 插入测试数据 - 校车线路
INSERT INTO t_bus_route (route_name, start_time, end_time, path_coords) VALUES
('A 线 北门 - 南门', '06:00:00', '22:00:00', '[[116.329156, 39.985706], [116.327156, 39.984706], [116.325156, 39.983706], [116.323156, 39.982706], [116.321156, 39.981706]]');

-- 插入测试数据 - 校车站点
INSERT INTO t_bus_stop (route_id, stop_name, lng, lat, sort_order) VALUES
(1, '北门', 116.329156, 39.985706, 1),
(1, '第一教学楼', 116.327156, 39.984706, 2),
(1, '图书馆', 116.325156, 39.983706, 3),
(1, '第一食堂', 116.323156, 39.982706, 4),
(1, '学生宿舍 A 区', 116.321156, 39.981706, 5);

-- 插入测试数据 - 系统用户（密码未加密，生产环境请加密）
INSERT INTO t_sys_user (username, password, role) VALUES
('admin', 'admin123', 'ADMIN');

-- 查询验证
SELECT '数据库创建成功！' AS message;
SELECT COUNT(*) AS poi_count FROM t_campus_poi;
SELECT COUNT(*) AS route_count FROM t_bus_route;
SELECT COUNT(*) AS stop_count FROM t_bus_stop;
SELECT COUNT(*) AS user_count FROM t_sys_user;
