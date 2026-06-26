package com.huuc.dormitory.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import java.time.LocalDateTime;

/**
 * 晚归录入DTO
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class LateReturnDTO {

    /** 学生ID */
    @NotNull(message = "学生ID不能为空")
    private Long studentId;

    /** 晚归时间 */
    @NotNull(message = "晚归时间不能为空")
    private LocalDateTime lateTime;

    /** 晚归原因 */
    @Size(max = 255, message = "晚归原因长度不能超过255个字符")
    private String lateReason;
}
