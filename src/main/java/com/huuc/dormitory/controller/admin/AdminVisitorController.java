package com.huuc.dormitory.controller.admin;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.common.aop.OperLog;
import com.huuc.dormitory.common.enums.OperTypeEnum;
import com.huuc.dormitory.common.result.Result;
import com.huuc.dormitory.common.utils.SessionUtil;
import com.huuc.dormitory.dto.VisitorDTO;
import com.huuc.dormitory.entity.DormVisitor;
import com.huuc.dormitory.service.VisitorService;
import com.huuc.dormitory.vo.VisitorVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

/**
 * 管理员端访客登记控制器
 */
@Controller
@RequestMapping("/admin/visitor")
public class AdminVisitorController {

    @Autowired
    private VisitorService visitorService;

    /**
     * 访客记录列表页面
     */
    @GetMapping("/list")
    public String listPage() {
        return "admin/visitor/list";
    }

    /**
     * 访客详情页面
     */
    @GetMapping("/detailPage")
    public String detailPage() {
        return "admin/visitor/detail";
    }

    /**
     * 录入访客页面
     */
    @GetMapping("/addPage")
    public String addPage() {
        return "admin/visitor/add";
    }

    /**
     * 查询访客记录列表（分页）
     */
    @GetMapping("/page")
    @ResponseBody
    public Result<PageInfo<VisitorVO>> getVisitorPage(
            @RequestParam(required = false) Long studentId,
            @RequestParam(required = false) Long buildingId,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {

        DormVisitor query = new DormVisitor();
        query.setStudentId(studentId);
        query.setBuildingId(buildingId);

        PageHelper.startPage(pageNum, pageSize);
        PageInfo<VisitorVO> pageInfo = visitorService.getVisitorList(query, pageNum, pageSize);

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
    public Result<Void> confirmLeave(@PathVariable Long visitorId, HttpSession session) {
        visitorService.confirmLeave(visitorId);
        return Result.success();
    }
}
