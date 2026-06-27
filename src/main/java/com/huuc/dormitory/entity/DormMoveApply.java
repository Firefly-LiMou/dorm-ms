package com.huuc.dormitory.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;

/**
 * 调宿申请实体类
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class DormMoveApply {

    /** 申请ID */
    private Long applyId;

    /** 申请人学生ID */
    private Long studentId;

    /** 原床位ID */
    private Long originalBedId;

    /** 目标床位ID */
    private Long targetBedId;

    /** 申请原因 */
    private String applyReason;

    /** 申请提交时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime applyTime;

    /** 审批状态：0-待审批 1-已通过 2-已驳回 */
    private Integer auditStatus;

    /** 审批人ID */
    private Long auditorId;

    /** 审批时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime auditTime;

    /** 审批意见 */
    private String auditOpinion;

    /** 备注 */
    private String remark;

    /** 创建时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;

    /** 更新时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updateTime;
}
