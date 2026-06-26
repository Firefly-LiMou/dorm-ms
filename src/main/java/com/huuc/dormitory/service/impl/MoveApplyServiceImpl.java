package com.huuc.dormitory.service.impl;

import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.common.enums.AuditStatusEnum;
import com.huuc.dormitory.common.enums.BedStatusEnum;
import com.huuc.dormitory.common.enums.CheckinStatusEnum;
import com.huuc.dormitory.common.exception.BusinessException;
import com.huuc.dormitory.dao.*;
import com.huuc.dormitory.dto.MoveApplyDTO;
import com.huuc.dormitory.dto.MoveAuditDTO;
import com.huuc.dormitory.entity.*;
import com.huuc.dormitory.service.MoveApplyService;
import com.huuc.dormitory.vo.MoveApplyVO;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * 调宿服务实现类
 */
@Service
public class MoveApplyServiceImpl implements MoveApplyService {

    @Autowired
    private DormMoveApplyMapper moveApplyMapper;

    @Autowired
    private DormCheckinRecordMapper checkinRecordMapper;

    @Autowired
    private DormBedMapper bedMapper;

    @Autowired
    private DormRoomMapper roomMapper;

    @Autowired
    private DormBuildingMapper buildingMapper;

    @Autowired
    private SysUserMapper userMapper;

    @Override
    public MoveApplyVO getApplyById(Long applyId) {
        DormMoveApply apply = moveApplyMapper.selectById(applyId);
        if (apply == null) {
            throw new BusinessException("调宿申请不存在");
        }
        return convertToVO(apply);
    }

    @Override
    public PageInfo<MoveApplyVO> getApplyList(DormMoveApply query, Integer pageNum, Integer pageSize) {
        List<DormMoveApply> applies = moveApplyMapper.selectList(query);
        PageInfo<DormMoveApply> pageInfo = new PageInfo<>(applies);

        PageInfo<MoveApplyVO> voPageInfo = new PageInfo<>();
        BeanUtils.copyProperties(pageInfo, voPageInfo);
        voPageInfo.setList(convertToVOList(applies));

        return voPageInfo;
    }

    @Override
    public PageInfo<MoveApplyVO> getMyApplies(Long studentId, Integer pageNum, Integer pageSize) {
        List<DormMoveApply> applies = moveApplyMapper.selectByStudentId(studentId);
        PageInfo<DormMoveApply> pageInfo = new PageInfo<>(applies);

        PageInfo<MoveApplyVO> voPageInfo = new PageInfo<>();
        BeanUtils.copyProperties(pageInfo, voPageInfo);
        voPageInfo.setList(convertToVOList(applies));

        return voPageInfo;
    }

    @Override
    @Transactional
    public void apply(MoveApplyDTO dto, Long studentId) {
        // 校验学生当前有在住记录
        DormCheckinRecord currentRecord = checkinRecordMapper.selectActiveByStudentId(studentId);
        if (currentRecord == null) {
            throw new BusinessException("您当前无在住记录，无法申请调宿");
        }

        // 校验学生无待审批的调宿申请
        int pendingCount = moveApplyMapper.countPendingByStudentId(studentId);
        if (pendingCount > 0) {
            throw new BusinessException("您已有待审批的调宿申请");
        }

        // 校验目标床位存在且状态为空闲
        DormBed targetBed = bedMapper.selectById(dto.getTargetBedId());
        if (targetBed == null) {
            throw new BusinessException("目标床位不存在");
        }
        if (!BedStatusEnum.FREE.getCode().equals(targetBed.getBedStatus())) {
            throw new BusinessException("目标床位已被占用");
        }

        // 插入调宿申请
        DormMoveApply apply = new DormMoveApply();
        apply.setStudentId(studentId);
        apply.setOriginalBedId(currentRecord.getBedId());
        apply.setTargetBedId(dto.getTargetBedId());
        apply.setApplyReason(dto.getApplyReason());
        apply.setApplyTime(LocalDateTime.now());
        apply.setAuditStatus(AuditStatusEnum.PENDING.getCode());
        moveApplyMapper.insert(apply);
    }

    @Override
    @Transactional
    public void audit(Long applyId, MoveAuditDTO dto, Long auditorId) {
        // 校验申请存在且状态为待审批
        DormMoveApply apply = moveApplyMapper.selectById(applyId);
        if (apply == null) {
            throw new BusinessException("调宿申请不存在");
        }
        if (!AuditStatusEnum.PENDING.getCode().equals(apply.getAuditStatus())) {
            throw new BusinessException("该申请状态无法操作");
        }

        if (AuditStatusEnum.APPROVED.getCode().equals(dto.getAuditStatus())) {
            // 审批通过
            auditApproved(apply, dto, auditorId);
        } else if (AuditStatusEnum.REJECTED.getCode().equals(dto.getAuditStatus())) {
            // 审批驳回
            auditRejected(apply, dto, auditorId);
        } else {
            throw new BusinessException("无效的审批状态");
        }
    }

