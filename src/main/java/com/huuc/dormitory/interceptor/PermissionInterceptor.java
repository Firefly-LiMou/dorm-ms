package com.huuc.dormitory.interceptor;

import com.huuc.dormitory.common.enums.RoleTypeEnum;
import com.huuc.dormitory.common.utils.SessionUtil;
import com.huuc.dormitory.entity.SysUser;
import org.springframework.util.AntPathMatcher;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 权限拦截器
 * 根据用户角色判断是否有权限访问对应接口
 */
public class PermissionInterceptor implements HandlerInterceptor {

    private static final AntPathMatcher pathMatcher = new AntPathMatcher();

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 获取当前登录用户
        SysUser user = SessionUtil.getCurrentUser(request.getSession());

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        // 获取请求路径
        String requestURI = request.getRequestURI();
        Integer roleType = user.getRoleType();

        // 管理员接口：仅管理员可访问
        if (pathMatcher.match("/admin/**", requestURI) && !RoleTypeEnum.ADMIN.getCode().equals(roleType)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "无权限访问");
            return false;
        }

        // 宿管接口：仅宿管可访问
        if (pathMatcher.match("/dorm/**", requestURI) && !RoleTypeEnum.DORM_MANAGER.getCode().equals(roleType)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "无权限访问");
            return false;
        }

        // 学生接口：仅学生可访问
        if (pathMatcher.match("/student/**", requestURI) && !RoleTypeEnum.STUDENT.getCode().equals(roleType)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "无权限访问");
            return false;
        }

        return true;
    }
}
