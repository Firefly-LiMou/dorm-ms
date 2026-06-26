package com.huuc.dormitory.controller.student;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.common.aop.OperLog;
import com.huuc.dormitory.common.enums.OperTypeEnum;
import com.huuc.dormitory.common.result.Result;
import com.huuc.dormitory.common.utils.SessionUtil;
import com.huuc.dormitory.dto.RepairDTO;
import com.huuc.dormitory.service.RepairService;
import com.huuc.dormitory.vo.RepairVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

/**
 * 学生端报修控制器
 */
@Controller
@RequestMapping("/student/repair")
public class StudentRepairController {

    @Autowired
    private RepairService repairService;

    /**
     * 我的报修列表页面
     */
    @GetMapping("/list")
    public String listPage() {
        return "student/repair/list";
    }

    /**
     * 查询我的报修（分页）
     */
    @GetMapping("/page")
    @ResponseBody
    public Result<PageInfo<RepairVO>> getMyRepairPage(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            HttpSession session) {

        Long studentId = SessionUtil.getCurrentUserId(session);
        PageHelper.startPage(pageNum, pageSize);
        PageInfo<RepairVO> pageInfo = repairService.getMyRepairs(studentId, pageNum, pageSize);

        return Result.success(pageInfo);
    }

    /**
     * 获取报修详情
     */
    @GetMapping("/{repairId}")
    @ResponseBody
    public Result<RepairVO> getRepairById(@PathVariable Long repairId) {
        RepairVO vo = repairService.getRepairById(repairId);
        return Result.success(vo);
    }

    /**
     * 提交报修
     */
    @PostMapping("/submit")
    @ResponseBody
    @OperLog(module = "报修管理", type = OperTypeEnum.ADD, desc = "提交报修")
    public Result<Void> submitRepair(@RequestBody @Valid RepairDTO dto, HttpSession session) {
        Long studentId = SessionUtil.getCurrentUserId(session);
        repairService.submitRepair(dto, studentId);
        return Result.success();
    }
}
