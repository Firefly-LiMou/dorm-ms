package com.huuc.dormitory.vo;

import com.huuc.dormitory.entity.SysUser;

/**
 * 登录返回VO
 */
public class LoginVO {

    /** 用户信息 */
    private SysUser user;

    /** 是否需要强制修改密码 */
    private boolean needChangePassword;

    public LoginVO() {
    }

    public LoginVO(SysUser user, boolean needChangePassword) {
        this.user = user;
        this.needChangePassword = needChangePassword;
    }

    public SysUser getUser() {
        return user;
    }

    public void setUser(SysUser user) {
        this.user = user;
    }

    public boolean isNeedChangePassword() {
        return needChangePassword;
    }

    public void setNeedChangePassword(boolean needChangePassword) {
        this.needChangePassword = needChangePassword;
    }
}
