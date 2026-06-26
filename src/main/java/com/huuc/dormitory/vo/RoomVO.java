package com.huuc.dormitory.vo;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;

/**
 * 房间详情展示VO
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class RoomVO {

    /** 房间主键ID */
    private Long roomId;

    /** 房间编号 */
    private String roomNo;

    /** 所属楼栋ID */
    private Long buildingId;

    /** 楼栋名称 */
    private String buildingName;

    /** 所在楼层 */
    private Integer floorNum;

    /** 额定床位数 */
    private Integer bedTotal;

    /** 房间类型 */
    private Integer roomType;

    /** 房间类型文本 */
    private String roomTypeText;

    /** 已入住床位数 */
    private Integer bedUsed;

    /** 备注 */
    private String remark;

    /** 创建时间 */
    private LocalDateTime createTime;
}
