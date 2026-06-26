package com.huuc.dormitory.dao;

import com.huuc.dormitory.entity.DormBed;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 床位Mapper接口
 */
public interface DormBedMapper {

    /**
     * 根据ID查询床位
     */
    DormBed selectById(Long bedId);

    /**
     * 根据房间ID查询床位列表
     */
    List<DormBed> selectByRoomId(Long roomId);

    /**
     * 根据房间ID查询空闲床位列表
     */
    List<DormBed> selectFreeByRoomId(Long roomId);

    /**
     * 插入床位
     */
    int insert(DormBed bed);

    /**
     * 批量插入床位
     */
    int batchInsert(List<DormBed> beds);

    /**
     * 更新床位状态
     */
    int updateStatus(@Param("bedId") Long bedId, @Param("status") Integer status);

    /**
     * 逻辑删除床位
     */
    int updateDeleted(@Param("bedId") Long bedId, @Param("isDeleted") Integer isDeleted);

    /**
     * 统计房间下未删除的床位数
     */
    int countByRoomId(Long roomId);
}
