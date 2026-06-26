package com.huuc.dormitory.service.impl;

import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.common.exception.BusinessException;
import com.huuc.dormitory.dao.*;
import com.huuc.dormitory.dto.VisitorDTO;
import com.huuc.dormitory.entity.*;
import com.huuc.dormitory.service.VisitorService;
import com.huuc.dormitory.vo.VisitorVO;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * 访客服务实现类
 */
@Service
public class VisitorServiceImpl implements VisitorService {

    @Autowired
    private DormVisitorMapper visitorMapper;

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
    public VisitorVO getVisitorById(Long visitorId) {
        DormVisitor visitor = visitorMapper.selectById(visitorId);
        if (visitor == null) {
            throw new BusinessException("访客记录不存在");
        }
        return convertToVO(visitor);
    }

    @Override
    public PageInfo<VisitorVO> getVisitorList(DormVisitor query, Integer pageNum, Integer pageSize) {
        List<DormVisitor> visitors = visitorMapper.selectList(query);
        PageInfo<DormVisitor> pageInfo = new PageInfo<>(visitors);

        PageInfo<VisitorVO> voPageInfo = new PageInfo<>();
        BeanUtils.copyProperties(pageInfo, voPageInfo);
        voPageInfo.setList(convertToVOList(visitors));

        return voPageInfo;
    }

    @Override
    public PageInfo<VisitorVO> getVisitorsByBuildingId(Long buildingId, Integer pageNum, Integer pageSize) {
        List<DormVisitor> visitors = visitorMapper.selectByBuildingId(buildingId);
        PageInfo<DormVisitor> pageInfo = new PageInfo<>(visitors);

        PageInfo<VisitorVO> voPageInfo = new PageInfo<>();
        BeanUtils.copyProperties(pageInfo, voPageInfo);
        voPageInfo.setList(convertToVOList(visitors));

        return voPageInfo;
    }

    @Override
    @Transactional
    public void addVisitor(VisitorDTO dto, Long registrarId) {
        // 校验被访学生存在
        SysUser student = userMapper.selectById(dto.getStudentId());
        if (student == null) {
            throw new BusinessException("被访学生不存在");
        }

        // 自动查询被访学生在住记录获取building_id
        DormCheckinRecord checkinRecord = checkinRecordMapper.selectActiveByStudentId(dto.getStudentId());
        if (checkinRecord == null) {
            throw new BusinessException("被访学生当前无在住记录");
        }

        // 通过床位查询房间，再查询楼栋
        DormBed bed = bedMapper.selectById(checkinRecord.getBedId());
        if (bed == null) {
            throw new BusinessException("床位信息异常");
        }
        DormRoom room = roomMapper.selectById(bed.getRoomId());
        if (room == null) {
            throw new BusinessException("房间信息异常");
        }

        // 插入访客记录
        DormVisitor visitor = new DormVisitor();
        visitor.setVisitorName(dto.getVisitorName());
        visitor.setIdCard(dto.getIdCard());
        visitor.setStudentId(dto.getStudentId());
        visitor.setBuildingId(room.getBuildingId());
        visitor.setVisitTime(dto.getVisitTime());
        visitor.setVisitReason(dto.getVisitReason());
        visitor.setRegistrarId(registrarId);
        visitorMapper.insert(visitor);
    }

    @Override
    @Transactional
    public void confirmLeave(Long visitorId) {
        // 校验访客记录存在且未离开
        DormVisitor visitor = visitorMapper.selectById(visitorId);
        if (visitor == null) {
            throw new BusinessException("访客记录不存在");
        }
        if (visitor.getLeaveTime() != null) {
            throw new BusinessException("该访客已离开");
        }

        // 更新离开时间为当前系统时间
        visitorMapper.updateLeaveTime(visitorId, LocalDateTime.now());
    }

    /**
     * 实体转VO
     */
    private VisitorVO convertToVO(DormVisitor visitor) {
        VisitorVO vo = new VisitorVO();
        BeanUtils.copyProperties(visitor, vo);

        // 身份证号脱敏
        if (visitor.getIdCard() != null && visitor.getIdCard().length() == 18) {
            vo.setIdCard(visitor.getIdCard().substring(0, 6) + "********" + visitor.getIdCard().substring(14));
        }

        // 查询被访学生信息
        SysUser student = userMapper.selectById(visitor.getStudentId());
        if (student != null) {
            vo.setStudentName(student.getRealName());
        }

        // 查询楼栋信息
        DormBuilding building = buildingMapper.selectById(visitor.getBuildingId());
        if (building != null) {
            vo.setBuildingName(building.getBuildingName());
        }

        // 查询登记人信息
        SysUser registrar = userMapper.selectById(visitor.getRegistrarId());
        if (registrar != null) {
            vo.setRegistrarName(registrar.getRealName());
        }

        // 设置状态
        vo.setStatus(visitor.getLeaveTime() != null ? "已离开" : "在访");

        return vo;
    }

    /**
     * 实体列表转VO列表
     */
    private List<VisitorVO> convertToVOList(List<DormVisitor> visitors) {
        List<VisitorVO> voList = new ArrayList<>();
        for (DormVisitor visitor : visitors) {
            voList.add(convertToVO(visitor));
        }
        return voList;
    }
}
