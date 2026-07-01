package com.huuc.dormitory.service;

import com.huuc.dormitory.common.enums.AuditStatusEnum;
import com.huuc.dormitory.common.enums.BedStatusEnum;
import com.huuc.dormitory.common.enums.CheckinStatusEnum;
import com.huuc.dormitory.common.exception.BusinessException;
import com.huuc.dormitory.dao.DormBedMapper;
import com.huuc.dormitory.dao.DormBuildingMapper;
import com.huuc.dormitory.dao.DormCheckinRecordMapper;
import com.huuc.dormitory.dao.DormMoveApplyMapper;
import com.huuc.dormitory.dao.DormRoomMapper;
import com.huuc.dormitory.dao.SysUserMapper;
import com.huuc.dormitory.dto.MoveApplyDTO;
import com.huuc.dormitory.dto.MoveAuditDTO;
import com.huuc.dormitory.entity.DormBed;
import com.huuc.dormitory.entity.DormCheckinRecord;
import com.huuc.dormitory.entity.DormMoveApply;
import com.huuc.dormitory.service.impl.MoveApplyServiceImpl;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

/**
 * MoveApplyServiceImpl单元测试
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("MoveApplyServiceImpl调宿服务测试")
class MoveApplyServiceTest {

    @InjectMocks
    private MoveApplyServiceImpl moveApplyService;

    @Mock
    private DormMoveApplyMapper moveApplyMapper;

    @Mock
    private DormCheckinRecordMapper checkinRecordMapper;

    @Mock
    private DormBedMapper bedMapper;

    @Mock
    private DormRoomMapper roomMapper;

    @Mock
    private DormBuildingMapper buildingMapper;

    @Mock
    private SysUserMapper userMapper;

    // ==================== apply() 提交调宿申请测试 ====================

    @Test
    @DisplayName("apply_正常提交_插入调宿申请")
    void apply_正常提交_插入调宿申请() {
        // given
        MoveApplyDTO dto = new MoveApplyDTO();
        dto.setTargetBedId(20L);
        dto.setApplyReason("想换个床位");

        DormCheckinRecord currentRecord = new DormCheckinRecord();
        currentRecord.setCheckinId(1L);
        currentRecord.setBedId(10L);

        DormBed targetBed = new DormBed();
        targetBed.setBedId(20L);
        targetBed.setBedStatus(BedStatusEnum.FREE.getCode());

        when(checkinRecordMapper.selectActiveByStudentId(1L)).thenReturn(currentRecord);
        when(moveApplyMapper.countPendingByStudentId(1L)).thenReturn(0);
        when(bedMapper.selectById(20L)).thenReturn(targetBed);
        when(moveApplyMapper.insert(any(DormMoveApply.class))).thenReturn(1);

        // when
        assertDoesNotThrow(() -> moveApplyService.apply(dto, 1L));

        // then
        verify(moveApplyMapper).insert(any(DormMoveApply.class));
    }

    @Test
    @DisplayName("apply_无在住记录_抛出400异常")
    void apply_无在住记录_抛出400异常() {
        // given
        MoveApplyDTO dto = new MoveApplyDTO();
        dto.setTargetBedId(20L);
        dto.setApplyReason("想换个床位");

        when(checkinRecordMapper.selectActiveByStudentId(1L)).thenReturn(null);

        // when & then
        BusinessException ex = assertThrows(BusinessException.class,
                () -> moveApplyService.apply(dto, 1L));
        assertEquals(BusinessException.CODE_BAD_REQUEST, ex.getCode());
    }

    @Test
    @DisplayName("apply_已有待审批申请_抛出409异常")
    void apply_已有待审批申请_抛出409异常() {
        // given
        MoveApplyDTO dto = new MoveApplyDTO();
        dto.setTargetBedId(20L);
        dto.setApplyReason("想换个床位");

        DormCheckinRecord currentRecord = new DormCheckinRecord();
        currentRecord.setCheckinId(1L);

        when(checkinRecordMapper.selectActiveByStudentId(1L)).thenReturn(currentRecord);
        when(moveApplyMapper.countPendingByStudentId(1L)).thenReturn(1);

        // when & then
        BusinessException ex = assertThrows(BusinessException.class,
                () -> moveApplyService.apply(dto, 1L));
        assertEquals(BusinessException.CODE_CONFLICT, ex.getCode());
    }

    @Test
    @DisplayName("apply_目标床位不存在_抛出404异常")
    void apply_目标床位不存在_抛出404异常() {
        // given
        MoveApplyDTO dto = new MoveApplyDTO();
        dto.setTargetBedId(999L);
        dto.setApplyReason("想换个床位");

        DormCheckinRecord currentRecord = new DormCheckinRecord();
        currentRecord.setCheckinId(1L);

        when(checkinRecordMapper.selectActiveByStudentId(1L)).thenReturn(currentRecord);
        when(moveApplyMapper.countPendingByStudentId(1L)).thenReturn(0);
        when(bedMapper.selectById(999L)).thenReturn(null);

        // when & then
        BusinessException ex = assertThrows(BusinessException.class,
                () -> moveApplyService.apply(dto, 1L));
        assertEquals(BusinessException.CODE_NOT_FOUND, ex.getCode());
    }

    @Test
    @DisplayName("apply_目标床位被占用_抛出409异常")
    void apply_目标床位被占用_抛出409异常() {
        // given
        MoveApplyDTO dto = new MoveApplyDTO();
        dto.setTargetBedId(20L);
        dto.setApplyReason("想换个床位");

        DormCheckinRecord currentRecord = new DormCheckinRecord();
        currentRecord.setCheckinId(1L);

        DormBed targetBed = new DormBed();
        targetBed.setBedId(20L);
        targetBed.setBedStatus(BedStatusEnum.OCCUPIED.getCode());

        when(checkinRecordMapper.selectActiveByStudentId(1L)).thenReturn(currentRecord);
        when(moveApplyMapper.countPendingByStudentId(1L)).thenReturn(0);
        when(bedMapper.selectById(20L)).thenReturn(targetBed);

        // when & then
        BusinessException ex = assertThrows(BusinessException.class,
                () -> moveApplyService.apply(dto, 1L));
        assertEquals(BusinessException.CODE_CONFLICT, ex.getCode());
    }

    // ==================== audit() 审批调宿申请测试 ====================

    @Test
    @DisplayName("audit_审批通过_执行事务操作")
    void audit_审批通过_执行事务操作() {
        // given
        MoveAuditDTO dto = new MoveAuditDTO();
        dto.setAuditStatus(AuditStatusEnum.APPROVED.getCode());
        dto.setAuditOpinion("同意");

        DormMoveApply apply = new DormMoveApply();
        apply.setApplyId(1L);
        apply.setStudentId(1L);
        apply.setOriginalBedId(10L);
        apply.setTargetBedId(20L);
        apply.setAuditStatus(AuditStatusEnum.PENDING.getCode());

        DormBed targetBed = new DormBed();
        targetBed.setBedId(20L);
        targetBed.setBedStatus(BedStatusEnum.FREE.getCode());

        DormCheckinRecord originalRecord = new DormCheckinRecord();
        originalRecord.setCheckinId(1L);
        originalRecord.setBedId(10L);
        originalRecord.setCheckinStatus(CheckinStatusEnum.LIVING.getCode());

        when(moveApplyMapper.selectById(1L)).thenReturn(apply);
        when(bedMapper.selectById(20L)).thenReturn(targetBed);
        when(checkinRecordMapper.selectActiveByStudentId(1L)).thenReturn(originalRecord);
        when(bedMapper.updateStatus(anyLong(), anyInt())).thenReturn(1);
        when(checkinRecordMapper.update(any(DormCheckinRecord.class))).thenReturn(1);
        when(checkinRecordMapper.insert(any(DormCheckinRecord.class))).thenReturn(1);
        when(moveApplyMapper.update(any(DormMoveApply.class))).thenReturn(1);

        // when
        assertDoesNotThrow(() -> moveApplyService.audit(1L, dto, 100L));

        // then
        verify(bedMapper).updateStatus(10L, BedStatusEnum.FREE.getCode());
        verify(bedMapper).updateStatus(20L, BedStatusEnum.OCCUPIED.getCode());
        verify(checkinRecordMapper).update(any(DormCheckinRecord.class));
        verify(checkinRecordMapper).insert(any(DormCheckinRecord.class));
        verify(moveApplyMapper).update(any(DormMoveApply.class));
    }

    @Test
    @DisplayName("audit_审批驳回_仅更新申请状态")
    void audit_审批驳回_仅更新申请状态() {
        // given
        MoveAuditDTO dto = new MoveAuditDTO();
        dto.setAuditStatus(AuditStatusEnum.REJECTED.getCode());
        dto.setAuditOpinion("不同意");

        DormMoveApply apply = new DormMoveApply();
        apply.setApplyId(1L);
        apply.setAuditStatus(AuditStatusEnum.PENDING.getCode());

        when(moveApplyMapper.selectById(1L)).thenReturn(apply);
        when(moveApplyMapper.update(any(DormMoveApply.class))).thenReturn(1);

        // when
        assertDoesNotThrow(() -> moveApplyService.audit(1L, dto, 100L));

        // then
        verify(moveApplyMapper).update(any(DormMoveApply.class));
        verify(bedMapper, never()).updateStatus(anyLong(), anyInt());
    }

    @Test
    @DisplayName("audit_申请不存在_抛出404异常")
    void audit_申请不存在_抛出404异常() {
        // given
        MoveAuditDTO dto = new MoveAuditDTO();
        dto.setAuditStatus(AuditStatusEnum.APPROVED.getCode());

        when(moveApplyMapper.selectById(999L)).thenReturn(null);

        // when & then
        BusinessException ex = assertThrows(BusinessException.class,
                () -> moveApplyService.audit(999L, dto, 100L));
        assertEquals(BusinessException.CODE_NOT_FOUND, ex.getCode());
    }

    @Test
    @DisplayName("audit_状态非待审批_抛出400异常")
    void audit_状态非待审批_抛出400异常() {
        // given
        MoveAuditDTO dto = new MoveAuditDTO();
        dto.setAuditStatus(AuditStatusEnum.APPROVED.getCode());

        DormMoveApply apply = new DormMoveApply();
        apply.setApplyId(1L);
        apply.setAuditStatus(AuditStatusEnum.APPROVED.getCode());

        when(moveApplyMapper.selectById(1L)).thenReturn(apply);

        // when & then
        BusinessException ex = assertThrows(BusinessException.class,
                () -> moveApplyService.audit(1L, dto, 100L));
        assertEquals(BusinessException.CODE_BAD_REQUEST, ex.getCode());
    }

    @Test
    @DisplayName("audit_审批通过时目标床位被占用_抛出409异常")
    void audit_审批通过时目标床位被占用_抛出409异常() {
        // given
        MoveAuditDTO dto = new MoveAuditDTO();
        dto.setAuditStatus(AuditStatusEnum.APPROVED.getCode());

        DormMoveApply apply = new DormMoveApply();
        apply.setApplyId(1L);
        apply.setStudentId(1L);
        apply.setTargetBedId(20L);
        apply.setAuditStatus(AuditStatusEnum.PENDING.getCode());

        DormBed targetBed = new DormBed();
        targetBed.setBedId(20L);
        targetBed.setBedStatus(BedStatusEnum.OCCUPIED.getCode());

        when(moveApplyMapper.selectById(1L)).thenReturn(apply);
        when(bedMapper.selectById(20L)).thenReturn(targetBed);

        // when & then
        BusinessException ex = assertThrows(BusinessException.class,
                () -> moveApplyService.audit(1L, dto, 100L));
        assertEquals(BusinessException.CODE_CONFLICT, ex.getCode());
    }

    // ==================== cancel() 撤销调宿申请测试 ====================

    @Test
    @DisplayName("cancel_正常撤销_更新状态为已驳回")
    void cancel_正常撤销_更新状态为已驳回() {
        // given
        DormMoveApply apply = new DormMoveApply();
        apply.setApplyId(1L);
        apply.setStudentId(1L);
        apply.setAuditStatus(AuditStatusEnum.PENDING.getCode());

        when(moveApplyMapper.selectById(1L)).thenReturn(apply);
        when(moveApplyMapper.update(any(DormMoveApply.class))).thenReturn(1);

        // when
        assertDoesNotThrow(() -> moveApplyService.cancel(1L, 1L));

        // then
        verify(moveApplyMapper).update(any(DormMoveApply.class));
    }

    @Test
    @DisplayName("cancel_申请不存在_抛出404异常")
    void cancel_申请不存在_抛出404异常() {
        // given
        when(moveApplyMapper.selectById(999L)).thenReturn(null);

        // when & then
        BusinessException ex = assertThrows(BusinessException.class,
                () -> moveApplyService.cancel(999L, 1L));
        assertEquals(BusinessException.CODE_NOT_FOUND, ex.getCode());
    }

    @Test
    @DisplayName("cancel_无权操作_抛出403异常")
    void cancel_无权操作_抛出403异常() {
        // given
        DormMoveApply apply = new DormMoveApply();
        apply.setApplyId(1L);
        apply.setStudentId(1L);
        apply.setAuditStatus(AuditStatusEnum.PENDING.getCode());

        when(moveApplyMapper.selectById(1L)).thenReturn(apply);

        // when & then
        BusinessException ex = assertThrows(BusinessException.class,
                () -> moveApplyService.cancel(1L, 999L));
        assertEquals(BusinessException.CODE_FORBIDDEN, ex.getCode());
    }

    @Test
    @DisplayName("cancel_状态非待审批_抛出400异常")
    void cancel_状态非待审批_抛出400异常() {
        // given
        DormMoveApply apply = new DormMoveApply();
        apply.setApplyId(1L);
        apply.setStudentId(1L);
        apply.setAuditStatus(AuditStatusEnum.APPROVED.getCode());

        when(moveApplyMapper.selectById(1L)).thenReturn(apply);

        // when & then
        BusinessException ex = assertThrows(BusinessException.class,
                () -> moveApplyService.cancel(1L, 1L));
        assertEquals(BusinessException.CODE_BAD_REQUEST, ex.getCode());
    }
}
