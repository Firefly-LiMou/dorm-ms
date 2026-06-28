package com.huuc.dormitory.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.util.ArrayList;
import java.util.List;

/**
 * 导入结果封装
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class ImportResultDTO {

    /** 成功条数 */
    private Integer successCount = 0;

    /** 失败条数 */
    private Integer failCount = 0;

    /** 失败明细 */
    private List<ImportFailDetail> failDetails = new ArrayList<>();

    /**
     * 增加成功计数
     */
    public void addSuccess() {
        this.successCount++;
    }

    /**
     * 增加失败记录
     * @param row 行号
     * @param reason 失败原因
     */
    public void addFail(Integer row, String reason) {
        this.failCount++;
        this.failDetails.add(new ImportFailDetail(row, reason));
    }
}
