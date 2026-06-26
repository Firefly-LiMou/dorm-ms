package com.huuc.dormitory.entity;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;

/**
 * 楼栋实体类
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class DormBuilding {

    /** 楼栋主键ID */
    private Long buildingId;

    /** 楼栋编号 */
    private String buildingNo;

    /** 楼栋名称 */
    private String buildingName;

    /** 楼层总数 */
    private Integer floorCount;

    /** 所属区域 */
    private String area;

    /** 负责宿管ID */
    private Long managerId;

    /** 备注 */
    private String remark;

    /** 创建时间 */
    private LocalDateTime createTime;

    /** 更新时间 */
    private LocalDateTime updateTime;

    /** 逻辑删除标记：0-未删除 1-已删除 */
    private Integer isDeleted;
}
