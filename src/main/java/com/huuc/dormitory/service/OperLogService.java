package com.huuc.dormitory.service;

import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.entity.SysOperLog;

/**
 * 操作日志服务接口
 */
public interface OperLogService {

    /**
     * 分页查询操作日志列表
     */
    PageInfo<SysOperLog> getLogList(SysOperLog query, Integer pageNum, Integer pageSize);
}
