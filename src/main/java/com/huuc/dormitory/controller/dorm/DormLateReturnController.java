package com.huuc.dormitory.controller.dorm;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.common.aop.OperLog;
import com.huuc.dormitory.common.enums.OperTypeEnum;
import com.huuc.dormitory.common.result.Result;
import com.huuc.dormitory.common.utils.SessionUtil;
import com.huuc.dormitory.dto.LateReturnDTO;
import com.huuc.dormitory.entity.DormLateReturn;
import com.huuc.dormitory.service.BuildingService;
import com.huuc.dormitory.service.LateReturnService;
import com.huuc.dormitory.vo.BuildingVO;
import com.huuc.dormitory.vo.LateReturnStatVO;
import com.huuc.dormitory.vo.LateReturnVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.util.List;

/**
 * 宿管端晚归登记控制器
 */
@Controller
@RequestMapping("/dorm/late-return")
public class DormLateReturnController {

    @Autowired
    private LateReturnService lateReturnService;

    @Autowired
    private BuildingService buildingService;

    /**
     * 晚归记录列表页面
     */
    @GetMapping("/list")
    public String listPage() {
        return "dorm/lateReturn/list";
    }

    /**
     * 录入晚归页面
     */
    @GetMapping("/addPage")
    public String addPage() {
        return "dorm/lateReturn/add";
    }

    /**
     * 晚归统计页面
     */
    @GetMapping("/statsPage")
    public String statsPage() {
        return "dorm/lateReturn/stats";
    }

    /**
     * 查询本楼栋晚归记录（分页）
     */
    @GetMapping("/page")
    @ResponseBody
    public Result<PageInfo<LateReturnVO>> getRecordPage(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            HttpSession session) {

        // 从Session获取宿管负责的楼栋，禁止前端传入buildingId防止越权
        Long managerId = SessionUtil.getCurrentUserId(session);
        List<BuildingVO> buildings = buildingService.getBuildingsByManagerId(managerId);
        if (buildings.isEmpty()) {
            return Result.fail("您暂未负责任何楼栋，请联系管理员");
        }
        Long buildingId = buildings.get(0).getBuildingId();

        PageHelper.startPage(pageNum, pageSize);
        PageInfo<LateReturnVO> pageInfo = lateReturnService.getRecordsByBuildingId(buildingId, pageNum, pageSize);

        return Result.success(pageInfo);
    }

    /**
     * 本楼栋月度晚归统计
     */
    @GetMapping("/stats")
    @ResponseBody
    public Result<List<LateReturnStatVO>> getMonthlyStats(
            @RequestParam(required = false) String yearMonth,
            HttpSession session) {
        Long managerId = SessionUtil.getCurrentUserId(session);
        List<LateReturnStatVO> stats = lateReturnService.getMonthlyStats(managerId, yearMonth);
        return Result.success(stats);
    }

    /**
     * 录入晚归记录
     */
    @PostMapping("/add")
    @ResponseBody
    @OperLog(module = "晚归登记", type = OperTypeEnum.ADD, desc = "录入晚归记录")
    public Result<Void> addRecord(@RequestBody @Valid LateReturnDTO dto, HttpSession session) {
        Long registrarId = SessionUtil.getCurrentUserId(session);
        lateReturnService.addRecord(dto, registrarId);
        return Result.success();
    }
}
