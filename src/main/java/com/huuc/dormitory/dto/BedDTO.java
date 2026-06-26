package com.huuc.dormitory.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

/**
 * 床位新增DTO
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class BedDTO {

    /** 床位编号 */
    @NotBlank(message = "床位编号不能为空")
    private String bedNo;

    /** 所属房间ID */
    @NotNull(message = "所属房间不能为空")
    private Long roomId;

    /** 备注 */
    private String remark;
}
