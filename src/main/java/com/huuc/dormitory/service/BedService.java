package com.huuc.dormitory.service;

import com.huuc.dormitory.dto.BedDTO;
import com.huuc.dormitory.dto.BatchBedDTO;
import com.huuc.dormitory.vo.BedVO;

import java.util.List;

/**
 * 床位服务接口
 */
public interface BedService {

    /**
     * 根据ID获取床位详情
     */
    BedVO getBedById(Long bedId);

    /**
     * 根据房间ID获取床位列表
     */
    List<BedVO> getBedsByRoomId(Long roomId);

    /**
     * 根据房间ID获取空闲床位列表
     */
    List<BedVO> getFreeBedsByRoomId(Long roomId);

    /**
     * 新增床位
     *
     * @param dto        床位信息
     * @param operatorId 操作人ID
     * @throws com.huuc.dormitory.common.exception.BusinessException 房间不存在
     */
    void addBed(BedDTO dto, Long operatorId);

    /**
     * 批量初始化床位（自动生成N号床）
     *
     * @param dto        批量参数（房间ID、床位数量）
     * @param operatorId 操作人ID
     * @throws com.huuc.dormitory.common.exception.BusinessException 房间不存在、床位数量必须大于0
     */
    void batchAddBeds(BatchBedDTO dto, Long operatorId);

    /**
     * 修改床位状态
     *
     * @param bedId  床位ID
     * @param status 目标状态（0空闲/1已入住/2维修禁用）
     * @throws com.huuc.dormitory.common.exception.BusinessException 床位不存在、状态值无效
     */
    void updateBedStatus(Long bedId, Integer status);
}
