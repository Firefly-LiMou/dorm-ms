package com.huuc.dormitory.service;

import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.dto.RepairDTO;
import com.huuc.dormitory.dto.RepairHandleDTO;
import com.huuc.dormitory.entity.DormRepair;
import com.huuc.dormitory.vo.RepairVO;

/**
 * 报修服务接口
 */
public interface RepairService {

    /**
     * 根据ID获取报修详情
     */
    RepairVO getRepairById(Long repairId);

    /**
     * 分页查询报修列表
     */
    PageInfo<RepairVO> getRepairList(DormRepair query, Integer pageNum, Integer pageSize);

    /**
     * 分页查询我的报修
     */
    PageInfo<RepairVO> getMyRepairs(Long studentId, Integer pageNum, Integer pageSize);

    /**
     * 分页查询楼栋报修
     */
    PageInfo<RepairVO> getRepairsByBuildingId(Long buildingId, Integer pageNum, Integer pageSize);

    /**
     * 提交报修
     */
    void submitRepair(RepairDTO dto, Long studentId);

    /**
     * 接单处理
     */
    void handleRepair(Long repairId, Long handlerId);

    /**
     * 完结报修
     */
    void completeRepair(Long repairId, RepairHandleDTO dto, Long handlerId);
}
