package com.huuc.dormitory.common.enums;

/**
 * 入住状态枚举
 */
public enum CheckinStatusEnum {

    LIVING(1, "在住"),
    CHECKED_OUT(2, "已退宿");

    private final Integer code;
    private final String desc;

    CheckinStatusEnum(Integer code, String desc) {
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
    public static CheckinStatusEnum getByCode(Integer code) {
        if (code == null) {
            return null;
        }
        for (CheckinStatusEnum item : values()) {
            if (item.code.equals(code)) {
                return item;
            }
        }
        return null;
    }
}
