package com.huuc.dormitory.entity;

import java.time.LocalDateTime;

/**
 * 操作日志实体类
 */
public class SysOperLog {

    /** 日志主键ID */
    private Long logId;

    /** 操作人用户ID */
    private Long operatorId;

    /** 操作模块 */
    private String moduleName;

    /** 操作类型 */
    private String operType;

    /** 操作描述 */
    private String operDesc;

    /** 操作IP地址 */
    private String operIp;

    /** 请求参数（JSON格式） */
    private String requestParam;

    /** 操作时间 */
    private LocalDateTime operTime;

    public Long getLogId() {
        return logId;
    }

    public void setLogId(Long logId) {
        this.logId = logId;
    }

    public Long getOperatorId() {
        return operatorId;
    }

    public void setOperatorId(Long operatorId) {
        this.operatorId = operatorId;
    }

    public String getModuleName() {
        return moduleName;
    }

    public void setModuleName(String moduleName) {
        this.moduleName = moduleName;
    }

    public String getOperType() {
        return operType;
    }

    public void setOperType(String operType) {
        this.operType = operType;
    }

    public String getOperDesc() {
        return operDesc;
    }

    public void setOperDesc(String operDesc) {
        this.operDesc = operDesc;
    }

    public String getOperIp() {
        return operIp;
    }

    public void setOperIp(String operIp) {
        this.operIp = operIp;
    }

    public String getRequestParam() {
        return requestParam;
    }

    public void setRequestParam(String requestParam) {
        this.requestParam = requestParam;
    }

    public LocalDateTime getOperTime() {
        return operTime;
    }

    public void setOperTime(LocalDateTime operTime) {
        this.operTime = operTime;
    }
}
