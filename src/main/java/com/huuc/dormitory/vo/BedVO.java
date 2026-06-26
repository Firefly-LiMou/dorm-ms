package com.huuc.dormitory.vo;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;

/**
 * 床位详情展示VO
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class BedVO {

    /** 床位主键ID */
    private Long bedId;

    /** 床位编号 */
    private String bedNo;

    /** 所属房间ID */
    private Long roomId;

    /** 房间编号 */
    private String roomNo;

    /** 楼栋名称 */
    private String buildingName;

    /** 床位状态 */
    private Integer bedStatus;

    /** 床位状态文本 */
    private String bedStatusText;

    /** 入住学生姓名（如有） */
    private String studentName;

    /** 备注 */
    private String remark;

    /** 创建时间 */
    private LocalDateTime createTime;
}
