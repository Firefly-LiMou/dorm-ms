package com.huuc.dormitory.common.utils;

import com.huuc.dormitory.entity.SysUser;

import javax.servlet.http.HttpSession;

/**
 * Session工具类
 */
public class SessionUtil {

    /** Session中用户信息的Key */
    public static final String SESSION_USER = "loginUser";

    /**
     * 获取当前登录用户
     *
     * @param session HTTP会话
     * @return 用户信息，未登录或session为null时返回null
     */
    public static SysUser getCurrentUser(HttpSession session) {
        if (session == null) {
            return null;
        }
        return (SysUser) session.getAttribute(SESSION_USER);
    }

    /**
     * 获取当前登录用户ID
     *
     * @param session HTTP会话
     * @return 用户ID，未登录或session为null时返回null
     */
    public static Long getCurrentUserId(HttpSession session) {
        SysUser user = getCurrentUser(session);
        return user != null ? user.getUserId() : null;
    }

    /**
     * 设置当前登录用户到Session
     */
    public static void setCurrentUser(HttpSession session, SysUser user) {
        if (session != null) {
            session.setAttribute(SESSION_USER, user);
        }
    }

    /**
     * 清除Session中的用户信息
     */
    public static void removeCurrentUser(HttpSession session) {
        if (session != null) {
            session.removeAttribute(SESSION_USER);
        }
    }
}