    /**
     * 审批通过
     */
    private void auditApproved(DormMoveApply apply, MoveAuditDTO dto, Long auditorId) {
        // 校验目标床位仍为空闲
        DormBed targetBed = bedMapper.selectById(apply.getTargetBedId());
        if (targetBed == null || !BedStatusEnum.FREE.getCode().equals(targetBed.getBedStatus())) {
            throw new BusinessException("目标床位已被占用");
        }

        // 获取原入住记录
        DormCheckinRecord originalRecord = checkinRecordMapper.selectActiveByStudentId(apply.getStudentId());
        if (originalRecord == null) {
            throw new BusinessException("原入住记录不存在");
        }

        // 事务内执行：
        // 1. 原床位置空闲
        bedMapper.updateStatus(apply.getOriginalBedId(), BedStatusEnum.FREE.getCode());

        // 2. 目标床位置已入住
        bedMapper.updateStatus(apply.getTargetBedId(), BedStatusEnum.OCCUPIED.getCode());

        // 3. 更新原入住记录为已退宿
        originalRecord.setCheckinStatus(CheckinStatusEnum.CHECKED_OUT.getCode());
        originalRecord.setCheckoutTime(LocalDateTime.now());
        checkinRecordMapper.update(originalRecord);

        // 4. 创建新入住记录
        DormCheckinRecord newRecord = new DormCheckinRecord();
        newRecord.setStudentId(apply.getStudentId());
        newRecord.setBedId(apply.getTargetBedId());
        newRecord.setCheckinTime(LocalDateTime.now());
        newRecord.setCheckinStatus(CheckinStatusEnum.LIVING.getCode());
        newRecord.setOperatorId(auditorId);
        checkinRecordMapper.insert(newRecord);

        // 5. 更新申请状态
        apply.setAuditStatus(AuditStatusEnum.APPROVED.getCode());
        apply.setAuditorId(auditorId);
        apply.setAuditTime(LocalDateTime.now());
        apply.setAuditOpinion(dto.getAuditOpinion());
        moveApplyMapper.update(apply);
    }

    /**
     * 审批驳回
     */
    private void auditRejected(DormMoveApply apply, MoveAuditDTO dto, Long auditorId) {
        apply.setAuditStatus(AuditStatusEnum.REJECTED.getCode());
        apply.setAuditorId(auditorId);
        apply.setAuditTime(LocalDateTime.now());
        apply.setAuditOpinion(dto.getAuditOpinion());
        moveApplyMapper.update(apply);
    }

    @Override
    @Transactional
    public void cancel(Long applyId, Long studentId) {
        // 校验申请存在
        DormMoveApply apply = moveApplyMapper.selectById(applyId);
        if (apply == null) {
            throw new BusinessException("调宿申请不存在");
        }

        // 校验申请属于当前学生
        if (!apply.getStudentId().equals(studentId)) {
            throw new BusinessException("无权操作此申请");
        }

        // 校验申请状态为待审批
        if (!AuditStatusEnum.PENDING.getCode().equals(apply.getAuditStatus())) {
            throw new BusinessException("该申请状态无法撤销");
        }

        // 更新申请状态为已驳回
        apply.setAuditStatus(AuditStatusEnum.REJECTED.getCode());
        apply.setAuditOpinion("申请人主动撤销");
        moveApplyMapper.update(apply);
    }

    /**
     * 实体转VO
     */
    private MoveApplyVO convertToVO(DormMoveApply apply) {
        MoveApplyVO vo = new MoveApplyVO();
        BeanUtils.copyProperties(apply, vo);

        // 查询学生信息
        SysUser student = userMapper.selectById(apply.getStudentId());
        if (student != null) {
            vo.setStudentName(student.getRealName());
            vo.setStudentNo(student.getUsername());
        }

        // 查询原床位信息
        DormBed originalBed = bedMapper.selectById(apply.getOriginalBedId());
        if (originalBed != null) {
            vo.setOriginalBedInfo(buildBedInfo(originalBed));
        }

        // 查询目标床位信息
        DormBed targetBed = bedMapper.selectById(apply.getTargetBedId());
        if (targetBed != null) {
            vo.setTargetBedInfo(buildBedInfo(targetBed));
        }

        // 查询审批人信息
        if (apply.getAuditorId() != null) {
            SysUser auditor = userMapper.selectById(apply.getAuditorId());
            if (auditor != null) {
                vo.setAuditorName(auditor.getRealName());
            }
        }

        // 设置审批状态文本
        AuditStatusEnum statusEnum = AuditStatusEnum.getByCode(apply.getAuditStatus());
        if (statusEnum != null) {
            vo.setAuditStatusText(statusEnum.getDesc());
        }

        return vo;
    }

    /**
     * 构建床位信息字符串
     */
    private String buildBedInfo(DormBed bed) {
        StringBuilder sb = new StringBuilder();

        DormRoom room = roomMapper.selectById(bed.getRoomId());
        if (room != null) {
            DormBuilding building = buildingMapper.selectById(room.getBuildingId());
            if (building != null) {
                sb.append(building.getBuildingName());
            }
            sb.append(room.getRoomNo()).append("室");
        }
        sb.append(bed.getBedNo());

        return sb.toString();
    }

    /**
     * 实体列表转VO列表
     */
    private List<MoveApplyVO> convertToVOList(List<DormMoveApply> applies) {
        List<MoveApplyVO> voList = new ArrayList<>();
        for (DormMoveApply apply : applies) {
            voList.add(convertToVO(apply));
        }
        return voList;
    }
}
