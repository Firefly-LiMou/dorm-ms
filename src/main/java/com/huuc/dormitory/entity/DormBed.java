package com.huuc.dormitory.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;

/**
 * 床位实体类
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class DormBed {

    /** 床位主键ID */
    private Long bedId;

    /** 床位编号 */
    private String bedNo;

    /** 所属房间ID */
    private Long roomId;

    /** 床位状态：0-空闲 1-已入住 2-维修禁用 */
    private Integer bedStatus;

    /** 备注 */
    private String remark;

    /** 创建时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;

    /** 更新时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updateTime;

    /** 逻辑删除标记：0-未删除 1-已删除 */
    private Integer isDeleted;
}
