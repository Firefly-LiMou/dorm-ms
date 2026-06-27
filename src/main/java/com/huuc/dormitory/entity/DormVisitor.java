package com.huuc.dormitory.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;

/**
 * 访客记录实体类
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class DormVisitor {

    /** 访客记录ID */
    private Long visitorId;

    /** 访客姓名 */
    private String visitorName;

    /** 访客身份证号 */
    private String idCard;

    /** 被访学生ID */
    private Long studentId;

    /** 被访楼栋ID */
    private Long buildingId;

    /** 来访时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime visitTime;

    /** 离开时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime leaveTime;

    /** 来访事由 */
    private String visitReason;

    /** 登记人ID */
    private Long registrarId;

    /** 备注 */
    private String remark;

    /** 创建时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;

    /** 更新时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updateTime;
}
