package com.huuc.dormitory.common.enums;

/**
 * 审批状态枚举
 */
public enum AuditStatusEnum {

    PENDING(0, "待审批"),
    APPROVED(1, "已通过"),
    REJECTED(2, "已驳回");

    private final Integer code;
    private final String desc;

    AuditStatusEnum(Integer code, String desc) {
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
    public static AuditStatusEnum getByCode(Integer code) {
        if (code == null) {
            return null;
        }
        for (AuditStatusEnum item : values()) {
            if (item.code.equals(code)) {
                return item;
            }
        }
        return null;
    }
}
