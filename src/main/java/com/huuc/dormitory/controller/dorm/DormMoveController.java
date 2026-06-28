package com.huuc.dormitory.controller.dorm;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.common.aop.OperLog;
import com.huuc.dormitory.common.enums.AuditStatusEnum;
import com.huuc.dormitory.common.enums.OperTypeEnum;
import com.huuc.dormitory.common.result.Result;
import com.huuc.dormitory.common.utils.SessionUtil;
import com.huuc.dormitory.dto.MoveAuditDTO;
import com.huuc.dormitory.entity.DormMoveApply;
import com.huuc.dormitory.service.BuildingService;
import com.huuc.dormitory.service.MoveApplyService;
import com.huuc.dormitory.vo.BuildingVO;
import com.huuc.dormitory.vo.MoveApplyVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.util.List;

/**
 * 宿管端调宿管理控制器
 */
@Controller
@RequestMapping("/dorm/move")
public class DormMoveController {

    @Autowired
    private MoveApplyService moveApplyService;

    @Autowired
    private BuildingService buildingService;

    /**
     * 调宿申请列表页面
     */
    @GetMapping("/list")
    public String listPage() {
        return "dorm/move/list";
    }

    /**
     * 查询本楼栋调宿申请（分页）
     */
    @GetMapping("/page")
    @ResponseBody
    public Result<PageInfo<MoveApplyVO>> getApplyPage(
            @RequestParam(required = false) String studentNo,
            @RequestParam(required = false) Integer auditStatus,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            HttpSession session) {

        // 获取宿管负责的楼栋
        Long managerId = SessionUtil.getCurrentUserId(session);
        List<BuildingVO> buildings = buildingService.getBuildingsByManagerId(managerId);
        if (buildings.isEmpty()) {
            return Result.fail("您暂未负责任何楼栋，请联系管理员");
        }
        Long buildingId = buildings.get(0).getBuildingId();

        PageHelper.startPage(pageNum, pageSize);
        PageInfo<MoveApplyVO> pageInfo;

        // 如果传入学号，按学号模糊查询本楼栋
        if (studentNo != null && !studentNo.trim().isEmpty()) {
            pageInfo = moveApplyService.getApplyListByStudentNoAndBuildingId(studentNo.trim(), buildingId, auditStatus, pageNum, pageSize);
        } else {
            pageInfo = moveApplyService.getApplyListByBuildingId(buildingId, auditStatus, pageNum, pageSize);
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
            @RequestParam(defaultValue = "10") Integer pageSize,
            HttpSession session) {

        // 从Session获取宿管负责的楼栋，仅查询本楼栋待审批申请
        Long managerId = SessionUtil.getCurrentUserId(session);
        List<BuildingVO> buildings = buildingService.getBuildingsByManagerId(managerId);
        if (buildings.isEmpty()) {
            return Result.fail("您暂未负责任何楼栋，请联系管理员");
        }
        Long buildingId = buildings.get(0).getBuildingId();

        PageHelper.startPage(pageNum, pageSize);
        PageInfo<MoveApplyVO> pageInfo = moveApplyService.getApplyListByBuildingId(buildingId, AuditStatusEnum.PENDING.getCode(), pageNum, pageSize);

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
