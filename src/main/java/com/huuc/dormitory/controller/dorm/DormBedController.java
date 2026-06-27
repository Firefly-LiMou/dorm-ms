package com.huuc.dormitory.controller.dorm;

import com.huuc.dormitory.common.result.Result;
import com.huuc.dormitory.service.BedService;
import com.huuc.dormitory.vo.BedVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * 宿管端床位控制器
 */
@Controller
@RequestMapping("/dorm/bed")
public class DormBedController {

    @Autowired
    private BedService bedService;

    /**
     * 床位列表页面
     * @return 列表页视图
     */
    @GetMapping("/listPage")
    public String listPage() {
        return "dorm/bed/list";
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
}
