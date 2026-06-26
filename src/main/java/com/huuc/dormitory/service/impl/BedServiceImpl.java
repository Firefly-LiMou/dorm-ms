package com.huuc.dormitory.service.impl;

import com.huuc.dormitory.common.enums.BedStatusEnum;
import com.huuc.dormitory.common.exception.BusinessException;
import com.huuc.dormitory.dao.DormBedMapper;
import com.huuc.dormitory.dao.DormBuildingMapper;
import com.huuc.dormitory.dao.DormRoomMapper;
import com.huuc.dormitory.dto.BedDTO;
import com.huuc.dormitory.dto.BatchBedDTO;
import com.huuc.dormitory.entity.DormBed;
import com.huuc.dormitory.entity.DormBuilding;
import com.huuc.dormitory.entity.DormRoom;
import com.huuc.dormitory.service.BedService;
import com.huuc.dormitory.vo.BedVO;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

/**
 * 床位服务实现类
 */
@Service
public class BedServiceImpl implements BedService {

    @Autowired
    private DormBedMapper dormBedMapper;

    @Autowired
    private DormRoomMapper dormRoomMapper;

    @Autowired
    private DormBuildingMapper dormBuildingMapper;

    @Override
    public BedVO getBedById(Long bedId) {
        DormBed bed = dormBedMapper.selectById(bedId);
        if (bed == null) {
            throw new BusinessException("床位不存在");
        }
        return convertToVO(bed);
    }

    @Override
    public List<BedVO> getBedsByRoomId(Long roomId) {
        List<DormBed> beds = dormBedMapper.selectByRoomId(roomId);
        return convertToVOList(beds);
    }

    @Override
    public List<BedVO> getFreeBedsByRoomId(Long roomId) {
        List<DormBed> beds = dormBedMapper.selectFreeByRoomId(roomId);
        return convertToVOList(beds);
    }

    @Override
    @Transactional
    public void addBed(BedDTO dto, Long operatorId) {
        // 校验房间存在
        DormRoom room = dormRoomMapper.selectById(dto.getRoomId());
        if (room == null) {
            throw new BusinessException("房间不存在");
        }

        // 构建床位对象
        DormBed bed = new DormBed();
        bed.setBedNo(dto.getBedNo());
        bed.setRoomId(dto.getRoomId());
        bed.setBedStatus(BedStatusEnum.FREE.getCode());
        bed.setRemark(dto.getRemark());
        bed.setIsDeleted(0);

        dormBedMapper.insert(bed);
    }

    @Override
    @Transactional
    public void batchAddBeds(BatchBedDTO dto, Long operatorId) {
        // 校验房间存在
        DormRoom room = dormRoomMapper.selectById(dto.getRoomId());
        if (room == null) {
            throw new BusinessException("房间不存在");
        }

        // 校验床位数是否合法
        if (dto.getBedCount() <= 0) {
            throw new BusinessException("床位数量必须大于0");
        }

        // 生成床位列表
        List<DormBed> beds = new ArrayList<>();
        for (int i = 1; i <= dto.getBedCount(); i++) {
            DormBed bed = new DormBed();
            bed.setBedNo(i + "号床");
            bed.setRoomId(dto.getRoomId());
            bed.setBedStatus(BedStatusEnum.FREE.getCode());
            bed.setIsDeleted(0);
            beds.add(bed);
        }

        // 批量插入
        dormBedMapper.batchInsert(beds);
    }

    @Override
    @Transactional
    public void updateBedStatus(Long bedId, Integer status) {
        // 校验床位存在
        DormBed bed = dormBedMapper.selectById(bedId);
        if (bed == null) {
            throw new BusinessException("床位不存在");
        }

        // 校验状态值合法
        BedStatusEnum statusEnum = BedStatusEnum.getByCode(status);
        if (statusEnum == null) {
            throw new BusinessException("无效的床位状态");
        }

        dormBedMapper.updateStatus(bedId, status);
    }

    /**
     * 实体转VO
     */
    private BedVO convertToVO(DormBed bed) {
        BedVO vo = new BedVO();
        BeanUtils.copyProperties(bed, vo);

        // 查询房间信息
        DormRoom room = dormRoomMapper.selectById(bed.getRoomId());
        if (room != null) {
            vo.setRoomNo(room.getRoomNo());

            // 查询楼栋名称
            DormBuilding building = dormBuildingMapper.selectById(room.getBuildingId());
            if (building != null) {
                vo.setBuildingName(building.getBuildingName());
            }
        }

        // 设置床位状态文本
        BedStatusEnum statusEnum = BedStatusEnum.getByCode(bed.getBedStatus());
        if (statusEnum != null) {
            vo.setBedStatusText(statusEnum.getDesc());
        }

        return vo;
    }

    /**
     * 实体列表转VO列表
     */
    private List<BedVO> convertToVOList(List<DormBed> beds) {
        List<BedVO> voList = new ArrayList<>();
        for (DormBed bed : beds) {
            voList.add(convertToVO(bed));
        }
        return voList;
    }
}
