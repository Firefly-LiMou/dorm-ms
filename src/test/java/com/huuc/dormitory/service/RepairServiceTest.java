package com.huuc.dormitory.service;

import com.huuc.dormitory.common.enums.RepairStatusEnum;
import com.huuc.dormitory.common.exception.BusinessException;
import com.huuc.dormitory.dao.DormBedMapper;
import com.huuc.dormitory.dao.DormBuildingMapper;
import com.huuc.dormitory.dao.DormCheckinRecordMapper;
import com.huuc.dormitory.dao.DormRepairMapper;
import com.huuc.dormitory.dao.DormRoomMapper;
import com.huuc.dormitory.dao.SysUserMapper;
import com.huuc.dormitory.dto.RepairDTO;
import com.huuc.dormitory.dto.RepairHandleDTO;
import com.huuc.dormitory.entity.DormBed;
import com.huuc.dormitory.entity.DormCheckinRecord;
import com.huuc.dormitory.entity.DormRepair;
import com.huuc.dormitory.service.impl.RepairServiceImpl;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

/**
 * RepairServiceImpl单元测试
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("RepairServiceImpl报修服务测试")
class RepairServiceTest {

    @InjectMocks
    private RepairServiceImpl repairService;

    @Mock
    private DormRepairMapper repairMapper;

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

    // ==================== submitRepair() 提交报修测试 ====================

    @Test
    @DisplayName("submitRepair_正常提交_插入报修记录")
    void submitRepair_正常提交_插入报修记录() {
        // given
        RepairDTO dto = new RepairDTO();
        dto.setRepairType(1);
        dto.setRepairContent("水龙头漏水");
        dto.setContactPhone("13800138000");

        DormCheckinRecord checkinRecord = new DormCheckinRecord();
        checkinRecord.setCheckinId(1L);
        checkinRecord.setBedId(10L);

        DormBed bed = new DormBed();
        bed.setBedId(10L);
        bed.setRoomId(100L);

        when(checkinRecordMapper.selectActiveByStudentId(1L)).thenReturn(checkinRecord);
        when(bedMapper.selectById(10L)).thenReturn(bed);
        when(repairMapper.insert(any(DormRepair.class))).thenReturn(1);

        // when
        assertDoesNotThrow(() -> repairService.submitRepair(dto, 1L));

        // then
        verify(repairMapper).insert(any(DormRepair.class));
    }

    @Test
    @DisplayName("submitRepair_无在住记录_抛出400异常")
    void submitRepair_无在住记录_抛出400异常() {
        // given
        RepairDTO dto = new RepairDTO();
        dto.setRepairType(1);
        dto.setRepairContent("水龙头漏水");
        dto.setContactPhone("13800138000");

        when(checkinRecordMapper.selectActiveByStudentId(1L)).thenReturn(null);

        // when & then
        BusinessException ex = assertThrows(BusinessException.class,
                () -> repairService.submitRepair(dto, 1L));
        assertEquals(BusinessException.CODE_BAD_REQUEST, ex.getCode());
    }

    // ==================== handleRepair() 接单处理测试 ====================

    @Test
    @DisplayName("handleRepair_正常接单_更新状态为处理中")
    void handleRepair_正常接单_更新状态为处理中() {
        // given
        DormRepair repair = new DormRepair();
        repair.setRepairId(1L);
        repair.setRepairStatus(RepairStatusEnum.PENDING.getCode());

        when(repairMapper.selectById(1L)).thenReturn(repair);
        when(repairMapper.update(any(DormRepair.class))).thenReturn(1);

        // when
        assertDoesNotThrow(() -> repairService.handleRepair(1L, 100L));

        // then
        verify(repairMapper).update(any(DormRepair.class));
    }

    @Test
    @DisplayName("handleRepair_记录不存在_抛出404异常")
    void handleRepair_记录不存在_抛出404异常() {
        // given
        when(repairMapper.selectById(999L)).thenReturn(null);

        // when & then
        BusinessException ex = assertThrows(BusinessException.class,
                () -> repairService.handleRepair(999L, 100L));
        assertEquals(BusinessException.CODE_NOT_FOUND, ex.getCode());
    }

    @Test
    @DisplayName("handleRepair_状态非待处理_抛出400异常")
    void handleRepair_状态非待处理_抛出400异常() {
        // given
        DormRepair repair = new DormRepair();
        repair.setRepairId(1L);
        repair.setRepairStatus(RepairStatusEnum.PROCESSING.getCode());

        when(repairMapper.selectById(1L)).thenReturn(repair);

        // when & then
        BusinessException ex = assertThrows(BusinessException.class,
                () -> repairService.handleRepair(1L, 100L));
        assertEquals(BusinessException.CODE_BAD_REQUEST, ex.getCode());
    }

    // ==================== completeRepair() 完结报修测试 ====================

    @Test
    @DisplayName("completeRepair_正常完结_更新状态为已完成")
    void completeRepair_正常完结_更新状态为已完成() {
        // given
        RepairHandleDTO dto = new RepairHandleDTO();
        dto.setHandleResult("已更换水龙头");

        DormRepair repair = new DormRepair();
        repair.setRepairId(1L);
        repair.setRepairStatus(RepairStatusEnum.PROCESSING.getCode());

        when(repairMapper.selectById(1L)).thenReturn(repair);
        when(repairMapper.update(any(DormRepair.class))).thenReturn(1);

        // when
        assertDoesNotThrow(() -> repairService.completeRepair(1L, dto, 100L));

        // then
        verify(repairMapper).update(any(DormRepair.class));
    }

    @Test
    @DisplayName("completeRepair_状态非处理中_抛出400异常")
    void completeRepair_状态非处理中_抛出400异常() {
        // given
        RepairHandleDTO dto = new RepairHandleDTO();
        dto.setHandleResult("已更换水龙头");

        DormRepair repair = new DormRepair();
        repair.setRepairId(1L);
        repair.setRepairStatus(RepairStatusEnum.PENDING.getCode());

        when(repairMapper.selectById(1L)).thenReturn(repair);

        // when & then
        BusinessException ex = assertThrows(BusinessException.class,
                () -> repairService.completeRepair(1L, dto, 100L));
        assertEquals(BusinessException.CODE_BAD_REQUEST, ex.getCode());
    }

    @Test
    @DisplayName("completeRepair_记录不存在_抛出404异常")
    void completeRepair_记录不存在_抛出404异常() {
        // given
        RepairHandleDTO dto = new RepairHandleDTO();
        dto.setHandleResult("已更换水龙头");

        when(repairMapper.selectById(999L)).thenReturn(null);

        // when & then
        BusinessException ex = assertThrows(BusinessException.class,
                () -> repairService.completeRepair(999L, dto, 100L));
        assertEquals(BusinessException.CODE_NOT_FOUND, ex.getCode());
    }
}
