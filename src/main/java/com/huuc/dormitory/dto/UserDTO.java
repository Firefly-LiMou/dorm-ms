package com.huuc.dormitory.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

/**
 * 用户信息DTO（管理员新增/编辑用户）
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class UserDTO {

    /** 用户ID（编辑时必填） */
    private Long userId;

    /** 登录账号 */
    @NotBlank(message = "用户名不能为空")
    private String username;

    /** 真实姓名 */
    @NotBlank(message = "真实姓名不能为空")
    private String realName;

    /** 角色类型 */
    @NotNull(message = "角色类型不能为空")
    private Integer roleType;

    /** 性别 */
    private Integer gender;

    /** 联系电话 */
    private String phone;

    /** 年级（学生专属） */
    private String grade;

    /** 专业（学生专属） */
    private String major;

    /** 班级（学生专属） */
    private String className;

    /** 账号状态 */
    private Integer status;
}
