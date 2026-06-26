package com.huuc.dormitory.controller.admin;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.huuc.dormitory.common.aop.OperLog;
import com.huuc.dormitory.common.enums.OperTypeEnum;
import com.huuc.dormitory.common.result.Result;
import com.huuc.dormitory.common.validation.AddGroup;
import com.huuc.dormitory.common.validation.UpdateGroup;
import com.huuc.dormitory.dto.UserDTO;
import com.huuc.dormitory.entity.SysUser;
import com.huuc.dormitory.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 管理员端用户管理控制器
 */
@Controller
@RequestMapping("/admin/user")
public class AdminUserController {

    @Autowired
    private UserService userService;

    /**
     * 用户列表页面
     */
    @GetMapping("/list")
    public String listPage() {
        return "admin/user/list";
    }

    /**
     * 查询用户列表（分页）
     */
    @GetMapping("/page")
    @ResponseBody
    public Result<PageInfo<SysUser>> getUserPage(
            @RequestParam(required = false) String username,
            @RequestParam(required = false) String realName,
            @RequestParam(required = false) Integer roleType,
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {

        SysUser query = new SysUser();
        query.setUsername(username);
        query.setRealName(realName);
        query.setRoleType(roleType);
        query.setStatus(status);

        PageHelper.startPage(pageNum, pageSize);
        List<SysUser> users = userService.getUserList(query);
        PageInfo<SysUser> pageInfo = new PageInfo<>(users);

        return Result.success(pageInfo);
    }

    /**
     * 新增用户
     */
    @PostMapping("/add")
    @ResponseBody
    @OperLog(module = "用户管理", type = OperTypeEnum.ADD, desc = "新增用户")
    public Result<Void> addUser(@RequestBody @Validated(AddGroup.class) UserDTO dto) {
        userService.addUser(dto);
        return Result.success();
    }

    /**
     * 编辑用户
     */
    @PostMapping("/update")
    @ResponseBody
    @OperLog(module = "用户管理", type = OperTypeEnum.UPDATE, desc = "编辑用户")
    public Result<Void> updateUser(@RequestBody @Validated(UpdateGroup.class) UserDTO dto) {
        userService.updateUser(dto);
        return Result.success();
    }

    /**
     * 启用/禁用用户
     */
    @PostMapping("/toggleStatus/{userId}")
    @ResponseBody
    @OperLog(module = "用户管理", type = OperTypeEnum.UPDATE, desc = "切换用户状态")
    public Result<Void> toggleUserStatus(@PathVariable Long userId) {
        userService.toggleUserStatus(userId);
        return Result.success();
    }

    /**
     * 根据角色类型查询用户列表
     */
    @GetMapping("/list/{roleType}")
    @ResponseBody
    public Result<List<SysUser>> getUsersByRoleType(@PathVariable Integer roleType) {
        List<SysUser> users = userService.getUsersByRoleType(roleType);
        return Result.success(users);
    }
}
