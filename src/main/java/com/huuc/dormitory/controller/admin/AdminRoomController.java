package com.huuc.dormitory.controller.admin;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.common.aop.OperLog;
import com.huuc.dormitory.common.enums.OperTypeEnum;
import com.huuc.dormitory.common.result.Result;
import com.huuc.dormitory.common.utils.SessionUtil;
import com.huuc.dormitory.dto.RoomDTO;
import com.huuc.dormitory.entity.DormRoom;
import com.huuc.dormitory.service.RoomService;
import com.huuc.dormitory.vo.RoomVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.util.List;

/**
 * 管理员端房间管理控制器
 */
@Controller
@RequestMapping("/admin/room")
public class AdminRoomController {

    @Autowired
    private RoomService roomService;

    /**
     * 房间列表页面
     */
    @GetMapping("/list")
    public String listPage() {
        return "admin/room/list";
    }

    /**
     * 查询房间列表（分页）
     */
    @GetMapping("/page")
    @ResponseBody
    public Result<PageInfo<RoomVO>> getRoomPage(
            @RequestParam(required = false) Long buildingId,
            @RequestParam(required = false) String roomNo,
            @RequestParam(required = false) Integer floorNum,
            @RequestParam(required = false) Integer roomType,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {

        DormRoom query = new DormRoom();
        query.setBuildingId(buildingId);
        query.setRoomNo(roomNo);
        query.setFloorNum(floorNum);
        query.setRoomType(roomType);

        PageHelper.startPage(pageNum, pageSize);
        PageInfo<RoomVO> pageInfo = roomService.getRoomList(query, pageNum, pageSize);

        return Result.success(pageInfo);
    }

    /**
     * 获取楼栋下房间列表
     */
    @GetMapping("/building/{buildingId}")
    @ResponseBody
    public Result<List<RoomVO>> getRoomsByBuildingId(@PathVariable Long buildingId) {
        List<RoomVO> list = roomService.getRoomsByBuildingId(buildingId);
        return Result.success(list);
    }

    /**
     * 获取房间详情
     */
    @GetMapping("/{roomId}")
    @ResponseBody
    public Result<RoomVO> getRoomById(@PathVariable Long roomId) {
        RoomVO vo = roomService.getRoomById(roomId);
        return Result.success(vo);
    }

    /**
     * 新增房间
     */
    @PostMapping("/add")
    @ResponseBody
    @OperLog(module = "房间管理", type = OperTypeEnum.ADD, desc = "新增房间")
    public Result<Void> addRoom(@RequestBody @Valid RoomDTO dto, HttpSession session) {
        Long operatorId = SessionUtil.getCurrentUserId(session);
        roomService.addRoom(dto, operatorId);
        return Result.success();
    }

    /**
     * 编辑房间
     */
    @PostMapping("/update")
    @ResponseBody
    @OperLog(module = "房间管理", type = OperTypeEnum.UPDATE, desc = "编辑房间")
    public Result<Void> updateRoom(@RequestBody @Valid RoomDTO dto, HttpSession session) {
        Long operatorId = SessionUtil.getCurrentUserId(session);
        roomService.updateRoom(dto, operatorId);
        return Result.success();
    }

    /**
     * 删除房间
     */
    @PostMapping("/delete/{roomId}")
    @ResponseBody
    @OperLog(module = "房间管理", type = OperTypeEnum.DELETE, desc = "删除房间")
    public Result<Void> deleteRoom(@PathVariable Long roomId, HttpSession session) {
        Long operatorId = SessionUtil.getCurrentUserId(session);
        roomService.deleteRoom(roomId, operatorId);
        return Result.success();
    }
}
