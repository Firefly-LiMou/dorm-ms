package com.huuc.dormitory.vo;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;

/**
 * 调宿申请详情VO
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class MoveApplyVO {

    /** 申请ID */
    private Long applyId;

    /** 申请人学生ID */
    private Long studentId;

    /** 学生姓名 */
    private String studentName;

    /** 学号 */
    private String studentNo;

    /** 原床位ID */
    private Long originalBedId;

    /** 原床位信息 */
    private String originalBedInfo;

    /** 目标床位ID */
    private Long targetBedId;

    /** 目标床位信息 */
    private String targetBedInfo;

    /** 申请原因 */
    private String applyReason;

    /** 申请提交时间 */
    private LocalDateTime applyTime;

    /** 审批状态 */
    private Integer auditStatus;

    /** 审批状态文本 */
    private String auditStatusText;

    /** 审批人ID */
    private Long auditorId;

    /** 审批人姓名 */
    private String auditorName;

    /** 审批时间 */
    private LocalDateTime auditTime;

    /** 审批意见 */
    private String auditOpinion;
}
