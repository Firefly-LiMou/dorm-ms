package com.huuc.dormitory.service;

import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.dto.RoomDTO;
import com.huuc.dormitory.entity.DormRoom;
import com.huuc.dormitory.vo.RoomVO;

import java.util.List;

/**
 * 房间服务接口
 */
public interface RoomService {

    /**
     * 根据ID获取房间详情
     */
    RoomVO getRoomById(Long roomId);

    /**
     * 分页查询房间列表
     */
    PageInfo<RoomVO> getRoomList(DormRoom query, Integer pageNum, Integer pageSize);

    /**
     * 根据楼栋ID获取房间列表
     */
    List<RoomVO> getRoomsByBuildingId(Long buildingId);

    /**
     * 新增房间
     */
    void addRoom(RoomDTO dto, Long operatorId);

    /**
     * 编辑房间
     */
    void updateRoom(RoomDTO dto, Long operatorId);

    /**
     * 删除房间
     */
    void deleteRoom(Long roomId, Long operatorId);
}
