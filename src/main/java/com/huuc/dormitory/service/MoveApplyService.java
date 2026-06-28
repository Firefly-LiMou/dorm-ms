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
     * 按学号模糊查询调宿申请列表
     */
    PageInfo<MoveApplyVO> getApplyListByStudentNo(String studentNo, Integer auditStatus, Integer pageNum, Integer pageSize);

    /**
     * 按学号模糊查询本楼栋调宿申请列表
     */
    PageInfo<MoveApplyVO> getApplyListByStudentNoAndBuildingId(String studentNo, Long buildingId, Integer auditStatus, Integer pageNum, Integer pageSize);

    /**
     * 按楼栋查询调宿申请列表
     */
    PageInfo<MoveApplyVO> getApplyListByBuildingId(Long buildingId, Integer auditStatus, Integer pageNum, Integer pageSize);

    /**
     * 分页查询我的调宿申请
     */
    PageInfo<MoveApplyVO> getMyApplies(Long studentId, Integer pageNum, Integer pageSize);

    /**
     * 提交调宿申请
     *
     * @param dto       申请参数（目标床位ID、申请原因）
     * @param studentId 学生ID
     * @throws com.huuc.dormitory.common.exception.BusinessException 无在住记录、已有待审批申请、目标床位已占用
     */
    void apply(MoveApplyDTO dto, Long studentId);

    /**
     * 审批调宿申请
     * 审批通过时事务操作：释放原床位、占用目标床位、原记录退宿、创建新入住记录
     *
     * @param applyId   申请ID
     * @param dto       审批参数（审批状态、审批意见）
     * @param auditorId 审批人ID
     * @throws com.huuc.dormitory.common.exception.BusinessException 申请不存在、状态无法操作、目标床位已占用
     */
    void audit(Long applyId, MoveAuditDTO dto, Long auditorId);

    /**
     * 撤销调宿申请（学生主动撤销，状态变为已驳回）
     *
     * @param applyId   申请ID
     * @param studentId 学生ID
     * @throws com.huuc.dormitory.common.exception.BusinessException 申请不存在、无权操作、状态无法撤销
     */
    void cancel(Long applyId, Long studentId);
}
