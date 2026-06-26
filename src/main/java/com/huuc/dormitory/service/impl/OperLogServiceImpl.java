package com.huuc.dormitory.service.impl;

import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.dao.SysOperLogMapper;
import com.huuc.dormitory.entity.SysOperLog;
import com.huuc.dormitory.service.OperLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 操作日志服务实现类
 */
@Service
public class OperLogServiceImpl implements OperLogService {

    @Autowired
    private SysOperLogMapper sysOperLogMapper;

    @Override
    public PageInfo<SysOperLog> getLogList(SysOperLog query, Integer pageNum, Integer pageSize) {
        List<SysOperLog> logs = sysOperLogMapper.selectList(query);
        PageInfo<SysOperLog> pageInfo = new PageInfo<>(logs);
        return pageInfo;
    }
}
