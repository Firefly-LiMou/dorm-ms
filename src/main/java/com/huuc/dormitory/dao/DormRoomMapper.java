package com.huuc.dormitory.dao;

import com.huuc.dormitory.entity.DormRoom;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 房间Mapper接口
 */
public interface DormRoomMapper {

    /**
     * 根据ID查询房间
     */
    DormRoom selectById(Long roomId);

    /**
     * 根据楼栋ID查询房间列表
     */
    List<DormRoom> selectByBuildingId(Long buildingId);

    /**
     * 查询房间列表
     */
    List<DormRoom> selectList(DormRoom query);

    /**
     * 插入房间
     */
    int insert(DormRoom room);

    /**
     * 更新房间
     */
    int update(DormRoom room);

    /**
     * 逻辑删除房间
     */
    int updateDeleted(@Param("roomId") Long roomId, @Param("isDeleted") Integer isDeleted);

    /**
     * 统计房间下床位数
     */
    int countBeds(Long roomId);

    /**
     * 根据楼栋ID和房间号查询房间
     */
    DormRoom selectByBuildingIdAndRoomNo(@Param("buildingId") Long buildingId, @Param("roomNo") String roomNo);
}
