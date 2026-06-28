package com.huuc.dormitory.dao;

import com.huuc.dormitory.entity.DormMoveApply;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 调宿申请Mapper接口
 */
public interface DormMoveApplyMapper {

    /**
     * 根据ID查询调宿申请
     */
    DormMoveApply selectById(Long applyId);

    /**
     * 根据学生ID查询调宿申请列表
     */
    List<DormMoveApply> selectByStudentId(Long studentId);

    /**
     * 查询调宿申请列表
     */
    List<DormMoveApply> selectList(DormMoveApply query);

    /**
     * 根据楼栋ID查询调宿申请
     */
    List<DormMoveApply> selectByBuildingId(Long buildingId);

    /**
     * 插入调宿申请
     */
    int insert(DormMoveApply apply);

    /**
     * 更新调宿申请
     */
    int update(DormMoveApply apply);

    /**
     * 统计学生待审批申请数
     */
    int countPendingByStudentId(Long studentId);

    /**
     * 按学号模糊查询调宿申请列表
     */
    List<DormMoveApply> selectListByStudentNo(@Param("studentNo") String studentNo, @Param("auditStatus") Integer auditStatus);

    /**
     * 按学号模糊查询本楼栋调宿申请列表
     */
    List<DormMoveApply> selectListByStudentNoAndBuildingId(@Param("studentNo") String studentNo, @Param("buildingId") Long buildingId, @Param("auditStatus") Integer auditStatus);

    /**
     * 按楼栋查询调宿申请列表
     */
    List<DormMoveApply> selectListByBuildingId(@Param("buildingId") Long buildingId, @Param("auditStatus") Integer auditStatus);
}
