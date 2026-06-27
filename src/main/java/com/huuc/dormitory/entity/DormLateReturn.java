package com.huuc.dormitory.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;

/**
 * 晚归记录实体类
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class DormLateReturn {

    /** 记录ID */
    private Long recordId;

    /** 晚归学生ID */
    private Long studentId;

    /** 所属楼栋ID */
    private Long buildingId;

    /** 晚归时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime lateTime;

    /** 晚归原因 */
    private String lateReason;

    /** 登记人ID */
    private Long registrarId;

    /** 登记时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime recordTime;

    /** 备注 */
    private String remark;

    /** 创建时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;

    /** 更新时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updateTime;
}
