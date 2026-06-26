package com.huuc.dormitory.service;

import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.dto.LateReturnDTO;
import com.huuc.dormitory.entity.DormLateReturn;
import com.huuc.dormitory.vo.LateReturnStatVO;
import com.huuc.dormitory.vo.LateReturnVO;

import java.util.List;

/**
 * 晚归服务接口
 */
public interface LateReturnService {

    /**
     * 根据ID获取晚归记录详情
     */
    LateReturnVO getRecordById(Long recordId);

    /**
     * 分页查询晚归记录列表
     */
    PageInfo<LateReturnVO> getRecordList(DormLateReturn query, Integer pageNum, Integer pageSize);

    /**
     * 分页查询我的晚归记录
     */
    PageInfo<LateReturnVO> getMyRecords(Long studentId, Integer pageNum, Integer pageSize);

    /**
     * 分页查询楼栋晚归记录
     */
    PageInfo<LateReturnVO> getRecordsByBuildingId(Long buildingId, Integer pageNum, Integer pageSize);

    /**
     * 录入晚归记录
     */
    void addRecord(LateReturnDTO dto, Long registrarId);

    /**
     * 月度晚归统计
     */
    List<LateReturnStatVO> getMonthlyStats(Long managerId, String yearMonth);
}
