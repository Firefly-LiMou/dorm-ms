package com.huuc.dormitory.controller.student;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.common.aop.OperLog;
import com.huuc.dormitory.common.enums.OperTypeEnum;
import com.huuc.dormitory.common.result.Result;
import com.huuc.dormitory.common.utils.SessionUtil;
import com.huuc.dormitory.dto.MoveApplyDTO;
import com.huuc.dormitory.service.MoveApplyService;
import com.huuc.dormitory.vo.MoveApplyVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

/**
 * 学生端调宿管理控制器
 */
@Controller
@RequestMapping("/student/move")
public class StudentMoveController {

    @Autowired
    private MoveApplyService moveApplyService;

    /**
     * 我的调宿申请列表页面
     */
    @GetMapping("/list")
    public String listPage() {
        return "student/move/list";
    }

    /**
     * 提交调宿申请页面
     */
    @GetMapping("/applyPage")
    public String applyPage() {
        return "student/move/apply";
    }

    /**
     * 查询我的调宿申请（分页）
     */
    @GetMapping("/page")
    @ResponseBody
    public Result<PageInfo<MoveApplyVO>> getMyApplyPage(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            HttpSession session) {

        Long studentId = SessionUtil.getCurrentUserId(session);
        PageHelper.startPage(pageNum, pageSize);
        PageInfo<MoveApplyVO> pageInfo = moveApplyService.getMyApplies(studentId, pageNum, pageSize);

        return Result.success(pageInfo);
    }

    /**
     * 提交调宿申请
     */
    @PostMapping("/apply")
    @ResponseBody
    @OperLog(module = "调宿管理", type = OperTypeEnum.ADD, desc = "提交调宿申请")
    public Result<Void> apply(@RequestBody @Valid MoveApplyDTO dto, HttpSession session) {
        Long studentId = SessionUtil.getCurrentUserId(session);
        moveApplyService.apply(dto, studentId);
        return Result.success();
    }

    /**
     * 撤销调宿申请
     */
    @PostMapping("/cancel/{applyId}")
    @ResponseBody
    @OperLog(module = "调宿管理", type = OperTypeEnum.UPDATE, desc = "撤销调宿申请")
    public Result<Void> cancel(@PathVariable Long applyId, HttpSession session) {
        Long studentId = SessionUtil.getCurrentUserId(session);
        moveApplyService.cancel(applyId, studentId);
        return Result.success();
    }
}
