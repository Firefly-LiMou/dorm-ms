package com.huuc.dormitory.controller.admin;

import com.huuc.dormitory.common.aop.OperLog;
import com.huuc.dormitory.common.enums.OperTypeEnum;
import com.huuc.dormitory.common.result.Result;
import com.huuc.dormitory.common.utils.SessionUtil;
import com.huuc.dormitory.dto.BedDTO;
import com.huuc.dormitory.dto.BatchBedDTO;
import com.huuc.dormitory.service.BedService;
import com.huuc.dormitory.vo.BedVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.util.List;

/**
 * 管理员端床位管理控制器
 */
@Controller
@RequestMapping("/admin/bed")
public class AdminBedController {

    @Autowired
    private BedService bedService;

    /**
     * 床位列表页面
     * @return 列表页视图
     */
    @GetMapping("/list")
    public String listPage() {
        return "admin/bed/list";
    }

    /**
     * 获取房间下床位列表
     */
    @GetMapping("/room/{roomId}")
    @ResponseBody
    public Result<List<BedVO>> getBedsByRoomId(@PathVariable Long roomId) {
        List<BedVO> list = bedService.getBedsByRoomId(roomId);
        return Result.success(list);
    }

    /**
     * 获取房间下空闲床位列表
     */
    @GetMapping("/free/{roomId}")
    @ResponseBody
    public Result<List<BedVO>> getFreeBedsByRoomId(@PathVariable Long roomId) {
        List<BedVO> list = bedService.getFreeBedsByRoomId(roomId);
        return Result.success(list);
    }

    /**
     * 获取床位详情
     */
    @GetMapping("/{bedId}")
    @ResponseBody
    public Result<BedVO> getBedById(@PathVariable Long bedId) {
        BedVO vo = bedService.getBedById(bedId);
        return Result.success(vo);
    }

    /**
     * 新增床位
     */
    @PostMapping("/add")
    @ResponseBody
    @OperLog(module = "床位管理", type = OperTypeEnum.ADD, desc = "新增床位")
    public Result<Void> addBed(@RequestBody @Valid BedDTO dto, HttpSession session) {
        Long operatorId = SessionUtil.getCurrentUserId(session);
        bedService.addBed(dto, operatorId);
        return Result.success();
    }

    /**
     * 批量初始化床位
     */
    @PostMapping("/batch")
    @ResponseBody
    @OperLog(module = "床位管理", type = OperTypeEnum.ADD, desc = "批量初始化床位")
    public Result<Void> batchAddBeds(@RequestBody @Valid BatchBedDTO dto, HttpSession session) {
        Long operatorId = SessionUtil.getCurrentUserId(session);
        bedService.batchAddBeds(dto, operatorId);
        return Result.success();
    }

    /**
     * 修改床位状态
     */
    @PostMapping("/status/{bedId}")
    @ResponseBody
    @OperLog(module = "床位管理", type = OperTypeEnum.UPDATE, desc = "修改床位状态")
    public Result<Void> updateBedStatus(@PathVariable Long bedId, @RequestParam Integer status, HttpSession session) {
        bedService.updateBedStatus(bedId, status);
        return Result.success();
    }
}
