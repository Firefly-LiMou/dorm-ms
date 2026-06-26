package com.huuc.dormitory.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

/**
 * 调宿审批DTO
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class MoveAuditDTO {

    /** 审批状态：1-通过 2-驳回 */
    @NotNull(message = "审批状态不能为空")
    private Integer auditStatus;

    /** 审批意见 */
    @Size(max = 255, message = "审批意见长度不能超过255个字符")
    private String auditOpinion;
}
