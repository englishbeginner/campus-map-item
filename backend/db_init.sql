-- 创建数据库
CREATE DATABASE IF NOT EXISTS campus_map DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE campus_map;

-- 校园POI表
CREATE TABLE IF NOT EXISTS t_campus_poi (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    alias VARCHAR(100),
    type TINYINT NOT NULL,
    center_lng DECIMAL(10,7) NOT NULL,
    center_lat DECIMAL(10,7) NOT NULL,
    boundary TEXT,
    photo_url VARCHAR(255),
    description VARCHAR(500),
    status TINYINT DEFAULT 1,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_type_status (type, status)
);

-- 校车线路表
CREATE TABLE IF NOT EXISTS t_bus_route (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    route_name VARCHAR(100) NOT NULL,
    start_time TIME,
    end_time TIME,
    path_coords TEXT,
    status TINYINT DEFAULT 1
);

-- 校车站点表
CREATE TABLE IF NOT EXISTS t_bus_stop (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    route_id BIGINT NOT NULL,
    stop_name VARCHAR(100) NOT NULL,
    lng DECIMAL(10,7) NOT NULL,
    lat DECIMAL(10,7) NOT NULL,
    sort_order INT NOT NULL,
    INDEX idx_route_id (route_id)
);

-- 系统用户表
CREATE TABLE IF NOT EXISTS t_sys_user (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    role VARCHAR(20) DEFAULT 'ADMIN'
);

-- 插入测试数据
-- POI测试数据
INSERT INTO t_campus_poi (name, alias, type, center_lng, center_lat, boundary, photo_url, description) VALUES
('第一教学楼', '一教', 1, 116.327156, 39.984706, '[ [116.326156, 39.984206], [116.328156, 39.984206], [116.328156, 39.985206], [116.326156, 39.985206] ]', 'https://example.com/photo1.jpg', '学校主要教学楼之一'),
('图书馆', '图书馆', 4, 116.325156, 39.983706, '[ [116.324156, 39.983206], [116.326156, 39.983206], [116.326156, 39.984206], [116.324156, 39.984206] ]', 'https://example.com/photo2.jpg', '学校图书馆，藏书丰富'),
('第一食堂', '一食堂', 2, 116.323156, 39.982706, '[ [116.322156, 39.982206], [116.324156, 39.982206], [116.324156, 39.983206], [116.322156, 39.983206] ]', 'https://example.com/photo3.jpg', '学校第一食堂'),
('北门', '北门', 5, 116.329156, 39.985706, NULL, 'https://example.com/photo4.jpg', '学校北大门'),
('学生宿舍A区', 'A区宿舍', 3, 116.321156, 39.981706, '[ [116.320156, 39.981206], [116.322156, 39.981206], [116.322156, 39.982206], [116.320156, 39.982206] ]', 'https://example.com/photo5.jpg', '学生宿舍A区');

-- 校车线路测试数据
INSERT INTO t_bus_route (route_name, start_time, end_time, path_coords) VALUES
('A线 北门-南门', '06:00', '22:00', '[ [116.329156, 39.985706], [116.327156, 39.984706], [116.325156, 39.983706], [116.323156, 39.982706], [116.321156, 39.981706] ]');

-- 校车站点测试数据
INSERT INTO t_bus_stop (route_id, stop_name, lng, lat, sort_order) VALUES
(1, '北门', 116.329156, 39.985706, 1),
(1, '第一教学楼', 116.327156, 39.984706, 2),
(1, '图书馆', 116.325156, 39.983706, 3),
(1, '第一食堂', 116.323156, 39.982706, 4),
(1, '学生宿舍A区', 116.321156, 39.981706, 5);

-- 系统用户测试数据
INSERT INTO t_sys_user (username, password, role) VALUES
('admin', 'admin123', 'ADMIN');