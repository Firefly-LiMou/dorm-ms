package com.huuc.dormitory.controller.dorm;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.common.aop.OperLog;
import com.huuc.dormitory.common.enums.OperTypeEnum;
import com.huuc.dormitory.common.result.Result;
import com.huuc.dormitory.common.utils.SessionUtil;
import com.huuc.dormitory.dto.VisitorDTO;
import com.huuc.dormitory.entity.DormVisitor;
import com.huuc.dormitory.service.BuildingService;
import com.huuc.dormitory.service.VisitorService;
import com.huuc.dormitory.vo.BuildingVO;
import com.huuc.dormitory.vo.VisitorVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.util.List;

/**
 * 宿管端访客登记控制器
 */
@Controller
@RequestMapping("/dorm/visitor")
public class DormVisitorController {

    @Autowired
    private VisitorService visitorService;

    @Autowired
    private BuildingService buildingService;

    /**
     * 访客记录列表页面
     */
    @GetMapping("/list")
    public String listPage() {
        return "dorm/visitor/list";
    }

    /**
     * 访客详情页面
     */
    @GetMapping("/detailPage")
    public String detailPage() {
        return "dorm/visitor/detail";
    }

    /**
     * 录入访客页面
     */
    @GetMapping("/addPage")
    public String addPage() {
        return "dorm/visitor/add";
    }

    /**
     * 查询本楼栋访客记录（分页）
     */
    @GetMapping("/page")
    @ResponseBody
    public Result<PageInfo<VisitorVO>> getVisitorPage(
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
        PageInfo<VisitorVO> pageInfo = visitorService.getVisitorsByBuildingId(buildingId, pageNum, pageSize);

        return Result.success(pageInfo);
    }

    /**
     * 获取访客详情
     */
    @GetMapping("/{visitorId}")
    @ResponseBody
    public Result<VisitorVO> getVisitorById(@PathVariable Long visitorId) {
        VisitorVO vo = visitorService.getVisitorById(visitorId);
        return Result.success(vo);
    }

    /**
     * 录入访客
     */
    @PostMapping("/add")
    @ResponseBody
    @OperLog(module = "访客登记", type = OperTypeEnum.ADD, desc = "录入访客")
    public Result<Void> addVisitor(@RequestBody @Valid VisitorDTO dto, HttpSession session) {
        Long registrarId = SessionUtil.getCurrentUserId(session);
        visitorService.addVisitor(dto, registrarId);
        return Result.success();
    }

    /**
     * 确认离开
     */
    @PostMapping("/leave/{visitorId}")
    @ResponseBody
    @OperLog(module = "访客登记", type = OperTypeEnum.UPDATE, desc = "确认离开")
    public Result<Void> confirmLeave(@PathVariable Long visitorId) {
        visitorService.confirmLeave(visitorId);
        return Result.success();
    }
}
