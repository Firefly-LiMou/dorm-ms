<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- 角色类型常量 -->
<c:set var="ROLE_ADMIN" value="1" />
<c:set var="ROLE_DORM" value="2" />
<c:set var="ROLE_STUDENT" value="3" />
<c:set var="roleType" value="${sessionScope.loginUser.roleType}" />
<!-- 侧边栏 -->
<aside class="sidebar">
    <nav>
        <ul class="sidebar-menu">
            <%-- 管理员菜单 --%>
            <c:if test="${roleType == ROLE_ADMIN}">
                <!-- 系统管理 -->
                <li class="menu-item">
                    <a href="javascript:void(0)" class="menu-link">
                        <i class="fas fa-cog"></i>
                        <span class="menu-text">系统管理</span>
                        <i class="fas fa-chevron-right" style="font-size: 10px; margin-left: auto;"></i>
                    </a>
                    <ul class="submenu">
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/user/list" class="submenu-link">
                                <i class="fas fa-users"></i>
                                <span>用户管理</span>
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/log/list" class="submenu-link">
                                <i class="fas fa-history"></i>
                                <span>操作日志</span>
                            </a>
                        </li>
                    </ul>
                </li>

                <!-- 宿舍管理 -->
                <li class="menu-item">
                    <a href="javascript:void(0)" class="menu-link">
                        <i class="fas fa-building"></i>
                        <span class="menu-text">宿舍管理</span>
                        <i class="fas fa-chevron-right" style="font-size: 10px; margin-left: auto;"></i>
                    </a>
                    <ul class="submenu">
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/building/list" class="submenu-link">
                                <i class="fas fa-hotel"></i>
                                <span>楼栋管理</span>
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/room/list" class="submenu-link">
                                <i class="fas fa-door-open"></i>
                                <span>房间管理</span>
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/bed/list" class="submenu-link">
                                <i class="fas fa-bed"></i>
                                <span>床位管理</span>
                            </a>
                        </li>
                    </ul>
                </li>

                <!-- 入住管理 -->
                <li class="menu-item">
                    <a href="javascript:void(0)" class="menu-link">
                        <i class="fas fa-sign-in-alt"></i>
                        <span class="menu-text">入住管理</span>
                        <i class="fas fa-chevron-right" style="font-size: 10px; margin-left: auto;"></i>
                    </a>
                    <ul class="submenu">
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/checkin/list" class="submenu-link">
                                <i class="fas fa-clipboard-list"></i>
                                <span>入住登记</span>
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/move/list" class="submenu-link">
                                <i class="fas fa-exchange-alt"></i>
                                <span>调宿管理</span>
                            </a>
                        </li>
                    </ul>
                </li>

                <!-- 日常运维 -->
                <li class="menu-item">
                    <a href="javascript:void(0)" class="menu-link">
                        <i class="fas fa-tools"></i>
                        <span class="menu-text">日常运维</span>
                        <i class="fas fa-chevron-right" style="font-size: 10px; margin-left: auto;"></i>
                    </a>
                    <ul class="submenu">
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/repair/list" class="submenu-link">
                                <i class="fas fa-wrench"></i>
                                <span>报修管理</span>
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/late-return/list" class="submenu-link">
                                <i class="fas fa-moon"></i>
                                <span>晚归登记</span>
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/visitor/list" class="submenu-link">
                                <i class="fas fa-user-friends"></i>
                                <span>访客登记</span>
                            </a>
                        </li>
                    </ul>
                </li>
            </c:if>

            <%-- 宿管菜单 --%>
            <c:if test="${roleType == ROLE_DORM}">
                <!-- 宿舍信息 -->
                <li class="menu-item">
                    <a href="javascript:void(0)" class="menu-link">
                        <i class="fas fa-building"></i>
                        <span class="menu-text">宿舍信息</span>
                        <i class="fas fa-chevron-right" style="font-size: 10px; margin-left: auto;"></i>
                    </a>
                    <ul class="submenu">
                        <li>
                            <a href="${pageContext.request.contextPath}/dorm/building/list" class="submenu-link">
                                <i class="fas fa-hotel"></i>
                                <span>楼栋信息</span>
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/dorm/room/list" class="submenu-link">
                                <i class="fas fa-door-open"></i>
                                <span>房间信息</span>
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/dorm/bed/list" class="submenu-link">
                                <i class="fas fa-bed"></i>
                                <span>床位信息</span>
                            </a>
                        </li>
                    </ul>
                </li>

                <!-- 入住管理 -->
                <li class="menu-item">
                    <a href="javascript:void(0)" class="menu-link">
                        <i class="fas fa-sign-in-alt"></i>
                        <span class="menu-text">入住管理</span>
                        <i class="fas fa-chevron-right" style="font-size: 10px; margin-left: auto;"></i>
                    </a>
                    <ul class="submenu">
                        <li>
                            <a href="${pageContext.request.contextPath}/dorm/checkin/list" class="submenu-link">
                                <i class="fas fa-clipboard-list"></i>
                                <span>入住登记</span>
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/dorm/move/list" class="submenu-link">
                                <i class="fas fa-exchange-alt"></i>
                                <span>调宿审批</span>
                            </a>
                        </li>
                    </ul>
                </li>

                <!-- 日常运维 -->
                <li class="menu-item">
                    <a href="javascript:void(0)" class="menu-link">
                        <i class="fas fa-tools"></i>
                        <span class="menu-text">日常运维</span>
                        <i class="fas fa-chevron-right" style="font-size: 10px; margin-left: auto;"></i>
                    </a>
                    <ul class="submenu">
                        <li>
                            <a href="${pageContext.request.contextPath}/dorm/repair/list" class="submenu-link">
                                <i class="fas fa-wrench"></i>
                                <span>报修处理</span>
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/dorm/late-return/list" class="submenu-link">
                                <i class="fas fa-moon"></i>
                                <span>晚归登记</span>
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/dorm/visitor/list" class="submenu-link">
                                <i class="fas fa-user-friends"></i>
                                <span>访客登记</span>
                            </a>
                        </li>
                    </ul>
                </li>
            </c:if>

            <%-- 学生菜单 --%>
            <c:if test="${roleType == ROLE_STUDENT}">
                <!-- 个人中心 -->
                <li class="menu-item">
                    <a href="javascript:void(0)" class="menu-link">
                        <i class="fas fa-user"></i>
                        <span class="menu-text">个人中心</span>
                        <i class="fas fa-chevron-right" style="font-size: 10px; margin-left: auto;"></i>
                    </a>
                    <ul class="submenu">
                        <li>
                            <a href="${pageContext.request.contextPath}/student/user/info" class="submenu-link">
                                <i class="fas fa-id-card"></i>
                                <span>个人信息</span>
                            </a>
                        </li>
                        <li>
                            <a href="javascript:void(0)" class="submenu-link" onclick="showChangePasswordModal()">
                                <i class="fas fa-key"></i>
                                <span>修改密码</span>
                            </a>
                        </li>
                    </ul>
                </li>

                <!-- 住宿管理 -->
                <li class="menu-item">
                    <a href="javascript:void(0)" class="menu-link">
                        <i class="fas fa-home"></i>
                        <span class="menu-text">住宿管理</span>
                        <i class="fas fa-chevron-right" style="font-size: 10px; margin-left: auto;"></i>
                    </a>
                    <ul class="submenu">
                        <li>
                            <a href="${pageContext.request.contextPath}/student/checkin/info" class="submenu-link">
                                <i class="fas fa-bed"></i>
                                <span>住宿信息</span>
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/student/move/list" class="submenu-link">
                                <i class="fas fa-exchange-alt"></i>
                                <span>调宿申请</span>
                            </a>
                        </li>
                    </ul>
                </li>

                <!-- 日常服务 -->
                <li class="menu-item">
                    <a href="javascript:void(0)" class="menu-link">
                        <i class="fas fa-concierge-bell"></i>
                        <span class="menu-text">日常服务</span>
                        <i class="fas fa-chevron-right" style="font-size: 10px; margin-left: auto;"></i>
                    </a>
                    <ul class="submenu">
                        <li>
                            <a href="${pageContext.request.contextPath}/student/repair/list" class="submenu-link">
                                <i class="fas fa-wrench"></i>
                                <span>报修服务</span>
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/student/late-return/list" class="submenu-link">
                                <i class="fas fa-moon"></i>
                                <span>晚归记录</span>
                            </a>
                        </li>
                    </ul>
                </li>
            </c:if>
        </ul>
    </nav>

    <!-- 侧边栏折叠按钮 -->
    <button class="sidebar-toggle">
        <i class="fas fa-chevron-left"></i>
    </button>
</aside>
