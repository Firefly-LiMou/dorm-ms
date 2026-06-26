package com.huuc.dormitory.dao;

import com.huuc.dormitory.entity.DormVisitor;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 访客Mapper接口
 */
public interface DormVisitorMapper {

    /**
     * 根据ID查询访客
     */
    DormVisitor selectById(Long visitorId);

    /**
     * 查询访客列表
     */
    List<DormVisitor> selectList(DormVisitor query);

    /**
     * 根据楼栋ID查询访客列表
     */
    List<DormVisitor> selectByBuildingId(Long buildingId);

    /**
     * 插入访客
     */
    int insert(DormVisitor visitor);

    /**
     * 更新离开时间
     */
    int updateLeaveTime(@Param("visitorId") Long visitorId, @Param("leaveTime") LocalDateTime leaveTime);
}
