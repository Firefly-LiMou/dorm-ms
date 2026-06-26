package com.huuc.dormitory.entity;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;

/**
 * 入住记录实体类
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class DormCheckinRecord {

    /** 入住记录ID */
    private Long checkinId;

    /** 学生用户ID */
    private Long studentId;

    /** 入住床位ID */
    private Long bedId;

    /** 入住时间 */
    private LocalDateTime checkinTime;

    /** 退宿时间 */
    private LocalDateTime checkoutTime;

    /** 入住状态：1-在住 2-已退宿 */
    private Integer checkinStatus;

    /** 办理人ID */
    private Long operatorId;

    /** 备注 */
    private String remark;

    /** 创建时间 */
    private LocalDateTime createTime;

    /** 更新时间 */
    private LocalDateTime updateTime;
}
