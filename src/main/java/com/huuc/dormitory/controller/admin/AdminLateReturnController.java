package com.huuc.dormitory.controller.admin;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.common.aop.OperLog;
import com.huuc.dormitory.common.enums.OperTypeEnum;
import com.huuc.dormitory.common.result.Result;
import com.huuc.dormitory.common.utils.SessionUtil;
import com.huuc.dormitory.dto.LateReturnDTO;
import com.huuc.dormitory.entity.DormLateReturn;
import com.huuc.dormitory.service.LateReturnService;
import com.huuc.dormitory.vo.LateReturnStatVO;
import com.huuc.dormitory.vo.LateReturnVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.util.List;

/**
 * 管理员端晚归登记控制器
 */
@Controller
@RequestMapping("/admin/late-return")
public class AdminLateReturnController {

    @Autowired
    private LateReturnService lateReturnService;

    /**
     * 晚归记录列表页面
     */
    @GetMapping("/list")
    public String listPage() {
        return "admin/lateReturn/list";
    }

    /**
     * 录入晚归页面
     */
    @GetMapping("/addPage")
    public String addPage() {
        return "admin/lateReturn/add";
    }

    /**
     * 晚归统计页面
     */
    @GetMapping("/statsPage")
    public String statsPage() {
        return "admin/lateReturn/stats";
    }

    /**
     * 查询晚归记录列表（分页）
     */
    @GetMapping("/page")
    @ResponseBody
    public Result<PageInfo<LateReturnVO>> getRecordPage(
            @RequestParam(required = false) Long studentId,
            @RequestParam(required = false) Long buildingId,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {

        DormLateReturn query = new DormLateReturn();
        query.setStudentId(studentId);
        query.setBuildingId(buildingId);

        PageHelper.startPage(pageNum, pageSize);
        PageInfo<LateReturnVO> pageInfo = lateReturnService.getRecordList(query, pageNum, pageSize);

        return Result.success(pageInfo);
    }

    /**
     * 月度晚归统计
     */
    @GetMapping("/stats")
    @ResponseBody
    public Result<List<LateReturnStatVO>> getMonthlyStats(
            @RequestParam(required = false) String yearMonth) {
        // 管理员可查看所有楼栋统计，传入null
        List<LateReturnStatVO> stats = lateReturnService.getMonthlyStats(null, yearMonth);
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
