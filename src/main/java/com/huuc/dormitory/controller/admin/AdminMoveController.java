package com.huuc.dormitory.controller.admin;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.common.aop.OperLog;
import com.huuc.dormitory.common.enums.AuditStatusEnum;
import com.huuc.dormitory.common.enums.OperTypeEnum;
import com.huuc.dormitory.common.result.Result;
import com.huuc.dormitory.common.utils.SessionUtil;
import com.huuc.dormitory.dto.MoveAuditDTO;
import com.huuc.dormitory.entity.DormMoveApply;
import com.huuc.dormitory.service.MoveApplyService;
import com.huuc.dormitory.vo.MoveApplyVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

/**
 * 管理员端调宿管理控制器
 */
@Controller
@RequestMapping("/admin/move")
public class AdminMoveController {

    @Autowired
    private MoveApplyService moveApplyService;

    /**
     * 调宿申请列表页面
     */
    @GetMapping("/list")
    public String listPage() {
        return "admin/move/list";
    }

    /**
     * 查询调宿申请列表（分页）
     */
    @GetMapping("/page")
    @ResponseBody
    public Result<PageInfo<MoveApplyVO>> getApplyPage(
            @RequestParam(required = false) String studentNo,
            @RequestParam(required = false) Integer auditStatus,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {

        PageHelper.startPage(pageNum, pageSize);
        PageInfo<MoveApplyVO> pageInfo;

        // 如果传入学号，按学号模糊查询
        if (studentNo != null && !studentNo.trim().isEmpty()) {
            pageInfo = moveApplyService.getApplyListByStudentNo(studentNo.trim(), auditStatus, pageNum, pageSize);
        } else {
            DormMoveApply query = new DormMoveApply();
            query.setAuditStatus(auditStatus);
            pageInfo = moveApplyService.getApplyList(query, pageNum, pageSize);
        }

        return Result.success(pageInfo);
    }

    /**
     * 查询待审批列表
     */
    @GetMapping("/pending")
    @ResponseBody
    public Result<PageInfo<MoveApplyVO>> getPendingPage(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {

        DormMoveApply query = new DormMoveApply();
        query.setAuditStatus(AuditStatusEnum.PENDING.getCode());

        PageHelper.startPage(pageNum, pageSize);
        PageInfo<MoveApplyVO> pageInfo = moveApplyService.getApplyList(query, pageNum, pageSize);

        return Result.success(pageInfo);
    }

    /**
     * 获取申请详情
     */
    @GetMapping("/{applyId}")
    @ResponseBody
    public Result<MoveApplyVO> getApplyById(@PathVariable Long applyId) {
        MoveApplyVO vo = moveApplyService.getApplyById(applyId);
        return Result.success(vo);
    }

    /**
     * 审批调宿申请
     */
    @PostMapping("/audit/{applyId}")
    @ResponseBody
    @OperLog(module = "调宿管理", type = OperTypeEnum.AUDIT, desc = "审批调宿申请")
    public Result<Void> audit(@PathVariable Long applyId, @RequestBody @Valid MoveAuditDTO dto, HttpSession session) {
        Long auditorId = SessionUtil.getCurrentUserId(session);
        moveApplyService.audit(applyId, dto, auditorId);
        return Result.success();
    }
}
