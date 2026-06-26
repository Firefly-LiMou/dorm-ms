package com.huuc.dormitory.service;

import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.dto.BuildingDTO;
import com.huuc.dormitory.entity.DormBuilding;
import com.huuc.dormitory.vo.BuildingVO;

import java.util.List;

/**
 * 楼栋服务接口
 */
public interface BuildingService {

    /**
     * 根据ID获取楼栋详情
     */
    BuildingVO getBuildingById(Long buildingId);

    /**
     * 分页查询楼栋列表
     */
    PageInfo<BuildingVO> getBuildingList(DormBuilding query, Integer pageNum, Integer pageSize);

    /**
     * 根据宿管ID获取楼栋列表
     */
    List<BuildingVO> getBuildingsByManagerId(Long managerId);

    /**
     * 新增楼栋
     */
    void addBuilding(BuildingDTO dto, Long operatorId);

    /**
     * 编辑楼栋
     */
    void updateBuilding(BuildingDTO dto, Long operatorId);

    /**
     * 删除楼栋
     */
    void deleteBuilding(Long buildingId, Long operatorId);
}
