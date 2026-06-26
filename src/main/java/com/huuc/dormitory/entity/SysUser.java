package com.huuc.dormitory.entity;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;

/**
 * 系统用户实体类
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class SysUser {

    /** 用户主键ID */
    private Long userId;

    /** 登录账号 */
    private String username;

    /** 登录密码 */
    private String password;

    /** 真实姓名 */
    private String realName;

    /** 角色类型：1-系统管理员 2-宿管 3-学生 */
    private Integer roleType;

    /** 性别：1-男 2-女 */
    private Integer gender;

    /** 联系电话 */
    private String phone;

    /** 年级（学生专属字段） */
    private String grade;

    /** 专业（学生专属字段） */
    private String major;

    /** 班级（学生专属字段） */
    private String className;

    /** 账号状态：1-正常 0-禁用 */
    private Integer status;

    /** 创建时间 */
    private LocalDateTime createTime;

    /** 更新时间 */
    private LocalDateTime updateTime;

    /** 逻辑删除标记：0-未删除 1-已删除 */
    private Integer isDeleted;
}
