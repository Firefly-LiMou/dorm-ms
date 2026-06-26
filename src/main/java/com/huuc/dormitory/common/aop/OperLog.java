package com.huuc.dormitory.common.aop;

import com.huuc.dormitory.common.enums.OperTypeEnum;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 操作日志注解
 * 标注在Controller方法上，自动记录操作日志
 */
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface OperLog {

    /** 操作模块 */
    String module();

    /** 操作类型 */
    OperTypeEnum type();

    /** 操作描述 */
    String desc() default "";
}
