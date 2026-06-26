package com.huuc.dormitory.controller.dorm;

import com.huuc.dormitory.common.result.Result;
import com.huuc.dormitory.service.RoomService;
import com.huuc.dormitory.vo.RoomVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * 宿管端房间控制器
 */
@Controller
@RequestMapping("/dorm/room")
public class DormRoomController {

    @Autowired
    private RoomService roomService;

    /**
     * 获取楼栋下房间列表
     */
    @GetMapping("/building/{buildingId}")
    @ResponseBody
    public Result<List<RoomVO>> getRoomsByBuildingId(@PathVariable Long buildingId) {
        List<RoomVO> list = roomService.getRoomsByBuildingId(buildingId);
        return Result.success(list);
    }
}
