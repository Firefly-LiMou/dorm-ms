package com.huuc.dormitory.common.enums;

/**
 * 报修状态枚举
 */
public enum RepairStatusEnum {

    PENDING(0, "待处理"),
    PROCESSING(1, "处理中"),
    COMPLETED(2, "已完成");

    private final Integer code;
    private final String desc;

    RepairStatusEnum(Integer code, String desc) {
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
    public static RepairStatusEnum getByCode(Integer code) {
        if (code == null) {
            return null;
        }
        for (RepairStatusEnum item : values()) {
            if (item.code.equals(code)) {
                return item;
            }
        }
        return null;
    }
}
