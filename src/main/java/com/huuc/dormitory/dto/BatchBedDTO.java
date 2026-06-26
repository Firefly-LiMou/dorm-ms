package com.huuc.dormitory.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;

/**
 * 批量初始化床位DTO
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class BatchBedDTO {

    /** 房间ID */
    @NotNull(message = "房间ID不能为空")
    private Long roomId;

    /** 床位数量 */
    @NotNull(message = "床位数量不能为空")
    @Min(value = 1, message = "床位数量至少为1")
    private Integer bedCount;
}
