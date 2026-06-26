package com.huuc.dormitory.common.enums;

/**
 * 操作类型枚举
 */
public enum OperTypeEnum {

    ADD("新增", "新增"),
    UPDATE("修改", "修改"),
    DELETE("删除", "删除"),
    AUDIT("审批", "审批"),
    QUERY("查询", "查询");

    private final String code;
    private final String desc;

    OperTypeEnum(String code, String desc) {
        this.code = code;
        this.desc = desc;
    }

    public String getCode() {
        return code;
    }

    public String getDesc() {
        return desc;
    }

    /**
     * 根据编码获取枚举
     */
    public static OperTypeEnum getByCode(String code) {
        if (code == null) {
            return null;
        }
        for (OperTypeEnum item : values()) {
            if (item.code.equals(code)) {
                return item;
            }
        }
        return null;
    }
}
