<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>宿管首页 - 高校公寓管理系统</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/bootstrap/css/bootstrap.min.css">
    <!-- FontAwesome -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/fontawesome/css/all.min.css">
    <!-- 公共CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css">
</head>
<body>
    <div class="main-container">
        <!-- 侧边栏 -->
        <%@ include file="/WEB-INF/jsp/common/sidebar.jsp" %>

        <!-- 内容区域 -->
        <div class="content-wrapper">
            <!-- 导航栏 -->
            <%@ include file="/WEB-INF/jsp/common/header.jsp" %>

            <!-- 内容主体 -->
            <div class="content-body">
                <!-- 欢迎信息 -->
                <div class="mb-4">
                    <h4 style="color: #333; margin-bottom: 8px;">欢迎回来，${sessionScope.loginUser.realName}！</h4>
                    <p style="color: #666; margin: 0;">您当前的身份是：<span class="badge bg-success">宿管</span></p>
                </div>

                <!-- 统计卡片 -->
                <div class="row mb-4">
                    <div class="col-md-4 col-sm-6 mb-3">
                        <div class="card" style="border-left: 4px solid #007bff;">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="card-title text-muted mb-1">负责楼栋</h6>
                                        <h3 class="mb-0" id="buildingCount">--</h3>
                                    </div>
                                    <div style="font-size: 40px; color: #007bff; opacity: 0.3;">
                                        <i class="fas fa-building"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 col-sm-6 mb-3">
                        <div class="card" style="border-left: 4px solid #ffc107;">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="card-title text-muted mb-1">待处理报修</h6>
                                        <h3 class="mb-0" id="repairCount">--</h3>
                                    </div>
                                    <div style="font-size: 40px; color: #ffc107; opacity: 0.3;">
                                        <i class="fas fa-wrench"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 col-sm-6 mb-3">
                        <div class="card" style="border-left: 4px solid #dc3545;">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="card-title text-muted mb-1">本月晚归</h6>
                                        <h3 class="mb-0" id="lateReturnCount">--</h3>
                                    </div>
                                    <div style="font-size: 40px; color: #dc3545; opacity: 0.3;">
                                        <i class="fas fa-moon"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 快捷操作 -->
                <div class="row">
                    <div class="col-md-6 mb-4">
                        <div class="card">
                            <div class="card-header bg-white">
                                <h6 class="mb-0"><i class="fas fa-tachometer-alt mr-2"></i>快捷操作</h6>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-6 mb-3">
                                        <a href="${pageContext.request.contextPath}/dorm/checkin/list" class="btn btn-outline-primary w-100">
                                            <i class="fas fa-clipboard-list mr-2"></i>入住登记
                                        </a>
                                    </div>
                                    <div class="col-6 mb-3">
                                        <a href="${pageContext.request.contextPath}/dorm/repair/list" class="btn btn-outline-warning w-100">
                                            <i class="fas fa-wrench mr-2"></i>报修处理
                                        </a>
                                    </div>
                                    <div class="col-6 mb-3">
                                        <a href="${pageContext.request.contextPath}/dorm/late-return/list" class="btn btn-outline-info w-100">
                                            <i class="fas fa-moon mr-2"></i>晚归登记
                                        </a>
                                    </div>
                                    <div class="col-6 mb-3">
                                        <a href="${pageContext.request.contextPath}/dorm/visitor/list" class="btn btn-outline-success w-100">
                                            <i class="fas fa-user-friends mr-2"></i>访客登记
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 mb-4">
                        <div class="card">
                            <div class="card-header bg-white">
                                <h6 class="mb-0"><i class="fas fa-clock mr-2"></i>系统信息</h6>
                            </div>
                            <div class="card-body">
                                <ul class="list-unstyled mb-0">
                                    <li class="mb-2">
                                        <i class="fas fa-calendar-alt mr-2 text-muted"></i>
                                        <span class="text-muted">当前时间：</span>
                                        <span id="currentTime"></span>
                                    </li>
                                    <li class="mb-2">
                                        <i class="fas fa-user mr-2 text-muted"></i>
                                        <span class="text-muted">登录账号：</span>
                                        <span>${sessionScope.loginUser.username}</span>
                                    </li>
                                    <li class="mb-2">
                                        <i class="fas fa-shield-alt mr-2 text-muted"></i>
                                        <span class="text-muted">角色权限：</span>
                                        <span class="badge bg-success">宿管</span>
                                    </li>
                                    <li>
                                        <i class="fas fa-info-circle mr-2 text-muted"></i>
                                        <span class="text-muted">系统版本：</span>
                                        <span>v1.0.0</span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 底部 -->
            <%@ include file="/WEB-INF/jsp/common/footer.jsp" %>
        </div>
    </div>

    <!-- jQuery -->
    <script src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
    <!-- Bootstrap JS -->
    <script src="${pageContext.request.contextPath}/static/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <!-- 公共JS -->
    <script src="${pageContext.request.contextPath}/static/js/common.js"></script>
    <!-- 导航栏JS -->
    <script>window.needChangePasswordFlag = '${sessionScope.needChangePassword}';</script>
    <script src="${pageContext.request.contextPath}/static/js/header.js"></script>

    <script>
        $(function() {
            // 更新当前时间
            function updateTime() {
                var now = new Date();
                var timeStr = $.formatDate(now, 'yyyy-MM-dd HH:mm:ss');
                $('#currentTime').text(timeStr);
            }
            updateTime();
            setInterval(updateTime, 60000);

            // 加载统计数据
            loadStatistics();
        });

        /**
         * 设置统计卡片加载失败状态
         * @param {string} elementId - 卡片元素ID
         */
        function setLoadError(elementId) {
            $('#' + elementId).html('<a href="javascript:void(0)" onclick="loadStatistics()" style="color: #dc3545; font-size: 14px;">加载失败，点击重试</a>');
        }

        /**
         * 加载统计数据
         */
        function loadStatistics() {
            // 负责楼栋
            $('#buildingCount').text('加载中...');
            $.ajaxRequest('/dorm/building/list', 'GET', {}, function(result) {
                if (result.data) {
                    $('#buildingCount').text(result.data.length || 0);
                } else {
                    $('#buildingCount').text('0');
                }
            }, function(result) {
                if (result.msg && result.msg.indexOf('未负责任何楼栋') !== -1) {
                    $('#buildingCount').html('<span style="font-size: 14px; color: #ffc107;">未分配楼栋</span>');
                } else {
                    setLoadError('buildingCount');
                }
            });

            // 待处理报修
            $('#repairCount').text('加载中...');
            $.ajaxRequest('/dorm/repair/page', 'GET', { repairStatus: 0, pageSize: 1 }, function(result) {
                $('#repairCount').text(result.data.total || 0);
            }, function(result) {
                if (result.msg && result.msg.indexOf('未负责任何楼栋') !== -1) {
                    $('#repairCount').html('<span style="font-size: 14px; color: #ffc107;">-</span>');
                } else {
                    setLoadError('repairCount');
                }
            });

            // 本月晚归
            $('#lateReturnCount').text('加载中...');
            $.ajaxRequest('/dorm/late-return/stats', 'GET', {}, function(result) {
                if (result.data) {
                    var total = 0;
                    result.data.forEach(function(item) {
                        total += item.count || 0;
                    });
                    $('#lateReturnCount').text(total);
                } else {
                    $('#lateReturnCount').text('0');
                }
            }, function(result) {
                if (result.msg && result.msg.indexOf('未负责任何楼栋') !== -1) {
                    $('#lateReturnCount').html('<span style="font-size: 14px; color: #ffc107;">-</span>');
                } else {
                    setLoadError('lateReturnCount');
                }
            });
        }
    </script>
</body>
</html>
