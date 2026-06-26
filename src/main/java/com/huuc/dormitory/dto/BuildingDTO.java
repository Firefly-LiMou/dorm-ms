package com.huuc.dormitory.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import javax.validation.constraints.Min;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

/**
 * 楼栋新增/编辑DTO
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class BuildingDTO {

    /** 楼栋ID（编辑时必填） */
    private Long buildingId;

    /** 楼栋编号 */
    @NotBlank(message = "楼栋编号不能为空")
    private String buildingNo;

    /** 楼栋名称 */
    @NotBlank(message = "楼栋名称不能为空")
    private String buildingName;

    /** 楼层总数 */
    @NotNull(message = "楼层总数不能为空")
    @Min(value = 1, message = "楼层总数至少为1")
    private Integer floorCount;

    /** 所属区域 */
    private String area;

    /** 负责宿管ID */
    private Long managerId;

    /** 备注 */
    private String remark;
}
