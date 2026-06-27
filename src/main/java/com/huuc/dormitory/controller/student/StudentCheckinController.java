package com.huuc.dormitory.controller.student;

import com.huuc.dormitory.common.result.Result;
import com.huuc.dormitory.common.utils.SessionUtil;
import com.huuc.dormitory.service.CheckinService;
import com.huuc.dormitory.vo.CheckinVO;
import com.huuc.dormitory.vo.RoommateVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * 学生端入住信息控制器
 */
@Controller
@RequestMapping("/student/checkin")
public class StudentCheckinController {

    @Autowired
    private CheckinService checkinService;

    /**
     * 住宿信息页面
     * @return 信息页视图
     */
    @GetMapping("/infoPage")
    public String infoPage() {
        return "student/checkin/info";
    }

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

    /**
     * 查看舍友信息（同房间在住学生）
     *
     * @return 舍友列表，若未入住则返回空列表
     */
    @GetMapping("/roommates")
    @ResponseBody
    public Result<List<RoommateVO>> getRoommates(HttpSession session) {
        Long studentId = SessionUtil.getCurrentUserId(session);
        List<RoommateVO> roommates = checkinService.getRoommatesByStudentId(studentId);
        return Result.success(roommates);
    }
}
