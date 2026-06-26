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
     */
    void addBed(BedDTO dto, Long operatorId);

    /**
     * 批量初始化床位
     */
    void batchAddBeds(BatchBedDTO dto, Long operatorId);

    /**
     * 修改床位状态
     */
    void updateBedStatus(Long bedId, Integer status);
}
