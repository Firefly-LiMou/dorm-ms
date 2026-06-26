package com.huuc.dormitory.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import javax.validation.constraints.Min;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

/**
 * 房间新增/编辑DTO
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class RoomDTO {

    /** 房间ID（编辑时必填） */
    private Long roomId;

    /** 房间编号 */
    @NotBlank(message = "房间编号不能为空")
    private String roomNo;

    /** 所属楼栋ID */
    @NotNull(message = "所属楼栋不能为空")
    private Long buildingId;

    /** 所在楼层 */
    @NotNull(message = "所在楼层不能为空")
    @Min(value = 1, message = "楼层至少为1")
    private Integer floorNum;

    /** 额定床位数 */
    @NotNull(message = "额定床位数不能为空")
    @Min(value = 1, message = "床位数至少为1")
    private Integer bedTotal;

    /** 房间类型 */
    @NotNull(message = "房间类型不能为空")
    private Integer roomType;

    /** 备注 */
    private String remark;
}
