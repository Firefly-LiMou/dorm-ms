package com.huuc.dormitory.controller.dorm;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 宿管首页控制器
 */
@Controller
@RequestMapping("/dorm")
public class DormIndexController {

    /**
     * 宿管首页
     * @return 首页视图
     */
    @GetMapping("/index")
    public String index() {
        return "dorm/index";
    }
}
