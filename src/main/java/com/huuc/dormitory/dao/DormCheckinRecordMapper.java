package com.huuc.dormitory.dao;

import com.huuc.dormitory.entity.DormCheckinRecord;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 入住记录Mapper接口
 */
public interface DormCheckinRecordMapper {

    /**
     * 根据ID查询入住记录
     */
    DormCheckinRecord selectById(Long checkinId);

    /**
     * 查询学生在住记录
     */
    DormCheckinRecord selectActiveByStudentId(Long studentId);

    /**
     * 查询入住记录列表
     */
    List<DormCheckinRecord> selectList(DormCheckinRecord query);

    /**
     * 根据楼栋ID查询入住记录
     */
    List<DormCheckinRecord> selectByBuildingId(Long buildingId);

    /**
     * 插入入住记录
     */
    int insert(DormCheckinRecord record);

    /**
     * 更新入住记录
     */
    int update(DormCheckinRecord record);

    /**
     * 统计学生在住记录数
     */
    int countActiveByStudentId(Long studentId);

    /**
     * 统计床位在住记录数
     */
    int countActiveByBedId(Long bedId);

    /**
     * 查询房间在住记录列表（排除指定学生）
     */
    List<DormCheckinRecord> selectActiveByRoomId(@Param("roomId") Long roomId, @Param("excludeStudentId") Long excludeStudentId);

    /**
     * 按学号模糊查询入住记录列表
     */
    List<DormCheckinRecord> selectListByStudentNo(@Param("studentNo") String studentNo, @Param("checkinStatus") Integer checkinStatus);
}
