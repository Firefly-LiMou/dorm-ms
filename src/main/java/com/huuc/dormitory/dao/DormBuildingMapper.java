package com.huuc.dormitory.dao;

import com.huuc.dormitory.entity.DormBuilding;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 楼栋Mapper接口
 */
public interface DormBuildingMapper {

    /**
     * 根据ID查询楼栋
     */
    DormBuilding selectById(Long buildingId);

    /**
     * 查询楼栋列表
     */
    List<DormBuilding> selectList(DormBuilding query);

    /**
     * 根据宿管ID查询楼栋列表
     */
    List<DormBuilding> selectByManagerId(Long managerId);

    /**
     * 插入楼栋
     */
    int insert(DormBuilding building);

    /**
     * 更新楼栋
     */
    int update(DormBuilding building);

    /**
     * 逻辑删除楼栋
     */
    int updateDeleted(@Param("buildingId") Long buildingId, @Param("isDeleted") Integer isDeleted);

    /**
     * 统计楼栋下房间数
     */
    int countRooms(Long buildingId);
}
