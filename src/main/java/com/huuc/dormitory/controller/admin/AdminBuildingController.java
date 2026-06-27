package com.huuc.dormitory.controller.admin;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.common.aop.OperLog;
import com.huuc.dormitory.common.enums.OperTypeEnum;
import com.huuc.dormitory.common.result.Result;
import com.huuc.dormitory.common.utils.SessionUtil;
import com.huuc.dormitory.dto.BuildingDTO;
import com.huuc.dormitory.entity.DormBuilding;
import com.huuc.dormitory.service.BuildingService;
import com.huuc.dormitory.vo.BuildingVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.util.List;

/**
 * 管理员端楼栋管理控制器
 */
@Controller
@RequestMapping("/admin/building")
public class AdminBuildingController {

    @Autowired
    private BuildingService buildingService;

    /**
     * 楼栋列表页面
     */
    @GetMapping("/list")
    public String listPage() {
        return "admin/building/list";
    }

    /**
     * 新增楼栋页面
     */
    @GetMapping("/addPage")
    public String addPage() {
        return "admin/building/add";
    }

    /**
     * 编辑楼栋页面
     */
    @GetMapping("/editPage")
    public String editPage() {
        return "admin/building/edit";
    }

    /**
     * 查询楼栋列表（分页）
     */
    @GetMapping("/page")
    @ResponseBody
    public Result<PageInfo<BuildingVO>> getBuildingPage(
            @RequestParam(required = false) String buildingNo,
            @RequestParam(required = false) String buildingName,
            @RequestParam(required = false) String area,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {

        DormBuilding query = new DormBuilding();
        query.setBuildingNo(buildingNo);
        query.setBuildingName(buildingName);
        query.setArea(area);

        PageHelper.startPage(pageNum, pageSize);
        PageInfo<BuildingVO> pageInfo = buildingService.getBuildingList(query, pageNum, pageSize);

        return Result.success(pageInfo);
    }

    /**
     * 获取楼栋详情
     */
    @GetMapping("/{buildingId}")
    @ResponseBody
    public Result<BuildingVO> getBuildingById(@PathVariable Long buildingId) {
        BuildingVO vo = buildingService.getBuildingById(buildingId);
        return Result.success(vo);
    }

    /**
     * 新增楼栋
     */
    @PostMapping("/add")
    @ResponseBody
    @OperLog(module = "楼栋管理", type = OperTypeEnum.ADD, desc = "新增楼栋")
    public Result<Void> addBuilding(@RequestBody @Valid BuildingDTO dto, HttpSession session) {
        Long operatorId = SessionUtil.getCurrentUserId(session);
        buildingService.addBuilding(dto, operatorId);
        return Result.success();
    }

    /**
     * 编辑楼栋
     */
    @PostMapping("/update")
    @ResponseBody
    @OperLog(module = "楼栋管理", type = OperTypeEnum.UPDATE, desc = "编辑楼栋")
    public Result<Void> updateBuilding(@RequestBody @Valid BuildingDTO dto, HttpSession session) {
        Long operatorId = SessionUtil.getCurrentUserId(session);
        buildingService.updateBuilding(dto, operatorId);
        return Result.success();
    }

    /**
     * 删除楼栋
     */
    @PostMapping("/delete/{buildingId}")
    @ResponseBody
    @OperLog(module = "楼栋管理", type = OperTypeEnum.DELETE, desc = "删除楼栋")
    public Result<Void> deleteBuilding(@PathVariable Long buildingId, HttpSession session) {
        Long operatorId = SessionUtil.getCurrentUserId(session);
        buildingService.deleteBuilding(buildingId, operatorId);
        return Result.success();
    }
}
