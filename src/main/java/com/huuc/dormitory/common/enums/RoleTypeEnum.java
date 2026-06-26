package com.huuc.dormitory.common.enums;

/**
 * 角色类型枚举
 */
public enum RoleTypeEnum {

    ADMIN(1, "系统管理员"),
    DORM_MANAGER(2, "宿管"),
    STUDENT(3, "学生");

    private final Integer code;
    private final String desc;

    RoleTypeEnum(Integer code, String desc) {
        this.code = code;
        this.desc = desc;
    }

    public Integer getCode() {
        return code;
    }

    public String getDesc() {
        return desc;
    }

    /**
     * 根据编码获取枚举
     */
    public static RoleTypeEnum getByCode(Integer code) {
        if (code == null) {
            return null;
        }
        for (RoleTypeEnum item : values()) {
            if (item.code.equals(code)) {
                return item;
            }
        }
        return null;
    }
}
