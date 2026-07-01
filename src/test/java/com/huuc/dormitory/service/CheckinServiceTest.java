package com.huuc.dormitory.service;

import com.huuc.dormitory.common.enums.BedStatusEnum;
import com.huuc.dormitory.common.enums.CheckinStatusEnum;
import com.huuc.dormitory.common.enums.UserStatusEnum;
import com.huuc.dormitory.common.exception.BusinessException;
import com.huuc.dormitory.dao.DormBedMapper;
import com.huuc.dormitory.dao.DormBuildingMapper;
import com.huuc.dormitory.dao.DormCheckinRecordMapper;
import com.huuc.dormitory.dao.DormRoomMapper;
import com.huuc.dormitory.dao.SysUserMapper;
import com.huuc.dormitory.dto.CheckinDTO;
import com.huuc.dormitory.entity.DormBed;
import com.huuc.dormitory.entity.DormCheckinRecord;
import com.huuc.dormitory.entity.SysUser;
import com.huuc.dormitory.service.impl.CheckinServiceImpl;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

/**
 * CheckinServiceImpl单元测试
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("CheckinServiceImpl入住服务测试")
class CheckinServiceTest {

    @InjectMocks
    private CheckinServiceImpl checkinService;

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

    // ==================== checkin() 办理入住测试 ====================

    @Test
    @DisplayName("checkin_正常入住_插入记录并更新床位状态")
    void checkin_正常入住_插入记录并更新床位状态() {
        // given
        CheckinDTO dto = new CheckinDTO();
        dto.setStudentId(1L);
        dto.setBedId(10L);

        SysUser student = new SysUser();
        student.setUserId(1L);
        student.setStatus(UserStatusEnum.NORMAL.getCode());

        DormBed bed = new DormBed();
        bed.setBedId(10L);
        bed.setBedStatus(BedStatusEnum.FREE.getCode());

        when(userMapper.selectById(1L)).thenReturn(student);
        when(checkinRecordMapper.countActiveByStudentId(1L)).thenReturn(0);
        when(bedMapper.selectById(10L)).thenReturn(bed);
        when(checkinRecordMapper.insert(any(DormCheckinRecord.class))).thenReturn(1);
        when(bedMapper.updateStatus(eq(10L), eq(BedStatusEnum.OCCUPIED.getCode()))).thenReturn(1);

        // when
        assertDoesNotThrow(() -> checkinService.checkin(dto, 100L));

        // then
        verify(checkinRecordMapper).insert(any(DormCheckinRecord.class));
        verify(bedMapper).updateStatus(10L, BedStatusEnum.OCCUPIED.getCode());
    }

    @Test
    @DisplayName("checkin_学生不存在_抛出404异常")
    void checkin_学生不存在_抛出404异常() {
        // given
        CheckinDTO dto = new CheckinDTO();
        dto.setStudentId(999L);
        dto.setBedId(10L);

        when(userMapper.selectById(999L)).thenReturn(null);

        // when & then
        BusinessException ex = assertThrows(BusinessException.class,
                () -> checkinService.checkin(dto, 100L));
        assertEquals(BusinessException.CODE_NOT_FOUND, ex.getCode());
    }

    @Test
    @DisplayName("checkin_学生状态禁用_抛出400异常")
    void checkin_学生状态禁用_抛出400异常() {
        // given
        CheckinDTO dto = new CheckinDTO();
        dto.setStudentId(1L);
        dto.setBedId(10L);

        SysUser student = new SysUser();
        student.setUserId(1L);
        student.setStatus(UserStatusEnum.DISABLED.getCode());

        when(userMapper.selectById(1L)).thenReturn(student);

        // when & then
        BusinessException ex = assertThrows(BusinessException.class,
                () -> checkinService.checkin(dto, 100L));
        assertEquals(BusinessException.CODE_BAD_REQUEST, ex.getCode());
    }

    @Test
    @DisplayName("checkin_已有在住记录_抛出409异常")
    void checkin_已有在住记录_抛出409异常() {
        // given
        CheckinDTO dto = new CheckinDTO();
        dto.setStudentId(1L);
        dto.setBedId(10L);

        SysUser student = new SysUser();
        student.setUserId(1L);
        student.setStatus(UserStatusEnum.NORMAL.getCode());

        when(userMapper.selectById(1L)).thenReturn(student);
        when(checkinRecordMapper.countActiveByStudentId(1L)).thenReturn(1);

        // when & then
        BusinessException ex = assertThrows(BusinessException.class,
                () -> checkinService.checkin(dto, 100L));
        assertEquals(BusinessException.CODE_CONFLICT, ex.getCode());
    }

    @Test
    @DisplayName("checkin_床位不存在_抛出404异常")
    void checkin_床位不存在_抛出404异常() {
        // given
        CheckinDTO dto = new CheckinDTO();
        dto.setStudentId(1L);
        dto.setBedId(999L);

        SysUser student = new SysUser();
        student.setUserId(1L);
        student.setStatus(UserStatusEnum.NORMAL.getCode());

        when(userMapper.selectById(1L)).thenReturn(student);
        when(checkinRecordMapper.countActiveByStudentId(1L)).thenReturn(0);
        when(bedMapper.selectById(999L)).thenReturn(null);

        // when & then
        BusinessException ex = assertThrows(BusinessException.class,
                () -> checkinService.checkin(dto, 100L));
        assertEquals(BusinessException.CODE_NOT_FOUND, ex.getCode());
    }

    @Test
    @DisplayName("checkin_床位已被占用_抛出409异常")
    void checkin_床位已被占用_抛出409异常() {
        // given
        CheckinDTO dto = new CheckinDTO();
        dto.setStudentId(1L);
        dto.setBedId(10L);

        SysUser student = new SysUser();
        student.setUserId(1L);
        student.setStatus(UserStatusEnum.NORMAL.getCode());

        DormBed bed = new DormBed();
        bed.setBedId(10L);
        bed.setBedStatus(BedStatusEnum.OCCUPIED.getCode());

        when(userMapper.selectById(1L)).thenReturn(student);
        when(checkinRecordMapper.countActiveByStudentId(1L)).thenReturn(0);
        when(bedMapper.selectById(10L)).thenReturn(bed);

        // when & then
        BusinessException ex = assertThrows(BusinessException.class,
                () -> checkinService.checkin(dto, 100L));
        assertEquals(BusinessException.CODE_CONFLICT, ex.getCode());
    }

    // ==================== checkout() 办理退宿测试 ====================

    @Test
    @DisplayName("checkout_正常退宿_更新记录状态并释放床位")
    void checkout_正常退宿_更新记录状态并释放床位() {
        // given
        DormCheckinRecord record = new DormCheckinRecord();
        record.setCheckinId(1L);
        record.setBedId(10L);
        record.setCheckinStatus(CheckinStatusEnum.LIVING.getCode());

        when(checkinRecordMapper.selectById(1L)).thenReturn(record);
        when(checkinRecordMapper.update(any(DormCheckinRecord.class))).thenReturn(1);
        when(bedMapper.updateStatus(eq(10L), eq(BedStatusEnum.FREE.getCode()))).thenReturn(1);

        // when
        assertDoesNotThrow(() -> checkinService.checkout(1L, 100L));

        // then
        verify(checkinRecordMapper).update(any(DormCheckinRecord.class));
        verify(bedMapper).updateStatus(10L, BedStatusEnum.FREE.getCode());
    }

    @Test
    @DisplayName("checkout_记录不存在_抛出404异常")
    void checkout_记录不存在_抛出404异常() {
        // given
        when(checkinRecordMapper.selectById(999L)).thenReturn(null);

        // when & then
        BusinessException ex = assertThrows(BusinessException.class,
                () -> checkinService.checkout(999L, 100L));
        assertEquals(BusinessException.CODE_NOT_FOUND, ex.getCode());
    }

    @Test
    @DisplayName("checkout_状态已退宿_抛出400异常")
    void checkout_状态已退宿_抛出400异常() {
        // given
        DormCheckinRecord record = new DormCheckinRecord();
        record.setCheckinId(1L);
        record.setCheckinStatus(CheckinStatusEnum.CHECKED_OUT.getCode());

        when(checkinRecordMapper.selectById(1L)).thenReturn(record);

        // when & then
        BusinessException ex = assertThrows(BusinessException.class,
                () -> checkinService.checkout(1L, 100L));
        assertEquals(BusinessException.CODE_BAD_REQUEST, ex.getCode());
    }
}
