package com.huuc.dormitory.common.enums;

/**
 * 报修类型枚举
 */
public enum RepairTypeEnum {

    WATER_ELECTRIC(1, "水电故障"),
    FURNITURE(2, "家具损坏"),
    DOOR_WINDOW(3, "门窗故障"),
    OTHER(4, "其他");

    private final Integer code;
    private final String desc;

    RepairTypeEnum(Integer code, String desc) {
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
    public static RepairTypeEnum getByCode(Integer code) {
        if (code == null) {
            return null;
        }
        for (RepairTypeEnum item : values()) {
            if (item.code.equals(code)) {
                return item;
            }
        }
        return null;
    }
}
