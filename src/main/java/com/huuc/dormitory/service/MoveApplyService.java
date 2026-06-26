package com.huuc.dormitory.service;

import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.dto.MoveApplyDTO;
import com.huuc.dormitory.dto.MoveAuditDTO;
import com.huuc.dormitory.entity.DormMoveApply;
import com.huuc.dormitory.vo.MoveApplyVO;

/**
 * 调宿服务接口
 */
public interface MoveApplyService {

    /**
     * 根据ID获取调宿申请详情
     */
    MoveApplyVO getApplyById(Long applyId);

    /**
     * 分页查询调宿申请列表
     */
    PageInfo<MoveApplyVO> getApplyList(DormMoveApply query, Integer pageNum, Integer pageSize);

    /**
     * 分页查询我的调宿申请
     */
    PageInfo<MoveApplyVO> getMyApplies(Long studentId, Integer pageNum, Integer pageSize);

    /**
     * 提交调宿申请
     */
    void apply(MoveApplyDTO dto, Long studentId);

    /**
     * 审批调宿申请
     */
    void audit(Long applyId, MoveAuditDTO dto, Long auditorId);

    /**
     * 撤销调宿申请
     */
    void cancel(Long applyId, Long studentId);
}
