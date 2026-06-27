package com.huuc.dormitory.vo;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/**
 * 舍友信息VO
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class RoommateVO {

    /** 学生用户ID */
    private Long studentId;

    /** 学生姓名 */
    private String studentName;

    /** 学号 */
    private String studentNo;

    /** 联系电话 */
    private String phone;

    /** 床位编号 */
    private String bedNo;
}
