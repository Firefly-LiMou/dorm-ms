package com.huuc.dormitory.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;

/**
 * 报修记录实体类
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class DormRepair {

    /** 报修单ID */
    private Long repairId;

    /** 报修学生ID */
    private Long studentId;

    /** 报修房间ID */
    private Long roomId;

    /** 报修类型：1-水电故障 2-家具损坏 3-门窗故障 4-其他 */
    private Integer repairType;

    /** 报修详情描述 */
    private String repairContent;

    /** 联系电话 */
    private String contactPhone;

    /** 提交时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime submitTime;

    /** 处理状态：0-待处理 1-处理中 2-已完成 */
    private Integer repairStatus;

    /** 处理人ID */
    private Long handlerId;

    /** 处理结果 */
    private String handleResult;

    /** 处理完成时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime finishTime;

    /** 备注 */
    private String remark;

    /** 创建时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;

    /** 更新时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updateTime;
}
