package com.huuc.dormitory.dto;

import com.huuc.dormitory.common.validation.AddGroup;
import com.huuc.dormitory.common.validation.UpdateGroup;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

/**
 * 用户信息DTO（管理员新增/编辑用户）
 */
public class UserDTO {

    /** 用户ID（编辑时必填） */
    @NotNull(message = "用户ID不能为空", groups = {UpdateGroup.class})
    private Long userId;

    /** 登录账号 */
    @NotBlank(message = "用户名不能为空", groups = {AddGroup.class})
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

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getRealName() {
        return realName;
    }

    public void setRealName(String realName) {
        this.realName = realName;
    }

    public Integer getRoleType() {
        return roleType;
    }

    public void setRoleType(Integer roleType) {
        this.roleType = roleType;
    }

    public Integer getGender() {
        return gender;
    }

    public void setGender(Integer gender) {
        this.gender = gender;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getGrade() {
        return grade;
    }

    public void setGrade(String grade) {
        this.grade = grade;
    }

    public String getMajor() {
        return major;
    }

    public void setMajor(String major) {
        this.major = major;
    }

    public String getClassName() {
        return className;
    }

    public void setClassName(String className) {
        this.className = className;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }
}
