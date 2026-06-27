package com.huuc.dormitory.service;

import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.dto.VisitorDTO;
import com.huuc.dormitory.entity.DormVisitor;
import com.huuc.dormitory.vo.VisitorVO;

/**
 * 访客服务接口
 */
public interface VisitorService {

    /**
     * 根据ID获取访客详情
     */
    VisitorVO getVisitorById(Long visitorId);

    /**
     * 分页查询访客列表
     */
    PageInfo<VisitorVO> getVisitorList(DormVisitor query, Integer pageNum, Integer pageSize);

    /**
     * 分页查询楼栋访客列表
     */
    PageInfo<VisitorVO> getVisitorsByBuildingId(Long buildingId, Integer pageNum, Integer pageSize);

    /**
     * 录入访客
     * 自动关联被访学生在住楼栋
     *
     * @param dto        访客参数（姓名、身份证、被访学生ID、来访时间、事由）
     * @param registrarId 登记人ID
     * @throws com.huuc.dormitory.common.exception.BusinessException 被访学生不存在、无在住记录
     */
    void addVisitor(VisitorDTO dto, Long registrarId);

    /**
     * 确认访客离开（记录离开时间）
     *
     * @param visitorId 访客记录ID
     * @throws com.huuc.dormitory.common.exception.BusinessException 记录不存在、访客已离开
     */
    void confirmLeave(Long visitorId);
}
