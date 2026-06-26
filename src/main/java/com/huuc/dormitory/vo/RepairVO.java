package com.huuc.dormitory.vo;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;

/**
 * 报修详情VO
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class RepairVO {

    /** 报修单ID */
    private Long repairId;

    /** 报修学生ID */
    private Long studentId;

    /** 学生姓名 */
    private String studentName;

    /** 学号 */
    private String studentNo;

    /** 房间ID */
    private Long roomId;

    /** 房间编号 */
    private String roomNo;

    /** 楼栋名称 */
    private String buildingName;

    /** 报修类型 */
    private Integer repairType;

    /** 报修类型文本 */
    private String repairTypeText;

    /** 报修内容 */
    private String repairContent;

    /** 联系电话 */
    private String contactPhone;

    /** 提交时间 */
    private LocalDateTime submitTime;

    /** 处理状态 */
    private Integer repairStatus;

    /** 处理状态文本 */
    private String repairStatusText;

    /** 处理人ID */
    private Long handlerId;

    /** 处理人姓名 */
    private String handlerName;

    /** 处理结果 */
    private String handleResult;

    /** 处理完成时间 */
    private LocalDateTime finishTime;

    /** 是否超过24小时未处理 */
    private Boolean isTimeout;

    /** 备注 */
    private String remark;
}
