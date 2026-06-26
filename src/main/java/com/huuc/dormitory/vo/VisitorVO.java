package com.huuc.dormitory.vo;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;

/**
 * 访客详情VO
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class VisitorVO {

    /** 访客记录ID */
    private Long visitorId;

    /** 访客姓名 */
    private String visitorName;

    /** 身份证号（脱敏） */
    private String idCard;

    /** 被访学生ID */
    private Long studentId;

    /** 被访学生姓名 */
    private String studentName;

    /** 楼栋ID */
    private Long buildingId;

    /** 楼栋名称 */
    private String buildingName;

    /** 来访时间 */
    private LocalDateTime visitTime;

    /** 离开时间 */
    private LocalDateTime leaveTime;

    /** 来访事由 */
    private String visitReason;

    /** 登记人ID */
    private Long registrarId;

    /** 登记人姓名 */
    private String registrarName;

    /** 备注 */
    private String remark;

    /** 状态：在访/已离开 */
    private String status;
}
