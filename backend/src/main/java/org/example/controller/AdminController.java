package org.example.controller;

import org.example.common.JWTUtil;
import org.example.common.Result;
import org.example.entity.CampusPOI;
import org.example.entity.SysUser;
import org.example.service.CampusPOIService;
import org.example.service.SysUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/admin")
public class AdminController {

    @Autowired
    private SysUserService sysUserService;

    @Autowired
    private CampusPOIService campusPOIService;

    /**
     * 管理员登录
     * @param username 用户名
     * @param password 密码
     * @return 登录结果，包含token
     */
    @PostMapping("/login")
    public Result<?> login(@RequestParam String username, @RequestParam String password) {
        SysUser user = sysUserService.login(username, password);
        if (user != null) {
            String token = JWTUtil.generateToken(username);
            return Result.success(token);
        }
        return Result.error(401, "用户名或密码错误");
    }

    /**
     * 新增POI
     * @param campusPOI POI信息
     * @return 操作结果
     */
    @PostMapping("/poi")
    public Result<?> addPOI(@RequestBody CampusPOI campusPOI) {
        campusPOIService.save(campusPOI);
        return Result.success(null);
    }

    /**
     * 修改POI
     * @param id POI ID
     * @param campusPOI POI信息
     * @return 操作结果
     */
    @PutMapping("/poi/{id}")
    public Result<?> updatePOI(@PathVariable Long id, @RequestBody CampusPOI campusPOI) {
        campusPOI.setId(id);
        campusPOIService.updateById(campusPOI);
        return Result.success(null);
    }

    /**
     * 删除POI
     * @param id POI ID
     * @return 操作结果
     */
    @DeleteMapping("/poi/{id}")
    public Result<?> deletePOI(@PathVariable Long id) {
        campusPOIService.removeById(id);
        return Result.success(null);
    }
}