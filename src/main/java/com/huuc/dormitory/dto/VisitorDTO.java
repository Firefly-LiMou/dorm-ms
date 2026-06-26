package com.huuc.dormitory.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import java.time.LocalDateTime;

/**
 * 访客录入DTO
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class VisitorDTO {

    /** 访客姓名 */
    @NotBlank(message = "访客姓名不能为空")
    private String visitorName;

    /** 身份证号 */
    @NotBlank(message = "身份证号不能为空")
    @Size(min = 18, max = 18, message = "身份证号长度必须为18位")
    private String idCard;

    /** 被访学生ID */
    @NotNull(message = "被访学生ID不能为空")
    private Long studentId;

    /** 来访时间 */
    @NotNull(message = "来访时间不能为空")
    private LocalDateTime visitTime;

    /** 来访事由 */
    @Size(max = 255, message = "来访事由长度不能超过255个字符")
    private String visitReason;
}
