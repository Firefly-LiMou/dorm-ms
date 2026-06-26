package com.huuc.dormitory.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

/**
 * 报修提交DTO
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class RepairDTO {

    /** 报修类型 */
    @NotNull(message = "报修类型不能为空")
    private Integer repairType;

    /** 报修内容 */
    @NotBlank(message = "报修内容不能为空")
    @Size(max = 500, message = "报修内容长度不能超过500个字符")
    private String repairContent;

    /** 联系电话 */
    @NotBlank(message = "联系电话不能为空")
    private String contactPhone;
}
