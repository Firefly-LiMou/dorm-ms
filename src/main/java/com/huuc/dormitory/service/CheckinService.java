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
     * 事务操作：插入入住记录 + 更新床位状态为已入住
     *
     * @param dto        入住参数（学生ID、床位ID）
     * @param operatorId 操作人ID
     * @throws com.huuc.dormitory.common.exception.BusinessException 学生不存在、学生状态异常、已有在住记录、床位已占用
     */
    void checkin(CheckinDTO dto, Long operatorId);

    /**
     * 办理退宿
     * 事务操作：更新入住记录状态为已退宿 + 释放床位为空闲
     *
     * @param checkinId  入住记录ID
     * @param operatorId 操作人ID
     * @throws com.huuc.dormitory.common.exception.BusinessException 入住记录不存在、记录状态异常
     */
    void checkout(Long checkinId, Long operatorId);
}
