package com.huuc.dormitory.controller.admin;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.common.result.Result;
import com.huuc.dormitory.entity.SysOperLog;
import com.huuc.dormitory.service.OperLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * 管理员端操作日志控制器
 */
@Controller
@RequestMapping("/admin/log")
public class AdminLogController {

    @Autowired
    private OperLogService operLogService;

    /**
     * 操作日志列表页面
     */
    @GetMapping("/list")
    public String listPage() {
        return "admin/log/list";
    }

    /**
     * 查询操作日志列表（分页）
     */
    @GetMapping("/page")
    @ResponseBody
    public Result<PageInfo<SysOperLog>> getLogPage(
            @RequestParam(required = false) Long operatorId,
            @RequestParam(required = false) String moduleName,
            @RequestParam(required = false) String operType,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {

        SysOperLog query = new SysOperLog();
        query.setOperatorId(operatorId);
        query.setModuleName(moduleName);
        query.setOperType(operType);

        PageHelper.startPage(pageNum, pageSize);
        PageInfo<SysOperLog> pageInfo = operLogService.getLogList(query, pageNum, pageSize);

        return Result.success(pageInfo);
    }
}
