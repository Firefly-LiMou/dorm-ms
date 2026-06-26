package com.huuc.dormitory.service;

import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.dto.CheckinDTO;
import com.huuc.dormitory.entity.DormCheckinRecord;
import com.huuc.dormitory.vo.CheckinVO;

/**
 * 入住服务接口
 */
public interface CheckinService {

    /**
     * 根据学生ID获取在住记录
     */
    CheckinVO getCheckinByStudentId(Long studentId);

    /**
     * 分页查询入住记录
     */
    PageInfo<CheckinVO> getCheckinList(DormCheckinRecord query, Integer pageNum, Integer pageSize);

    /**
     * 根据楼栋ID分页查询入住记录
     */
    PageInfo<CheckinVO> getCheckinListByBuildingId(Long buildingId, Integer pageNum, Integer pageSize);

    /**
     * 办理入住
     */
    void checkin(CheckinDTO dto, Long operatorId);

    /**
     * 办理退宿
     */
    void checkout(Long checkinId, Long operatorId);
}
