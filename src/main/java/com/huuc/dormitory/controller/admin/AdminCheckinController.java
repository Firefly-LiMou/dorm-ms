package com.huuc.dormitory.controller.admin;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.common.aop.OperLog;
import com.huuc.dormitory.common.enums.OperTypeEnum;
import com.huuc.dormitory.common.result.Result;
import com.huuc.dormitory.common.utils.SessionUtil;
import com.huuc.dormitory.dto.CheckinDTO;
import com.huuc.dormitory.entity.DormCheckinRecord;
import com.huuc.dormitory.service.CheckinService;
import com.huuc.dormitory.vo.CheckinVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

/**
 * 管理员端入住管理控制器
 */
@Controller
@RequestMapping("/admin/checkin")
public class AdminCheckinController {

    @Autowired
    private CheckinService checkinService;

    /**
     * 入住记录列表页面
     */
    @GetMapping("/list")
    public String listPage() {
        return "admin/checkin/list";
    }

    /**
     * 办理入住页面
     */
    @GetMapping("/checkinPage")
    public String checkinPage() {
        return "admin/checkin/checkin";
    }

    /**
     * 查询入住记录列表（分页）
     */
    @GetMapping("/page")
    @ResponseBody
    public Result<PageInfo<CheckinVO>> getCheckinPage(
            @RequestParam(required = false) String studentNo,
            @RequestParam(required = false) Integer checkinStatus,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {

        PageHelper.startPage(pageNum, pageSize);
        PageInfo<CheckinVO> pageInfo;

        // 如果传入学号，按学号模糊查询
        if (studentNo != null && !studentNo.trim().isEmpty()) {
            pageInfo = checkinService.getCheckinListByStudentNo(studentNo.trim(), checkinStatus, pageNum, pageSize);
        } else {
            DormCheckinRecord query = new DormCheckinRecord();
            query.setCheckinStatus(checkinStatus);
            pageInfo = checkinService.getCheckinList(query, pageNum, pageSize);
        }

        return Result.success(pageInfo);
    }

    /**
     * 查询楼栋入住记录
     */
    @GetMapping("/building/{buildingId}")
    @ResponseBody
    public Result<PageInfo<CheckinVO>> getCheckinByBuilding(
            @PathVariable Long buildingId,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {

        PageHelper.startPage(pageNum, pageSize);
        PageInfo<CheckinVO> pageInfo = checkinService.getCheckinListByBuildingId(buildingId, pageNum, pageSize);

        return Result.success(pageInfo);
    }

    /**
     * 办理入住
     */
    @PostMapping("/checkin")
    @ResponseBody
    @OperLog(module = "入住管理", type = OperTypeEnum.ADD, desc = "办理入住")
    public Result<Void> checkin(@RequestBody @Valid CheckinDTO dto, HttpSession session) {
        Long operatorId = SessionUtil.getCurrentUserId(session);
        checkinService.checkin(dto, operatorId);
        return Result.success();
    }

    /**
     * 办理退宿
     */
    @PostMapping("/checkout/{checkinId}")
    @ResponseBody
    @OperLog(module = "入住管理", type = OperTypeEnum.UPDATE, desc = "办理退宿")
    public Result<Void> checkout(@PathVariable Long checkinId, HttpSession session) {
        Long operatorId = SessionUtil.getCurrentUserId(session);
        checkinService.checkout(checkinId, operatorId);
        return Result.success();
    }
}
