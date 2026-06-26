package com.huuc.dormitory.entity;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;

/**
 * 操作日志实体类
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
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
}
