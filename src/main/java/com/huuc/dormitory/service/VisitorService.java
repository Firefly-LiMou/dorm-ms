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
     */
    void addVisitor(VisitorDTO dto, Long registrarId);

    /**
     * 确认离开
     */
    void confirmLeave(Long visitorId);
}
