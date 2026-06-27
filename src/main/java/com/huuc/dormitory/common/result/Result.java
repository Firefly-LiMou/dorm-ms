package com.huuc.dormitory.common.result;

import java.util.HashMap;
import java.util.Map;

/**
 * 统一返回结果封装
 * 所有Controller接口统一使用此类返回结果
 *
 * @param <T> 数据类型
 */
public class Result<T> {

    /** 状态码 */
    private Integer code;

    /** 提示信息 */
    private String msg;

    /** 返回数据 */
    private T data;

    /** 扩展数据（可选） */
    private Map<String, Object> extra;

    public Result() {
    }

    public Result(Integer code, String msg, T data) {
        this.code = code;
        this.msg = msg;
        this.data = data;
    }

    /**
     * 返回成功结果（无数据）
     *
     * @param <T> 数据类型
     * @return 成功结果（code=200）
     */
    public static <T> Result<T> success() {
        return new Result<>(200, "操作成功", null);
    }

    /**
     * 返回成功结果（带数据）
     *
     * @param data 返回数据
     * @param <T>  数据类型
     * @return 成功结果（code=200）
     */
    public static <T> Result<T> success(T data) {
        return new Result<>(200, "操作成功", data);
    }

    /**
     * 返回成功结果（带数据和提示信息）
     */
    public static <T> Result<T> success(String msg, T data) {
        return new Result<>(200, msg, data);
    }

    /**
     * 返回失败结果
     *
     * @param msg 错误信息
     * @param <T> 数据类型
     * @return 失败结果（code=500）
     */
    public static <T> Result<T> fail(String msg) {
        return new Result<>(500, msg, null);
    }

    /**
     * 返回失败结果（自定义错误码）
     *
     * @param code 错误码
     * @param msg  错误信息
     * @param <T>  数据类型
     * @return 失败结果
     */
    public static <T> Result<T> fail(Integer code, String msg) {
        return new Result<>(code, msg, null);
    }

    /**
     * 返回参数错误结果
     *
     * @param msg 错误信息
     * @param <T> 数据类型
     * @return 参数错误结果（code=400）
     */
    public static <T> Result<T> badRequest(String msg) {
        return new Result<>(400, msg, null);
    }

    /**
     * 返回未登录结果
     *
     * @param msg 错误信息
     * @param <T> 数据类型
     * @return 未登录结果（code=401）
     */
    public static <T> Result<T> unauthorized(String msg) {
        return new Result<>(401, msg, null);
    }

    /**
     * 返回无权限结果
     *
     * @param msg 错误信息
     * @param <T> 数据类型
     * @return 无权限结果（code=403）
     */
    public static <T> Result<T> forbidden(String msg) {
        return new Result<>(403, msg, null);
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

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }

    public Map<String, Object> getExtra() {
        return extra;
    }

    public void setExtra(Map<String, Object> extra) {
        this.extra = extra;
    }

    /**
     * 添加扩展数据
     *
     * @param key   键
     * @param value 值
     * @return 当前Result对象（支持链式调用）
     */
    public Result<T> putExtra(String key, Object value) {
        if (this.extra == null) {
            this.extra = new HashMap<>();
        }
        this.extra.put(key, value);
        return this;
    }
}
