package com.huuc.dormitory.dao;

import com.huuc.dormitory.entity.DormMoveApply;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import java.time.LocalDateTime;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

/**
 * DormMoveApplyMapper单元测试
 */
@DisplayName("DormMoveApplyMapper调宿申请Mapper测试")
class DormMoveApplyMapperTest extends BaseMapperTest {

    @Autowired
    private DormMoveApplyMapper moveApplyMapper;

    @Test
    @DisplayName("selectById_存在记录_返回记录信息")
    void selectById_存在记录_返回记录信息() {
        DormMoveApply apply = moveApplyMapper.selectById(1L);

        assertNotNull(apply);
        assertEquals(1L, apply.getApplyId());
    }

    @Test
    @DisplayName("selectByStudentId_查询学生申请_返回申请列表")
    void selectByStudentId_查询学生申请_返回申请列表() {
        List<DormMoveApply> applies = moveApplyMapper.selectByStudentId(4L);

        assertNotNull(applies);
    }

    @Test
    @DisplayName("selectList_按状态筛选_返回匹配列表")
    void selectList_按状态筛选_返回匹配列表() {
        DormMoveApply query = new DormMoveApply();
        query.setAuditStatus(0);

        List<DormMoveApply> applies = moveApplyMapper.selectList(query);

        assertNotNull(applies);
        applies.forEach(a -> assertEquals(0, a.getAuditStatus()));
    }

    @Test
    @DisplayName("selectListByStudentNo_按学号模糊查询_返回匹配记录")
    void selectListByStudentNo_按学号模糊查询_返回匹配记录() {
        List<DormMoveApply> applies = moveApplyMapper.selectListByStudentNo("2022", null);

        assertNotNull(applies);
    }

    @Test
    @DisplayName("selectListByStudentNoAndBuildingId_按学号和楼栋查询_返回匹配记录")
    void selectListByStudentNoAndBuildingId_按学号和楼栋查询_返回匹配记录() {
        List<DormMoveApply> applies = moveApplyMapper.selectListByStudentNoAndBuildingId("2022", 1L, null);

        assertNotNull(applies);
    }

    @Test
    @DisplayName("selectListByBuildingId_按楼栋和状态查询_返回匹配记录")
    void selectListByBuildingId_按楼栋和状态查询_返回匹配记录() {
        List<DormMoveApply> applies = moveApplyMapper.selectListByBuildingId(1L, 0);

        assertNotNull(applies);
        applies.forEach(a -> assertEquals(0, a.getAuditStatus()));
    }

    @Test
    @DisplayName("countPendingByStudentId_有待审批申请_返回大于0")
    void countPendingByStudentId_有待审批申请_返回大于0() {
        int count = moveApplyMapper.countPendingByStudentId(4L);

        assertTrue(count >= 0);
    }

    @Test
    @DisplayName("countPendingByStudentId_无待审批申请_返回0")
    void countPendingByStudentId_无待审批申请_返回0() {
        int count = moveApplyMapper.countPendingByStudentId(1L);

        assertEquals(0, count);
    }

    @Test
    @DisplayName("insert_新增调宿申请_返回自增ID")
    void insert_新增调宿申请_返回自增ID() {
        DormMoveApply apply = new DormMoveApply();
        apply.setStudentId(5L);
        apply.setOriginalBedId(2L);
        apply.setTargetBedId(3L);
        apply.setApplyReason("想换个床位");
        apply.setApplyTime(LocalDateTime.now());
        apply.setAuditStatus(0);

        int rows = moveApplyMapper.insert(apply);

        assertEquals(1, rows);
        assertNotNull(apply.getApplyId());
    }

    @Test
    @DisplayName("update_更新审批状态_返回影响行数")
    void update_更新审批状态_返回影响行数() {
        DormMoveApply apply = new DormMoveApply();
        apply.setApplyId(1L);
        apply.setAuditStatus(1);
        apply.setAuditorId(1L);
        apply.setAuditTime(LocalDateTime.now());
        apply.setAuditOpinion("同意");

        int rows = moveApplyMapper.update(apply);

        assertEquals(1, rows);
    }
}
