package com.huuc.dormitory.controller.student;

import com.huuc.dormitory.common.aop.OperLog;
import com.huuc.dormitory.common.enums.OperTypeEnum;
import com.huuc.dormitory.common.result.Result;
import com.huuc.dormitory.common.utils.SessionUtil;
import com.huuc.dormitory.dto.PasswordDTO;
import com.huuc.dormitory.entity.SysUser;
import com.huuc.dormitory.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

/**
 * 学生端个人信息控制器
 */
@Controller
@RequestMapping("/student/user")
public class StudentUserController {

    @Autowired
    private UserService userService;

    /**
     * 个人信息页面
     */
    @GetMapping("/info")
    public String infoPage() {
        return "student/user/info";
    }

    /**
     * 获取个人信息
     */
    @GetMapping("/getInfo")
    @ResponseBody
    public Result<SysUser> getInfo(HttpSession session) {
        Long userId = SessionUtil.getCurrentUserId(session);
        SysUser user = userService.getUserById(userId);
        return Result.success(user);
    }

    /**
     * 修改联系电话
     */
    @PostMapping("/updatePhone")
    @ResponseBody
    @OperLog(module = "个人信息", type = OperTypeEnum.UPDATE, desc = "修改联系电话")
    public Result<Void> updatePhone(@RequestParam String phone, HttpSession session) {
        Long userId = SessionUtil.getCurrentUserId(session);
        userService.updatePhone(phone, userId);
        return Result.success();
    }
}
