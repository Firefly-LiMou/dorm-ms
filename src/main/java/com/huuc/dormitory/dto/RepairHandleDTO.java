package com.huuc.dormitory.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

/**
 * 报修处理DTO
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class RepairHandleDTO {

    /** 处理结果 */
    @NotBlank(message = "处理结果不能为空")
    @Size(max = 500, message = "处理结果长度不能超过500个字符")
    private String handleResult;
}
