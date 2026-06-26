package com.huuc.dormitory.common.enums;

/**
 * 房间类型枚举
 */
public enum RoomTypeEnum {

    FOUR_BED(1, "四人间"),
    SIX_BED(2, "六人间"),
    EIGHT_BED(3, "八人间");

    private final Integer code;
    private final String desc;

    RoomTypeEnum(Integer code, String desc) {
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
    public static RoomTypeEnum getByCode(Integer code) {
        if (code == null) {
            return null;
        }
        for (RoomTypeEnum item : values()) {
            if (item.code.equals(code)) {
                return item;
            }
        }
        return null;
    }
}
