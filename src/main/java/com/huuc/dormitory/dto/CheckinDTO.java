package com.huuc.dormitory.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import javax.validation.constraints.NotNull;

/**
 * 入住登记DTO
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class CheckinDTO {

    /** 学生ID */
    @NotNull(message = "学生ID不能为空")
    private Long studentId;

    /** 床位ID */
    @NotNull(message = "床位ID不能为空")
    private Long bedId;

    /** 备注 */
    private String remark;
}
