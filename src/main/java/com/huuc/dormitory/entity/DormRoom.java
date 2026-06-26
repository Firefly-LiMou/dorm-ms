package com.huuc.dormitory.entity;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;

/**
 * 房间实体类
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class DormRoom {

    /** 房间主键ID */
    private Long roomId;

    /** 房间编号 */
    private String roomNo;

    /** 所属楼栋ID */
    private Long buildingId;

    /** 所在楼层 */
    private Integer floorNum;

    /** 额定床位数 */
    private Integer bedTotal;

    /** 房间类型：1-四人间 2-六人间 3-八人间 */
    private Integer roomType;

    /** 备注 */
    private String remark;

    /** 创建时间 */
    private LocalDateTime createTime;

    /** 更新时间 */
    private LocalDateTime updateTime;

    /** 逻辑删除标记：0-未删除 1-已删除 */
    private Integer isDeleted;
}
