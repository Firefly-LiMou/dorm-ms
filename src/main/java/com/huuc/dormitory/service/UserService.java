package com.huuc.dormitory.service;

import com.huuc.dormitory.dto.LoginDTO;
import com.huuc.dormitory.dto.PasswordDTO;
import com.huuc.dormitory.dto.UserDTO;
import com.huuc.dormitory.entity.SysUser;

import java.util.List;

/**
 * 用户服务接口
 */
public interface UserService {

    /**
     * 用户登录
     */
    SysUser login(LoginDTO dto);

    /**
     * 根据ID获取用户
     */
    SysUser getUserById(Long userId);

    /**
     * 修改密码
     */
    void updatePassword(PasswordDTO dto, Long userId);

    /**
     * 修改个人联系电话
     */
    void updatePhone(String phone, Long userId);

    /**
     * 管理员新增用户
     */
    void addUser(UserDTO dto);

    /**
     * 管理员编辑用户
     */
    void updateUser(UserDTO dto);

    /**
     * 管理员启用/禁用用户
     */
    void toggleUserStatus(Long userId);

    /**
     * 查询用户列表
     */
    List<SysUser> getUserList(SysUser query);

    /**
     * 根据角色类型查询用户列表
     */
    List<SysUser> getUsersByRoleType(Integer roleType);

    /**
     * 判断是否需要强制修改密码（密码等于默认密码）
     */
    boolean needChangePassword(SysUser user);
}
