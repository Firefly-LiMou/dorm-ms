package com.huuc.dormitory.controller.student;

import com.huuc.dormitory.common.result.Result;
import com.huuc.dormitory.common.utils.SessionUtil;
import com.huuc.dormitory.service.CheckinService;
import com.huuc.dormitory.vo.CheckinVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;

/**
 * 学生端入住信息控制器
 */
@Controller
@RequestMapping("/student/checkin")
public class StudentCheckinController {

    @Autowired
    private CheckinService checkinService;

    /**
     * 查看本人住宿信息
     */
    @GetMapping("/info")
    @ResponseBody
    public Result<CheckinVO> getMyCheckin(HttpSession session) {
        Long studentId = SessionUtil.getCurrentUserId(session);
        CheckinVO vo = checkinService.getCheckinByStudentId(studentId);
        return Result.success(vo);
    }
}
