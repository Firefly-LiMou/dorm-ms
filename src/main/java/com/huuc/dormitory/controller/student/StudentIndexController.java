package com.huuc.dormitory.controller.student;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 学生首页控制器
 */
@Controller
@RequestMapping("/student")
public class StudentIndexController {

    /**
     * 学生首页
     * @return 首页视图
     */
    @GetMapping("/index")
    public String index() {
        return "student/index";
    }
}
