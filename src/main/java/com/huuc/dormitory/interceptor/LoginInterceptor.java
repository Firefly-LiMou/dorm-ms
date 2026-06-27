package com.huuc.dormitory.interceptor;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.huuc.dormitory.common.result.Result;
import com.huuc.dormitory.common.utils.SessionUtil;
import com.huuc.dormitory.entity.SysUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 登录拦截器
 * 校验Session中是否存在用户信息，未登录则重定向至登录页（AJAX请求返回JSON 401）
 */
@Component
public class LoginInterceptor implements HandlerInterceptor {

    @Autowired
    private ObjectMapper objectMapper;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 获取当前登录用户
        SysUser user = SessionUtil.getCurrentUser(request.getSession());

        if (user == null) {
            // 判断是否为AJAX请求
            String xRequestedWith = request.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(xRequestedWith)) {
                // AJAX请求返回JSON 401
                response.setContentType("application/json;charset=UTF-8");
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write(objectMapper.writeValueAsString(Result.unauthorized("未登录")));
            } else {
                // 普通请求重定向到登录页
                response.sendRedirect(request.getContextPath() + "/login");
            }
            return false;
        }

        return true;
    }
}
