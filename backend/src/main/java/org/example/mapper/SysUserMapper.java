package org.example.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.example.entity.SysUser;

public interface SysUserMapper extends BaseMapper<SysUser> {
    /**
     * 根据用户名查询用户
     */
    SysUser findByUsername(String username);
}