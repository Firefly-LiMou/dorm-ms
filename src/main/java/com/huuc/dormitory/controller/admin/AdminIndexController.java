package com.huuc.dormitory.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 管理员首页控制器
 */
@Controller
@RequestMapping("/admin")
public class AdminIndexController {

    /**
     * 管理员首页
     * @return 首页视图
     */
    @GetMapping("/index")
    public String index() {
        return "admin/index";
    }
}
