package com.huuc.dormitory.vo;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;

/**
 * 楼栋详情展示VO
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class BuildingVO {

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

    /** 宿管姓名 */
    private String managerName;

    /** 备注 */
    private String remark;

    /** 创建时间 */
    private LocalDateTime createTime;
}
