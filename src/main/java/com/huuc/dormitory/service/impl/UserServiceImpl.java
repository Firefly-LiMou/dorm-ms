package com.huuc.dormitory.service.impl;

import com.huuc.dormitory.common.enums.UserStatusEnum;
import com.huuc.dormitory.common.exception.BusinessException;
import com.huuc.dormitory.common.utils.Md5Util;
import com.huuc.dormitory.dao.SysUserMapper;
import com.huuc.dormitory.dto.LoginDTO;
import com.huuc.dormitory.dto.PasswordDTO;
import com.huuc.dormitory.dto.UserDTO;
import com.huuc.dormitory.entity.SysUser;
import com.huuc.dormitory.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 用户服务实现类
 */
@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private SysUserMapper sysUserMapper;

    @Override
    public SysUser login(LoginDTO dto) {
        // 根据用户名查询用户
        SysUser user = sysUserMapper.selectByUsername(dto.getUsername());
        if (user == null) {
            throw new BusinessException(BusinessException.CODE_UNAUTHORIZED, "用户名或密码错误");
        }

        // 验证密码
        if (!Md5Util.verify(dto.getPassword(), user.getPassword())) {
            throw new BusinessException(BusinessException.CODE_UNAUTHORIZED, "用户名或密码错误");
        }

        // 验证账号状态
        if (UserStatusEnum.DISABLED.getCode().equals(user.getStatus())) {
            throw new BusinessException(BusinessException.CODE_UNAUTHORIZED, "账号已被禁用，请联系管理员");
        }

        // 清除密码后返回
        user.setPassword(null);
        return user;
    }

    @Override
    public SysUser getUserById(Long userId) {
        SysUser user = sysUserMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException(BusinessException.CODE_NOT_FOUND, "用户不存在");
        }
        // 清除密码后返回
        user.setPassword(null);
        return user;
    }

    @Override
    @Transactional
    public void updatePassword(PasswordDTO dto, Long userId) {
        // 验证两次密码是否一致
        if (!dto.getNewPassword().equals(dto.getConfirmPassword())) {
            throw new BusinessException(BusinessException.CODE_BAD_REQUEST, "两次输入的密码不一致");
        }

        // 加密密码
        String encryptedPassword = Md5Util.encrypt(dto.getNewPassword());

        // 更新密码
        int rows = sysUserMapper.updatePassword(userId, encryptedPassword);
        if (rows == 0) {
            throw new BusinessException(BusinessException.CODE_ERROR, "修改密码失败");
        }
    }

    @Override
    @Transactional
    public void updatePhone(String phone, Long userId) {
        SysUser user = new SysUser();
        user.setUserId(userId);
        user.setPhone(phone);
        sysUserMapper.update(user);
    }

    /**
     * 新增用户
     * 自动生成默认密码（huuc+手机号）
     */
    @Override
    @Transactional
    public void addUser(UserDTO dto) {
        // 参数校验
        if (dto.getUsername() == null || dto.getUsername().trim().isEmpty()) {
            throw new BusinessException(BusinessException.CODE_BAD_REQUEST, "用户名不能为空");
        }

        // 验证用户名唯一性
        SysUser existUser = sysUserMapper.selectByUsername(dto.getUsername());
        if (existUser != null) {
            throw new BusinessException(BusinessException.CODE_CONFLICT, "用户名已存在");
        }

        // 构建用户对象
        SysUser user = new SysUser();
        user.setUsername(dto.getUsername());
        user.setRealName(dto.getRealName());
        user.setRoleType(dto.getRoleType());
        user.setGender(dto.getGender());
        user.setPhone(dto.getPhone());
        user.setGrade(dto.getGrade());
        user.setMajor(dto.getMajor());
        user.setClassName(dto.getClassName());
        user.setStatus(UserStatusEnum.NORMAL.getCode());

        // 生成默认密码：huuc+手机号
        String defaultPassword = generateDefaultPassword(dto.getPhone());
        user.setPassword(Md5Util.encrypt(defaultPassword));

        sysUserMapper.insert(user);
    }

    @Override
    @Transactional
    public void updateUser(UserDTO dto) {
        // 参数校验
        if (dto.getUserId() == null) {
            throw new BusinessException(BusinessException.CODE_BAD_REQUEST, "用户ID不能为空");
        }

        // 验证用户存在
        SysUser existUser = sysUserMapper.selectById(dto.getUserId());
        if (existUser == null) {
            throw new BusinessException(BusinessException.CODE_NOT_FOUND, "用户不存在");
        }

        // 构建更新对象
        SysUser user = new SysUser();
        user.setUserId(dto.getUserId());
        user.setRealName(dto.getRealName());
        user.setRoleType(dto.getRoleType());
        user.setGender(dto.getGender());
        user.setPhone(dto.getPhone());
        user.setGrade(dto.getGrade());
        user.setMajor(dto.getMajor());
        user.setClassName(dto.getClassName());
        if (dto.getStatus() != null) {
            user.setStatus(dto.getStatus());
        }

        sysUserMapper.update(user);
    }

    /**
     * 启用/禁用用户（状态切换）
     */
    @Override
    @Transactional
    public void toggleUserStatus(Long userId) {
        SysUser user = sysUserMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException(BusinessException.CODE_NOT_FOUND, "用户不存在");
        }

        // 切换状态
        Integer newStatus = UserStatusEnum.NORMAL.getCode().equals(user.getStatus())
                ? UserStatusEnum.DISABLED.getCode()
                : UserStatusEnum.NORMAL.getCode();

        sysUserMapper.updateStatus(userId, newStatus);
    }

    @Override
    public List<SysUser> getUserList(SysUser query) {
        List<SysUser> users = sysUserMapper.selectList(query);
        // 清除密码
        users.forEach(u -> u.setPassword(null));
        return users;
    }

    @Override
    public List<SysUser> getUsersByRoleType(Integer roleType) {
        List<SysUser> users = sysUserMapper.selectByRoleType(roleType);
        // 清除密码
        users.forEach(u -> u.setPassword(null));
        return users;
    }

    @Override
    public boolean needChangePassword(SysUser user) {
        if (user == null || user.getPassword() == null) {
            return false;
        }
        // 查询完整用户信息（包含密码）
        SysUser fullUser = sysUserMapper.selectById(user.getUserId());
        if (fullUser == null) {
            return false;
        }
        // 生成默认密码：huuc+手机号
        String defaultPassword = generateDefaultPassword(fullUser.getPhone());
        // 比对密码是否等于默认密码
        return Md5Util.verify(defaultPassword, fullUser.getPassword());
    }

    /**
     * 生成默认密码：huuc+手机号
     *
     * @param phone 手机号
     * @return 默认密码明文
     */
    private String generateDefaultPassword(String phone) {
        if (phone == null) {
            phone = "";
        }
        return "huuc" + phone;
    }
}
