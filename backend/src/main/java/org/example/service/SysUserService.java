package org.example.service;

import com.baomidou.mybatisplus.extension.service.IService;
import org.example.entity.SysUser;

public interface SysUserService extends IService<SysUser> {
    /**
     * 用户登录
     */
    SysUser login(String username, String password);
}