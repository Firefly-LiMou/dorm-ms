<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
                        <c:when test="${sessionScope.loginUser.roleType == 1}">
                            <span class="badge bg-primary" style="font-size: 11px;">管理员</span>
                        </c:when>
                        <c:when test="${sessionScope.loginUser.roleType == 2}">
                            <span class="badge bg-success" style="font-size: 11px;">宿管</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-info" style="font-size: 11px;">学生</span>
                        </c:otherwise>
                    </c:choose>
                    <i class="fas fa-chevron-down" style="font-size: 10px; margin-left: 4px;"></i>
                </a>
                <div class="dropdown-menu">
                    <c:choose>
                        <c:when test="${sessionScope.loginUser.roleType == 3}">
                            <a href="${pageContext.request.contextPath}/student/user/password" class="dropdown-item">
                                <i class="fas fa-key"></i> 修改密码
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="javascript:void(0)" class="dropdown-item" onclick="showChangePasswordModal()">
                                <i class="fas fa-key"></i> 修改密码
                            </a>
                        </c:otherwise>
                    </c:choose>
                    <div style="border-top: 1px solid #e0e0e0; margin: 4px 0;"></div>
                    <a href="javascript:void(0)" class="dropdown-item btn-logout">
                        <i class="fas fa-sign-out-alt"></i> 退出登录
                    </a>
                </div>
            </div>
        </c:if>
    </div>
</nav>
