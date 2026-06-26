package com.huuc.dormitory.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

/**
 * 调宿申请DTO
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class MoveApplyDTO {

    /** 目标床位ID */
    @NotNull(message = "目标床位不能为空")
    private Long targetBedId;

    /** 申请原因 */
    @NotBlank(message = "申请原因不能为空")
    @Size(max = 255, message = "申请原因长度不能超过255个字符")
    private String applyReason;
}
