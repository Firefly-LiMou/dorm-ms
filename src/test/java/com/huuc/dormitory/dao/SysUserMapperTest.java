package com.huuc.dormitory.dao;

import com.huuc.dormitory.entity.SysUser;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

/**
 * SysUserMapper单元测试
 */
@DisplayName("SysUserMapper用户Mapper测试")
class SysUserMapperTest extends BaseMapperTest {

    @Autowired
    private SysUserMapper sysUserMapper;

    @Test
    @DisplayName("selectByUsername_存在用户_返回用户信息")
    void selectByUsername_存在用户_返回用户信息() {
        SysUser user = sysUserMapper.selectByUsername("admin");

        assertNotNull(user);
        assertEquals("admin", user.getUsername());
        assertNotNull(user.getRealName());
    }

    @Test
    @DisplayName("selectByUsername_不存在用户_返回null")
    void selectByUsername_不存在用户_返回null() {
        SysUser user = sysUserMapper.selectByUsername("nonexist");

        assertNull(user);
    }

    @Test
    @DisplayName("selectById_存在用户_返回用户信息")
    void selectById_存在用户_返回用户信息() {
        SysUser user = sysUserMapper.selectById(1L);

        assertNotNull(user);
        assertEquals("admin", user.getUsername());
    }

    @Test
    @DisplayName("selectByRoleType_查询学生_返回学生列表")
    void selectByRoleType_查询学生_返回学生列表() {
        List<SysUser> users = sysUserMapper.selectByRoleType(3);

        assertNotNull(users);
        assertTrue(users.size() > 0);
        users.forEach(u -> assertEquals(3, u.getRoleType()));
    }

    @Test
    @DisplayName("selectList_按角色类型筛选_返回匹配列表")
    void selectList_按角色类型筛选_返回匹配列表() {
        SysUser query = new SysUser();
        query.setRoleType(2);

        List<SysUser> users = sysUserMapper.selectList(query);

        assertNotNull(users);
        assertTrue(users.size() > 0);
        users.forEach(u -> assertEquals(2, u.getRoleType()));
    }

    @Test
    @DisplayName("selectList_按用户名模糊查询_返回匹配列表")
    void selectList_按用户名模糊查询_返回匹配列表() {
        SysUser query = new SysUser();
        query.setUsername("20220001");

        List<SysUser> users = sysUserMapper.selectList(query);

        assertNotNull(users);
        assertTrue(users.size() > 0);
    }

    @Test
    @DisplayName("insert_新增用户_返回自增ID")
    void insert_新增用户_返回自增ID() {
        SysUser user = new SysUser();
        user.setUsername("testuser");
        user.setPassword("encrypted");
        user.setRealName("测试用户");
        user.setRoleType(3);
        user.setPhone("13900000000");
        user.setStatus(1);

        int rows = sysUserMapper.insert(user);

        assertEquals(1, rows);
        assertNotNull(user.getUserId());
    }

    @Test
    @DisplayName("updatePassword_更新密码_返回影响行数")
    void updatePassword_更新密码_返回影响行数() {
        int rows = sysUserMapper.updatePassword(1L, "new_password");

        assertEquals(1, rows);
    }

    @Test
    @DisplayName("updateStatus_更新状态_返回影响行数")
    void updateStatus_更新状态_返回影响行数() {
        int rows = sysUserMapper.updateStatus(1L, 0);

        assertEquals(1, rows);
    }
}
