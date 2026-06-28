package com.huuc.dormitory.dao;

import com.huuc.dormitory.entity.DormLateReturn;
import com.huuc.dormitory.vo.LateReturnStatVO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 晚归记录Mapper接口
 */
public interface DormLateReturnMapper {

    /**
     * 根据ID查询晚归记录
     */
    DormLateReturn selectById(Long recordId);

    /**
     * 根据学生ID查询晚归记录列表
     */
    List<DormLateReturn> selectByStudentId(Long studentId);

    /**
     * 查询晚归记录列表
     */
    List<DormLateReturn> selectList(DormLateReturn query);

    /**
     * 根据楼栋ID查询晚归记录列表
     */
    List<DormLateReturn> selectByBuildingId(Long buildingId);

    /**
     * 插入晚归记录
     */
    int insert(DormLateReturn record);

    /**
     * 按楼栋月度统计晚归人次
     */
    List<LateReturnStatVO> selectMonthlyStats(@Param("managerId") Long managerId, @Param("yearMonth") String yearMonth);

    /**
     * 按学号模糊查询晚归记录列表
     */
    List<DormLateReturn> selectListByStudentNo(@Param("studentNo") String studentNo, @Param("buildingId") Long buildingId);
}
