<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- 角色类型常量 -->
<c:set var="ROLE_ADMIN" value="1" />
<c:set var="ROLE_DORM" value="2" />
<c:set var="ROLE_STUDENT" value="3" />
<!-- 导航栏 -->
<nav class="navbar">
    <!-- 左侧：Logo和标题 -->
    <div class="navbar-brand">
        <a href="${pageContext.request.contextPath}/" class="d-flex align-items-center gap-2">
            <i class="fas fa-building" style="font-size: 24px; color: #007bff;"></i>
            <span>高校公寓管理系统</span>
        </a>
        <!-- 移动端侧边栏切换按钮 -->
        <button class="navbar-toggler d-md-none" style="background: none; border: none; padding: 8px; cursor: pointer;">
            <i class="fas fa-bars" style="font-size: 20px;"></i>
        </button>
    </div>

    <!-- 右侧：用户信息 -->
    <div class="navbar-nav">
        <c:if test="${not empty sessionScope.loginUser}">
            <!-- 用户信息 -->
            <div class="user-dropdown">
                <a href="javascript:void(0)" class="nav-link">
                    <i class="fas fa-user-circle"></i>
                    <span>${sessionScope.loginUser.realName}</span>
                    <c:choose>
                        <c:when test="${sessionScope.loginUser.roleType == ROLE_ADMIN}">
                            <span class="badge bg-primary" style="font-size: 11px;">管理员</span>
                        </c:when>
                        <c:when test="${sessionScope.loginUser.roleType == ROLE_DORM}">
                            <span class="badge bg-success" style="font-size: 11px;">宿管</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-info" style="font-size: 11px;">学生</span>
                        </c:otherwise>
                    </c:choose>
                    <i class="fas fa-chevron-down" style="font-size: 10px; margin-left: 4px;"></i>
                </a>
                <div class="dropdown-menu">
                    <a href="javascript:void(0)" class="dropdown-item" onclick="showChangePasswordModal(false)">
                        <i class="fas fa-key"></i> 修改密码
                    </a>
                    <div style="border-top: 1px solid #e0e0e0; margin: 4px 0;"></div>
                    <a href="javascript:void(0)" class="dropdown-item btn-logout">
                        <i class="fas fa-sign-out-alt"></i> 退出登录
                    </a>
                </div>
            </div>
        </c:if>
    </div>
</nav>

<!-- 修改密码模态框 -->
<div class="modal fade" id="changePasswordModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">修改密码</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" id="btnClosePasswordModal"></button>
            </div>
            <div class="modal-body">
                <div id="forceChangeTip" class="alert alert-warning" style="display: none;">
                    首次登录需要修改密码，请先设置新密码。
                </div>
                <form id="changePasswordForm">
                    <div class="mb-3">
                        <label for="newPassword" class="form-label">新密码</label>
                        <input type="password" class="form-control" id="newPassword" placeholder="请输入新密码（6-20个字符）" maxlength="20">
                        <div class="invalid-feedback" id="newPasswordError"></div>
                    </div>
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">确认密码</label>
                        <input type="password" class="form-control" id="confirmPassword" placeholder="请再次输入新密码" maxlength="20">
                        <div class="invalid-feedback" id="confirmPasswordError"></div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" id="btnSubmitPassword">确认修改</button>
            </div>
        </div>
    </div>
</div>
