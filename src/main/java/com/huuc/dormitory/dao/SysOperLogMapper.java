package com.huuc.dormitory.dao;

import com.huuc.dormitory.entity.SysOperLog;

import java.util.List;

/**
 * 操作日志Mapper接口
 */
public interface SysOperLogMapper {

    /**
     * 插入操作日志
     */
    int insert(SysOperLog log);

    /**
     * 根据操作人ID查询日志列表
     */
    List<SysOperLog> selectByOperatorId(Long operatorId);

    /**
     * 查询日志列表
     */
    List<SysOperLog> selectList(SysOperLog query);
}
