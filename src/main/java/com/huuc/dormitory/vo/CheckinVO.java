package com.huuc.dormitory.vo;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;

/**
 * 入住记录详情VO
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class CheckinVO {

    /** 入住记录ID */
    private Long checkinId;

    /** 学生用户ID */
    private Long studentId;

    /** 学生姓名 */
    private String studentName;

    /** 学号 */
    private String studentNo;

    /** 床位ID */
    private Long bedId;

    /** 床位编号 */
    private String bedNo;

    /** 房间编号 */
    private String roomNo;

    /** 楼栋名称 */
    private String buildingName;

    /** 入住时间 */
    private LocalDateTime checkinTime;

    /** 退宿时间 */
    private LocalDateTime checkoutTime;

    /** 入住状态 */
    private Integer checkinStatus;

    /** 入住状态文本 */
    private String checkinStatusText;

    /** 办理人姓名 */
    private String operatorName;

    /** 备注 */
    private String remark;
}
