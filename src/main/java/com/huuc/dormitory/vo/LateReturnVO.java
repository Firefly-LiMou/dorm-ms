package com.huuc.dormitory.vo;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;

/**
 * 晚归记录详情VO
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class LateReturnVO {

    /** 记录ID */
    private Long recordId;

    /** 晚归学生ID */
    private Long studentId;

    /** 学生姓名 */
    private String studentName;

    /** 学号 */
    private String studentNo;

    /** 楼栋ID */
    private Long buildingId;

    /** 楼栋名称 */
    private String buildingName;

    /** 晚归时间 */
    private LocalDateTime lateTime;

    /** 晚归原因 */
    private String lateReason;

    /** 登记人ID */
    private Long registrarId;

    /** 登记人姓名 */
    private String registrarName;

    /** 登记时间 */
    private LocalDateTime recordTime;

    /** 备注 */
    private String remark;
}
