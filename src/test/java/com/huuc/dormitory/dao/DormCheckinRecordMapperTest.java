package com.huuc.dormitory.dao;

import com.huuc.dormitory.entity.DormCheckinRecord;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDateTime;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

/**
 * DormCheckinRecordMapper单元测试
 */
@DisplayName("DormCheckinRecordMapper入住记录Mapper测试")
class DormCheckinRecordMapperTest extends BaseMapperTest {

    @Autowired
    private DormCheckinRecordMapper checkinRecordMapper;

    @Test
    @DisplayName("selectById_存在记录_返回记录信息")
    void selectById_存在记录_返回记录信息() {
        DormCheckinRecord record = checkinRecordMapper.selectById(1L);

        assertNotNull(record);
        assertEquals(1L, record.getCheckinId());
    }

    @Test
    @DisplayName("selectActiveByStudentId_有在住记录_返回最新记录")
    void selectActiveByStudentId_有在住记录_返回最新记录() {
        DormCheckinRecord record = checkinRecordMapper.selectActiveByStudentId(4L);

        assertNotNull(record);
        assertEquals(4L, record.getStudentId());
        assertEquals(1, record.getCheckinStatus());
    }

    @Test
    @DisplayName("selectActiveByStudentId_无在住记录_返回null")
    void selectActiveByStudentId_无在住记录_返回null() {
        DormCheckinRecord record = checkinRecordMapper.selectActiveByStudentId(1L);

        assertNull(record);
    }

    @Test
    @DisplayName("selectList_按状态筛选_返回匹配列表")
    void selectList_按状态筛选_返回匹配列表() {
        DormCheckinRecord query = new DormCheckinRecord();
        query.setCheckinStatus(1);

        List<DormCheckinRecord> records = checkinRecordMapper.selectList(query);

        assertNotNull(records);
        assertTrue(records.size() > 0);
        records.forEach(r -> assertEquals(1, r.getCheckinStatus()));
    }

    @Test
    @DisplayName("selectByBuildingId_按楼栋查询_返回该楼栋入住记录")
    void selectByBuildingId_按楼栋查询_返回该楼栋入住记录() {
        List<DormCheckinRecord> records = checkinRecordMapper.selectByBuildingId(1L);

        assertNotNull(records);
    }

    @Test
    @DisplayName("selectListByStudentNo_按学号模糊查询_返回匹配记录")
    void selectListByStudentNo_按学号模糊查询_返回匹配记录() {
        List<DormCheckinRecord> records = checkinRecordMapper.selectListByStudentNo("20220001", null);

        assertNotNull(records);
        assertTrue(records.size() > 0);
    }

    @Test
    @DisplayName("selectListByStudentNoAndBuildingId_按学号和楼栋查询_返回匹配记录")
    void selectListByStudentNoAndBuildingId_按学号和楼栋查询_返回匹配记录() {
        List<DormCheckinRecord> records = checkinRecordMapper.selectListByStudentNoAndBuildingId("2022", 1L, null);

        assertNotNull(records);
    }

    @Test
    @DisplayName("selectListByBuildingIdAndStatus_按楼栋和状态查询_返回匹配记录")
    void selectListByBuildingIdAndStatus_按楼栋和状态查询_返回匹配记录() {
        List<DormCheckinRecord> records = checkinRecordMapper.selectListByBuildingIdAndStatus(1L, 1);

        assertNotNull(records);
        records.forEach(r -> assertEquals(1, r.getCheckinStatus()));
    }

    @Test
    @DisplayName("selectActiveByRoomId_查询同房间在住学生_排除指定学生")
    void selectActiveByRoomId_查询同房间在住学生_排除指定学生() {
        // 先获取一个在住学生的房间ID
        DormCheckinRecord record = checkinRecordMapper.selectActiveByStudentId(4L);
        assertNotNull(record);

        List<DormCheckinRecord> records = checkinRecordMapper.selectActiveByRoomId(
                101L, 4L);

        assertNotNull(records);
        // 结果中不应包含学生4
        records.forEach(r -> assertNotEquals(4L, r.getStudentId()));
    }

    @Test
    @DisplayName("countActiveByStudentId_有在住记录_返回大于0")
    void countActiveByStudentId_有在住记录_返回大于0() {
        int count = checkinRecordMapper.countActiveByStudentId(4L);

        assertTrue(count > 0);
    }

    @Test
    @DisplayName("countActiveByStudentId_无在住记录_返回0")
    void countActiveByStudentId_无在住记录_返回0() {
        int count = checkinRecordMapper.countActiveByStudentId(1L);

        assertEquals(0, count);
    }

    @Test
    @DisplayName("insert_新增入住记录_返回自增ID")
    void insert_新增入住记录_返回自增ID() {
        DormCheckinRecord record = new DormCheckinRecord();
        record.setStudentId(1L);
        record.setBedId(1L);
        record.setCheckinTime(LocalDateTime.now());
        record.setCheckinStatus(1);
        record.setOperatorId(1L);

        int rows = checkinRecordMapper.insert(record);

        assertEquals(1, rows);
        assertNotNull(record.getCheckinId());
    }

    @Test
    @DisplayName("update_更新入住记录_返回影响行数")
    void update_更新入住记录_返回影响行数() {
        DormCheckinRecord record = new DormCheckinRecord();
        record.setCheckinId(1L);
        record.setCheckinStatus(2);
        record.setCheckoutTime(LocalDateTime.now());

        int rows = checkinRecordMapper.update(record);

        assertEquals(1, rows);
    }
}
