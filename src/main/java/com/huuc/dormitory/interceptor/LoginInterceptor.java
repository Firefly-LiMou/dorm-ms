package com.huuc.dormitory.interceptor;

import com.huuc.dormitory.common.utils.SessionUtil;
import com.huuc.dormitory.entity.SysUser;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 登录拦截器
 * 校验Session中是否存在用户信息，未登录则重定向至登录页
 */
public class LoginInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 获取当前登录用户
        SysUser user = SessionUtil.getCurrentUser(request.getSession());

        if (user == null) {
            // 未登录，重定向到登录页
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        return true;
    }
}
