package com.huuc.dormitory.controller.dorm;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.common.aop.OperLog;
import com.huuc.dormitory.common.enums.OperTypeEnum;
import com.huuc.dormitory.common.result.Result;
import com.huuc.dormitory.common.utils.SessionUtil;
import com.huuc.dormitory.dto.CheckinDTO;
import com.huuc.dormitory.entity.SysUser;
import com.huuc.dormitory.service.BuildingService;
import com.huuc.dormitory.service.CheckinService;
import com.huuc.dormitory.vo.BuildingVO;
import com.huuc.dormitory.vo.CheckinVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.util.List;

/**
 * 宿管端入住管理控制器
 */
@Controller
@RequestMapping("/dorm/checkin")
public class DormCheckinController {

    @Autowired
    private CheckinService checkinService;

    @Autowired
    private BuildingService buildingService;

    /**
     * 入住记录列表页面
     */
    @GetMapping("/list")
    public String listPage() {
        return "dorm/checkin/list";
    }

    /**
     * 办理入住页面
     */
    @GetMapping("/checkinPage")
    public String checkinPage() {
        return "dorm/checkin/checkin";
    }

    /**
     * 查询本楼栋入住记录（分页）
     */
    @GetMapping("/page")
    @ResponseBody
    public Result<PageInfo<CheckinVO>> getCheckinPage(
            @RequestParam(required = false) Long buildingId,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            HttpSession session) {

        // 如果未指定楼栋，使用宿管负责的第一个楼栋
        if (buildingId == null) {
            Long managerId = SessionUtil.getCurrentUserId(session);
            List<BuildingVO> buildings = buildingService.getBuildingsByManagerId(managerId);
            if (buildings.isEmpty()) {
                return Result.fail("您暂未负责任何楼栋，请联系管理员");
            }
            buildingId = buildings.get(0).getBuildingId();
        }

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
