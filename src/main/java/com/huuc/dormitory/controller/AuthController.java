package com.huuc.dormitory.controller;

import com.huuc.dormitory.common.aop.OperLog;
import com.huuc.dormitory.common.enums.OperTypeEnum;
import com.huuc.dormitory.common.result.Result;
import com.huuc.dormitory.common.utils.SessionUtil;
import com.huuc.dormitory.dto.LoginDTO;
import com.huuc.dormitory.entity.SysUser;
import com.huuc.dormitory.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

/**
 * 认证控制器
 */
@Controller
public class AuthController {

    @Autowired
    private UserService userService;

    /**
     * 跳转登录页
     */
    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }

    /**
     * 用户登录
     */
    @PostMapping("/login")
    @ResponseBody
    @OperLog(module = "用户认证", type = OperTypeEnum.LOGIN, desc = "用户登录")
    public Result<SysUser> login(@RequestBody @Valid LoginDTO dto, HttpSession session) {
        SysUser user = userService.login(dto);

        // 将用户信息存入Session
        SessionUtil.setCurrentUser(session, user);

        // 判断是否需要强制修改密码
        boolean needChangePassword = userService.needChangePassword(user);
        user.setPassword(null);

        // 返回用户信息，通过extra字段传递needChangePassword标记
        return Result.success(user).putExtra("needChangePassword", needChangePassword);
    }

    /**
     * 用户登出
     */
    @PostMapping("/logout")
    @ResponseBody
    @OperLog(module = "用户认证", type = OperTypeEnum.LOGOUT, desc = "用户登出")
    public Result<Void> logout(HttpSession session) {
        SessionUtil.removeCurrentUser(session);
        return Result.success();
    }

    /**
     * 获取当前登录用户信息
     */
    @GetMapping("/currentUser")
    @ResponseBody
    public Result<SysUser> getCurrentUser(HttpSession session) {
        SysUser user = SessionUtil.getCurrentUser(session);
        if (user == null) {
            return Result.unauthorized("未登录");
        }
        // 查询最新用户信息
        SysUser latestUser = userService.getUserById(user.getUserId());
        return Result.success(latestUser);
    }

    /**
     * 判断是否需要强制修改密码
     */
    @GetMapping("/needChangePassword")
    @ResponseBody
    public Result<Boolean> needChangePassword(HttpSession session) {
        SysUser user = SessionUtil.getCurrentUser(session);
        if (user == null) {
            return Result.unauthorized("未登录");
        }
        boolean need = userService.needChangePassword(user);
        return Result.success(need);
    }
}
