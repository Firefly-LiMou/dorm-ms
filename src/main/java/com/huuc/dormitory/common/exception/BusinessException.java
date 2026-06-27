package com.huuc.dormitory.common.exception;

/**
 * 业务异常类
 */
public class BusinessException extends RuntimeException {

    /** 400 - 参数错误 */
    public static final int CODE_BAD_REQUEST = 400;
    /** 401 - 认证失败（用户名密码错误、账号禁用） */
    public static final int CODE_UNAUTHORIZED = 401;
    /** 403 - 权限不足 */
    public static final int CODE_FORBIDDEN = 403;
    /** 404 - 资源不存在（楼栋/房间/床位/用户/记录不存在） */
    public static final int CODE_NOT_FOUND = 404;
    /** 409 - 状态冲突（用户名已存在、编号已存在、床位已占用、已有在住记录、已有待审批申请） */
    public static final int CODE_CONFLICT = 409;
    /** 500 - 系统内部错误 */
    public static final int CODE_ERROR = 500;

    /** 业务错误码 */
    private Integer code;

    /** 错误提示信息 */
    private String msg;

    public BusinessException(String msg) {
        super(msg);
        this.code = 500;
        this.msg = msg;
    }

    public BusinessException(Integer code, String msg) {
        super(msg);
        this.code = code;
        this.msg = msg;
    }

    public BusinessException(Integer code, String msg, Throwable cause) {
        super(msg, cause);
        this.code = code;
        this.msg = msg;
    }

    public Integer getCode() {
        return code;
    }

    public void setCode(Integer code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }
}
