package com.huuc.dormitory.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/**
 * 导入失败明细
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class ImportFailDetail {

    /** 行号 */
    private Integer row;

    /** 失败原因 */
    private String reason;

    public ImportFailDetail(Integer row, String reason) {
        this.row = row;
        this.reason = reason;
    }
}
