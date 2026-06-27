package com.huuc.dormitory.controller.admin;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.common.aop.OperLog;
import com.huuc.dormitory.common.enums.OperTypeEnum;
import com.huuc.dormitory.common.result.Result;
import com.huuc.dormitory.common.utils.SessionUtil;
import com.huuc.dormitory.dto.RepairHandleDTO;
import com.huuc.dormitory.entity.DormRepair;
import com.huuc.dormitory.service.RepairService;
import com.huuc.dormitory.vo.RepairVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

/**
 * 管理员端报修管理控制器
 */
@Controller
@RequestMapping("/admin/repair")
public class AdminRepairController {

    @Autowired
    private RepairService repairService;

    /**
     * 报修列表页面
     */
    @GetMapping("/list")
    public String listPage() {
        return "admin/repair/list";
    }

    /**
     * 报修详情页面
     */
    @GetMapping("/detailPage")
    public String detailPage() {
        return "admin/repair/detail";
    }

    /**
     * 查询报修列表（分页）
     */
    @GetMapping("/page")
    @ResponseBody
    public Result<PageInfo<RepairVO>> getRepairPage(
            @RequestParam(required = false) Long studentId,
            @RequestParam(required = false) Integer repairType,
            @RequestParam(required = false) Integer repairStatus,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {

        DormRepair query = new DormRepair();
        query.setStudentId(studentId);
        query.setRepairType(repairType);
        query.setRepairStatus(repairStatus);

        PageHelper.startPage(pageNum, pageSize);
        PageInfo<RepairVO> pageInfo = repairService.getRepairList(query, pageNum, pageSize);

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
     * 接单处理
     */
    @PostMapping("/handle/{repairId}")
    @ResponseBody
    @OperLog(module = "报修管理", type = OperTypeEnum.UPDATE, desc = "接单处理")
    public Result<Void> handleRepair(@PathVariable Long repairId, HttpSession session) {
        Long handlerId = SessionUtil.getCurrentUserId(session);
        repairService.handleRepair(repairId, handlerId);
        return Result.success();
    }

    /**
     * 完结报修
     */
    @PostMapping("/complete/{repairId}")
    @ResponseBody
    @OperLog(module = "报修管理", type = OperTypeEnum.UPDATE, desc = "完结报修")
    public Result<Void> completeRepair(@PathVariable Long repairId, @RequestBody @Valid RepairHandleDTO dto, HttpSession session) {
        Long handlerId = SessionUtil.getCurrentUserId(session);
        repairService.completeRepair(repairId, dto, handlerId);
        return Result.success();
    }
}
