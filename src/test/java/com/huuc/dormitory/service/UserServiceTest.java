package com.huuc.dormitory.service;

import com.huuc.dormitory.common.enums.UserStatusEnum;
import com.huuc.dormitory.common.exception.BusinessException;
import com.huuc.dormitory.common.utils.Md5Util;
import com.huuc.dormitory.dao.SysUserMapper;
import com.huuc.dormitory.dto.LoginDTO;
import com.huuc.dormitory.dto.UserDTO;
import com.huuc.dormitory.entity.SysUser;
import com.huuc.dormitory.service.impl.UserServiceImpl;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

/**
 * UserServiceImpl单元测试
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("UserServiceImpl用户服务测试")
class UserServiceTest {

    @InjectMocks
    private UserServiceImpl userService;

    @Mock
    private SysUserMapper sysUserMapper;

    // ==================== login() 用户登录测试 ====================

    @Test
    @DisplayName("login_正常登录_返回用户信息且密码清空")
    void login_正常登录_返回用户信息且密码清空() {
        // given
        LoginDTO dto = new LoginDTO();
        dto.setUsername("admin");
        dto.setPassword("admin123");

        SysUser user = new SysUser();
        user.setUserId(1L);
        user.setUsername("admin");
        user.setPassword(Md5Util.encrypt("admin123"));
        user.setStatus(UserStatusEnum.NORMAL.getCode());

        when(sysUserMapper.selectByUsername("admin")).thenReturn(user);

        // when
        SysUser result = userService.login(dto);

        // then
        assertNotNull(result);
        assertEquals(1L, result.getUserId());
        assertNull(result.getPassword());
    }

    @Test
    @DisplayName("login_用户不存在_抛出401异常")
    void login_用户不存在_抛出401异常() {
        // given
        LoginDTO dto = new LoginDTO();
        dto.setUsername("nonexist");
        dto.setPassword("password");

        when(sysUserMapper.selectByUsername("nonexist")).thenReturn(null);

        // when & then
        BusinessException ex = assertThrows(BusinessException.class,
                () -> userService.login(dto));
        assertEquals(BusinessException.CODE_UNAUTHORIZED, ex.getCode());
    }

    @Test
    @DisplayName("login_密码错误_抛出401异常")
    void login_密码错误_抛出401异常() {
        // given
        LoginDTO dto = new LoginDTO();
        dto.setUsername("admin");
        dto.setPassword("wrong_password");

        SysUser user = new SysUser();
        user.setUserId(1L);
        user.setUsername("admin");
        user.setPassword(Md5Util.encrypt("correct_password"));
        user.setStatus(UserStatusEnum.NORMAL.getCode());

        when(sysUserMapper.selectByUsername("admin")).thenReturn(user);

        // when & then
        BusinessException ex = assertThrows(BusinessException.class,
                () -> userService.login(dto));
        assertEquals(BusinessException.CODE_UNAUTHORIZED, ex.getCode());
    }

    @Test
    @DisplayName("login_账号禁用_抛出401异常")
    void login_账号禁用_抛出401异常() {
        // given
        LoginDTO dto = new LoginDTO();
        dto.setUsername("admin");
        dto.setPassword("admin123");

        SysUser user = new SysUser();
        user.setUserId(1L);
        user.setUsername("admin");
        user.setPassword(Md5Util.encrypt("admin123"));
        user.setStatus(UserStatusEnum.DISABLED.getCode());

        when(sysUserMapper.selectByUsername("admin")).thenReturn(user);

        // when & then
        BusinessException ex = assertThrows(BusinessException.class,
                () -> userService.login(dto));
        assertEquals(BusinessException.CODE_UNAUTHORIZED, ex.getCode());
    }

    // ==================== addUser() 新增用户测试 ====================

    @Test
    @DisplayName("addUser_正常新增_插入用户记录")
    void addUser_正常新增_插入用户记录() {
        // given
        UserDTO dto = new UserDTO();
        dto.setUsername("2024001");
        dto.setRealName("张三");
        dto.setRoleType(3);
        dto.setPhone("13800138000");

        when(sysUserMapper.selectByUsername("2024001")).thenReturn(null);
        when(sysUserMapper.insert(any(SysUser.class))).thenReturn(1);

        // when
        assertDoesNotThrow(() -> userService.addUser(dto));

        // then
        verify(sysUserMapper).insert(any(SysUser.class));
    }

    @Test
    @DisplayName("addUser_用户名为空_抛出400异常")
    void addUser_用户名为空_抛出400异常() {
        // given
        UserDTO dto = new UserDTO();
        dto.setUsername("");
        dto.setRealName("张三");
        dto.setRoleType(3);

        // when & then
        BusinessException ex = assertThrows(BusinessException.class,
                () -> userService.addUser(dto));
        assertEquals(BusinessException.CODE_BAD_REQUEST, ex.getCode());
    }

    @Test
    @DisplayName("addUser_用户名重复_抛出409异常")
    void addUser_用户名重复_抛出409异常() {
        // given
        UserDTO dto = new UserDTO();
        dto.setUsername("2024001");
        dto.setRealName("张三");
        dto.setRoleType(3);
        dto.setPhone("13800138000");

        SysUser existUser = new SysUser();
        existUser.setUserId(1L);
        existUser.setUsername("2024001");

        when(sysUserMapper.selectByUsername("2024001")).thenReturn(existUser);

        // when & then
        BusinessException ex = assertThrows(BusinessException.class,
                () -> userService.addUser(dto));
        assertEquals(BusinessException.CODE_CONFLICT, ex.getCode());
    }

    // ==================== needChangePassword() 判断是否需要修改密码测试 ====================

    @Test
    @DisplayName("needChangePassword_密码为默认密码_返回true")
    void needChangePassword_密码为默认密码_返回true() {
        // given
        SysUser user = new SysUser();
        user.setUserId(1L);
        user.setPassword("some_password");

        SysUser fullUser = new SysUser();
        fullUser.setUserId(1L);
        fullUser.setPhone("13800138000");
        fullUser.setPassword(Md5Util.encrypt("huuc13800138000"));

        when(sysUserMapper.selectById(1L)).thenReturn(fullUser);

        // when
        boolean result = userService.needChangePassword(user);

        // then
        assertTrue(result);
    }

    @Test
    @DisplayName("needChangePassword_密码已修改_返回false")
    void needChangePassword_密码已修改_返回false() {
        // given
        SysUser user = new SysUser();
        user.setUserId(1L);
        user.setPassword("some_password");

        SysUser fullUser = new SysUser();
        fullUser.setUserId(1L);
        fullUser.setPhone("13800138000");
        fullUser.setPassword(Md5Util.encrypt("my_new_password"));

        when(sysUserMapper.selectById(1L)).thenReturn(fullUser);

        // when
        boolean result = userService.needChangePassword(user);

        // then
        assertFalse(result);
    }

    @Test
    @DisplayName("needChangePassword_用户为null_返回false")
    void needChangePassword_用户为null_返回false() {
        // when
        boolean result = userService.needChangePassword(null);

        // then
        assertFalse(result);
    }

    // ==================== getUserById() 获取用户测试 ====================

    @Test
    @DisplayName("getUserById_用户存在_返回用户信息且密码清空")
    void getUserById_用户存在_返回用户信息且密码清空() {
        // given
        SysUser user = new SysUser();
        user.setUserId(1L);
        user.setUsername("admin");
        user.setPassword("encrypted_password");

        when(sysUserMapper.selectById(1L)).thenReturn(user);

        // when
        SysUser result = userService.getUserById(1L);

        // then
        assertNotNull(result);
        assertNull(result.getPassword());
    }

    @Test
    @DisplayName("getUserById_用户不存在_抛出404异常")
    void getUserById_用户不存在_抛出404异常() {
        // given
        when(sysUserMapper.selectById(999L)).thenReturn(null);

        // when & then
        BusinessException ex = assertThrows(BusinessException.class,
                () -> userService.getUserById(999L));
        assertEquals(BusinessException.CODE_NOT_FOUND, ex.getCode());
    }
}
