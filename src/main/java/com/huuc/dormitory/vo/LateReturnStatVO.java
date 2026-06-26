package com.huuc.dormitory.vo;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/**
 * 晚归统计VO
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class LateReturnStatVO {

    /** 楼栋ID */
    private Long buildingId;

    /** 楼栋名称 */
    private String buildingName;

    /** 晚归人次 */
    private Integer count;
}
