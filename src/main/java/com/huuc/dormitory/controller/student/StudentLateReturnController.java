package com.huuc.dormitory.controller.student;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.common.result.Result;
import com.huuc.dormitory.common.utils.SessionUtil;
import com.huuc.dormitory.service.LateReturnService;
import com.huuc.dormitory.vo.LateReturnVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;

/**
 * 学生端晚归记录控制器
 */
@Controller
@RequestMapping("/student/late-return")
public class StudentLateReturnController {

    @Autowired
    private LateReturnService lateReturnService;

    /**
     * 我的晚归记录列表页面
     */
    @GetMapping("/list")
    public String listPage() {
        return "student/lateReturn/list";
    }

    /**
     * 查询我的晚归记录（分页）
     */
    @GetMapping("/page")
    @ResponseBody
    public Result<PageInfo<LateReturnVO>> getMyRecordPage(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            HttpSession session) {

        Long studentId = SessionUtil.getCurrentUserId(session);
        PageHelper.startPage(pageNum, pageSize);
        PageInfo<LateReturnVO> pageInfo = lateReturnService.getMyRecords(studentId, pageNum, pageSize);

        return Result.success(pageInfo);
    }
}
