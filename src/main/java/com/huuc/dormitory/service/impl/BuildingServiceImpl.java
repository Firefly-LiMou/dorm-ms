package com.huuc.dormitory.service.impl;

import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.common.exception.BusinessException;
import com.huuc.dormitory.dao.DormBuildingMapper;
import com.huuc.dormitory.dao.SysUserMapper;
import com.huuc.dormitory.dto.BuildingDTO;
import com.huuc.dormitory.entity.DormBuilding;
import com.huuc.dormitory.entity.SysUser;
import com.huuc.dormitory.service.BuildingService;
import com.huuc.dormitory.vo.BuildingVO;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

/**
 * 楼栋服务实现类
 */
@Service
public class BuildingServiceImpl implements BuildingService {

    @Autowired
    private DormBuildingMapper dormBuildingMapper;

    @Autowired
    private SysUserMapper sysUserMapper;

    @Override
    public BuildingVO getBuildingById(Long buildingId) {
        DormBuilding building = dormBuildingMapper.selectById(buildingId);
        if (building == null) {
            throw new BusinessException("楼栋不存在");
        }
        return convertToVO(building);
    }

    @Override
    public PageInfo<BuildingVO> getBuildingList(DormBuilding query, Integer pageNum, Integer pageSize) {
        List<DormBuilding> buildings = dormBuildingMapper.selectList(query);
        PageInfo<DormBuilding> pageInfo = new PageInfo<>(buildings);

        // 转换为VO
        PageInfo<BuildingVO> voPageInfo = new PageInfo<>();
        BeanUtils.copyProperties(pageInfo, voPageInfo);
        voPageInfo.setList(convertToVOList(buildings));

        return voPageInfo;
    }

    @Override
    public List<BuildingVO> getBuildingsByManagerId(Long managerId) {
        List<DormBuilding> buildings = dormBuildingMapper.selectByManagerId(managerId);
        return convertToVOList(buildings);
    }

    @Override
    @Transactional
    public void addBuilding(BuildingDTO dto, Long operatorId) {
        // 校验楼栋编号唯一性
        DormBuilding existBuilding = new DormBuilding();
        existBuilding.setBuildingNo(dto.getBuildingNo());
        List<DormBuilding> existList = dormBuildingMapper.selectList(existBuilding);
        if (!existList.isEmpty()) {
            throw new BusinessException("楼栋编号已存在");
        }

        // 构建楼栋对象
        DormBuilding building = new DormBuilding();
        building.setBuildingNo(dto.getBuildingNo());
        building.setBuildingName(dto.getBuildingName());
        building.setFloorCount(dto.getFloorCount());
        building.setArea(dto.getArea());
        building.setManagerId(dto.getManagerId());
        building.setRemark(dto.getRemark());
        building.setIsDeleted(0);

        dormBuildingMapper.insert(building);
    }

    @Override
    @Transactional
    public void updateBuilding(BuildingDTO dto, Long operatorId) {
        // 校验楼栋存在
        DormBuilding existBuilding = dormBuildingMapper.selectById(dto.getBuildingId());
        if (existBuilding == null) {
            throw new BusinessException("楼栋不存在");
        }

        // 校验楼栋编号唯一性（排除自身）
        DormBuilding query = new DormBuilding();
        query.setBuildingNo(dto.getBuildingNo());
        List<DormBuilding> existList = dormBuildingMapper.selectList(query);
        for (DormBuilding item : existList) {
            if (!item.getBuildingId().equals(dto.getBuildingId())) {
                throw new BusinessException("楼栋编号已存在");
            }
        }

        // 构建更新对象
        DormBuilding building = new DormBuilding();
        building.setBuildingId(dto.getBuildingId());
        building.setBuildingNo(dto.getBuildingNo());
        building.setBuildingName(dto.getBuildingName());
        building.setFloorCount(dto.getFloorCount());
        building.setArea(dto.getArea());
        building.setManagerId(dto.getManagerId());
        building.setRemark(dto.getRemark());

        dormBuildingMapper.update(building);
    }

    @Override
    @Transactional
    public void deleteBuilding(Long buildingId, Long operatorId) {
        // 校验楼栋存在
        DormBuilding building = dormBuildingMapper.selectById(buildingId);
        if (building == null) {
            throw new BusinessException("楼栋不存在");
        }

        // 校验楼栋下是否存在房间
        int roomCount = dormBuildingMapper.countRooms(buildingId);
        if (roomCount > 0) {
            throw new BusinessException("该楼栋下存在房间，无法删除");
        }

        // 逻辑删除
        dormBuildingMapper.updateDeleted(buildingId, 1);
    }

    /**
     * 实体转VO
     */
    private BuildingVO convertToVO(DormBuilding building) {
        BuildingVO vo = new BuildingVO();
        BeanUtils.copyProperties(building, vo);

        // 查询宿管姓名
        if (building.getManagerId() != null) {
            SysUser manager = sysUserMapper.selectById(building.getManagerId());
            if (manager != null) {
                vo.setManagerName(manager.getRealName());
            }
        }

        return vo;
    }

    /**
     * 实体列表转VO列表
     */
    private List<BuildingVO> convertToVOList(List<DormBuilding> buildings) {
        List<BuildingVO> voList = new ArrayList<>();
        for (DormBuilding building : buildings) {
            voList.add(convertToVO(building));
        }
        return voList;
    }
}
