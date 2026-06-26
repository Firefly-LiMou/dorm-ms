package com.huuc.dormitory.common.enums;

/**
 * 床位状态枚举
 */
public enum BedStatusEnum {

    FREE(0, "空闲"),
    OCCUPIED(1, "已入住"),
    DISABLED(2, "维修禁用");

    private final Integer code;
    private final String desc;

    BedStatusEnum(Integer code, String desc) {
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
    public static BedStatusEnum getByCode(Integer code) {
        if (code == null) {
            return null;
        }
        for (BedStatusEnum item : values()) {
            if (item.code.equals(code)) {
                return item;
            }
        }
        return null;
    }
}
