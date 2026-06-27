package com.huuc.dormitory.common.aop;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.huuc.dormitory.common.utils.SessionUtil;
import com.huuc.dormitory.dao.SysOperLogMapper;
import com.huuc.dormitory.entity.SysOperLog;
import com.huuc.dormitory.entity.SysUser;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.reflect.MethodSignature;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.lang.reflect.Method;
import java.time.LocalDateTime;

/**
 * 操作日志切面
 * 拦截标注了@OperLog注解的方法，自动记录操作日志
 */
@Aspect
@Component
public class OperLogAspect {

    private static final Logger logger = LoggerFactory.getLogger(OperLogAspect.class);

    @Autowired
    private SysOperLogMapper sysOperLogMapper;

    @Autowired
    private ObjectMapper objectMapper;

    /**
     * 切点：标注了@OperLog注解的方法
     */
    @Pointcut("@annotation(com.huuc.dormitory.common.aop.OperLog)")
    public void operLogPointcut() {
    }

    /**
     * 环绕通知
     */
    @Around("operLogPointcut()")
    public Object around(ProceedingJoinPoint joinPoint) throws Throwable {
        // 获取方法信息
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        Method method = signature.getMethod();
        OperLog operLog = method.getAnnotation(OperLog.class);

        // 获取请求信息
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        HttpServletRequest request = attributes != null ? attributes.getRequest() : null;

        // 获取操作人信息
        HttpSession session = request != null ? request.getSession() : null;
        SysUser currentUser = SessionUtil.getCurrentUser(session);
        Long operatorId = currentUser != null ? currentUser.getUserId() : null;

        // 获取请求IP
        String operIp = getClientIp(request);

        // 获取请求参数
        String requestParam = getRequestParams(joinPoint);

        // 执行目标方法
        Object result = null;
        boolean success = true;
        String errorMsg = null;
        try {
            result = joinPoint.proceed();
        } catch (Throwable e) {
            success = false;
            errorMsg = e.getMessage();
            // 截取前500字符
            if (errorMsg != null && errorMsg.length() > 500) {
                errorMsg = errorMsg.substring(0, 500);
            }
            throw e;
        } finally {
            // 记录操作日志（成功或失败都记录）
            try {
                SysOperLog log = new SysOperLog();
                log.setOperatorId(operatorId);
                log.setModuleName(operLog.module());
                log.setOperType(operLog.type().getCode());
                log.setOperDesc(success ? operLog.desc() : operLog.desc() + "（失败：" + errorMsg + "）");
                log.setOperIp(operIp);
                log.setRequestParam(requestParam);
                log.setOperTime(LocalDateTime.now());

                sysOperLogMapper.insert(log);
            } catch (Exception e) {
                // 日志记录失败不影响主业务
                logger.error("操作日志记录失败：", e);
            }
        }

        return result;
    }

    /**
     * 获取客户端IP
     */
    private String getClientIp(HttpServletRequest request) {
        if (request == null) {
            return null;
        }
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("X-Real-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        // 多个代理时取第一个
        if (ip != null && ip.contains(",")) {
            ip = ip.substring(0, ip.indexOf(",")).trim();
        }
        return ip;
    }

    /**
     * 获取请求参数
     */
    private String getRequestParams(ProceedingJoinPoint joinPoint) {
        try {
            Object[] args = joinPoint.getArgs();
            if (args == null || args.length == 0) {
                return null;
            }
            // 过滤掉HttpServletRequest等不可序列化的参数
            StringBuilder sb = new StringBuilder();
            for (Object arg : args) {
                if (arg instanceof HttpServletRequest) {
                    continue;
                }
                if (sb.length() > 0) {
                    sb.append(", ");
                }
                sb.append(objectMapper.writeValueAsString(arg));
            }
            return sb.toString();
        } catch (Exception e) {
            logger.warn("获取请求参数失败：", e);
            return null;
        }
    }
}
