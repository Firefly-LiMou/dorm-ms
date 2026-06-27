package com.huuc.dormitory.service.impl;

import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.common.exception.BusinessException;
import com.huuc.dormitory.dao.*;
import com.huuc.dormitory.dto.LateReturnDTO;
import com.huuc.dormitory.entity.*;
import com.huuc.dormitory.service.LateReturnService;
import com.huuc.dormitory.vo.LateReturnStatVO;
import com.huuc.dormitory.vo.LateReturnVO;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

/**
 * 晚归服务实现类
 */
@Service
public class LateReturnServiceImpl implements LateReturnService {

    @Autowired
    private DormLateReturnMapper lateReturnMapper;

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
    public LateReturnVO getRecordById(Long recordId) {
        DormLateReturn record = lateReturnMapper.selectById(recordId);
        if (record == null) {
            throw new BusinessException(BusinessException.CODE_NOT_FOUND, "晚归记录不存在");
        }
        return convertToVO(record);
    }

    @Override
    public PageInfo<LateReturnVO> getRecordList(DormLateReturn query, Integer pageNum, Integer pageSize) {
        List<DormLateReturn> records = lateReturnMapper.selectList(query);
        PageInfo<DormLateReturn> pageInfo = new PageInfo<>(records);

        PageInfo<LateReturnVO> voPageInfo = new PageInfo<>();
        BeanUtils.copyProperties(pageInfo, voPageInfo);
        voPageInfo.setList(convertToVOList(records));

        return voPageInfo;
    }

    @Override
    public PageInfo<LateReturnVO> getMyRecords(Long studentId, Integer pageNum, Integer pageSize) {
        List<DormLateReturn> records = lateReturnMapper.selectByStudentId(studentId);
        PageInfo<DormLateReturn> pageInfo = new PageInfo<>(records);

        PageInfo<LateReturnVO> voPageInfo = new PageInfo<>();
        BeanUtils.copyProperties(pageInfo, voPageInfo);
        voPageInfo.setList(convertToVOList(records));

        return voPageInfo;
    }

    @Override
    public PageInfo<LateReturnVO> getRecordsByBuildingId(Long buildingId, Integer pageNum, Integer pageSize) {
        List<DormLateReturn> records = lateReturnMapper.selectByBuildingId(buildingId);
        PageInfo<DormLateReturn> pageInfo = new PageInfo<>(records);

        PageInfo<LateReturnVO> voPageInfo = new PageInfo<>();
        BeanUtils.copyProperties(pageInfo, voPageInfo);
        voPageInfo.setList(convertToVOList(records));

        return voPageInfo;
    }

    /**
     * 录入晚归记录
     * 自动关联学生在住楼栋
     */
    @Override
    @Transactional
    public void addRecord(LateReturnDTO dto, Long registrarId) {
        // 校验学生存在
        SysUser student = userMapper.selectById(dto.getStudentId());
        if (student == null) {
            throw new BusinessException(BusinessException.CODE_NOT_FOUND, "学生不存在");
        }

        // 自动查询学生在住记录获取building_id
        DormCheckinRecord checkinRecord = checkinRecordMapper.selectActiveByStudentId(dto.getStudentId());
        if (checkinRecord == null) {
            throw new BusinessException(BusinessException.CODE_BAD_REQUEST, "该学生当前无在住记录");
        }

        // 通过床位查询房间，再查询楼栋
        DormBed bed = bedMapper.selectById(checkinRecord.getBedId());
        if (bed == null) {
            throw new BusinessException(BusinessException.CODE_ERROR, "床位信息异常");
        }
        DormRoom room = roomMapper.selectById(bed.getRoomId());
        if (room == null) {
            throw new BusinessException(BusinessException.CODE_ERROR, "房间信息异常");
        }

        // 插入晚归记录
        DormLateReturn record = new DormLateReturn();
        record.setStudentId(dto.getStudentId());
        record.setBuildingId(room.getBuildingId());
        record.setLateTime(dto.getLateTime());
        record.setLateReason(dto.getLateReason());
        record.setRegistrarId(registrarId);
        record.setRecordTime(LocalDateTime.now());
        lateReturnMapper.insert(record);
    }

    @Override
    public List<LateReturnStatVO> getMonthlyStats(Long managerId, String yearMonth) {
        return lateReturnMapper.selectMonthlyStats(managerId, yearMonth);
    }

    /**
     * 实体转VO
     */
    private LateReturnVO convertToVO(DormLateReturn record) {
        LateReturnVO vo = new LateReturnVO();
        BeanUtils.copyProperties(record, vo);

        // 查询学生信息
        SysUser student = userMapper.selectById(record.getStudentId());
        if (student != null) {
            vo.setStudentName(student.getRealName());
            vo.setStudentNo(student.getUsername());
        }

        // 查询楼栋信息
        DormBuilding building = buildingMapper.selectById(record.getBuildingId());
        if (building != null) {
            vo.setBuildingName(building.getBuildingName());
        }

        // 查询登记人信息
        SysUser registrar = userMapper.selectById(record.getRegistrarId());
        if (registrar != null) {
            vo.setRegistrarName(registrar.getRealName());
        }

        return vo;
    }

    /**
     * 实体列表转VO列表
     */
    private List<LateReturnVO> convertToVOList(List<DormLateReturn> records) {
        List<LateReturnVO> voList = new ArrayList<>();
        for (DormLateReturn record : records) {
            voList.add(convertToVO(record));
        }
        return voList;
    }
}
