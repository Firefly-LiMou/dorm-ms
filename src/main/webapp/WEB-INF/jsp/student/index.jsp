<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>学生首页 - 高校公寓管理系统</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/bootstrap/css/bootstrap.min.css">
    <!-- FontAwesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- 公共CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css">
</head>
<body>
    <div class="main-container">
        <!-- 内容区域 -->
        <div class="content-wrapper">
            <!-- 导航栏 -->
            <%@ include file="/WEB-INF/jsp/common/header.jsp" %>

            <!-- 内容主体 -->
            <div class="content-body">
                <!-- 欢迎信息 -->
                <div class="mb-4">
                    <h4 style="color: #333; margin-bottom: 8px;">欢迎回来，${sessionScope.loginUser.realName}！</h4>
                    <p style="color: #666; margin: 0;">您当前的身份是：<span class="badge bg-info">学生</span></p>
                </div>

                <!-- 个人信息卡片 -->
                <div class="row mb-4">
                    <div class="col-md-8">
                        <div class="card">
                            <div class="card-header bg-white">
                                <h6 class="mb-0"><i class="fas fa-user mr-2"></i>个人信息</h6>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <ul class="list-unstyled mb-0">
                                            <li class="mb-2">
                                                <span class="text-muted">学号：</span>
                                                <span>${sessionScope.loginUser.username}</span>
                                            </li>
                                            <li class="mb-2">
                                                <span class="text-muted">姓名：</span>
                                                <span>${sessionScope.loginUser.realName}</span>
                                            </li>
                                            <li class="mb-2">
                                                <span class="text-muted">性别：</span>
                                                <span>${sessionScope.loginUser.gender == 1 ? '男' : '女'}</span>
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="col-md-6">
                                        <ul class="list-unstyled mb-0">
                                            <li class="mb-2">
                                                <span class="text-muted">年级：</span>
                                                <span>${sessionScope.loginUser.grade}</span>
                                            </li>
                                            <li class="mb-2">
                                                <span class="text-muted">专业：</span>
                                                <span>${sessionScope.loginUser.major}</span>
                                            </li>
                                            <li class="mb-2">
                                                <span class="text-muted">班级：</span>
                                                <span>${sessionScope.loginUser.className}</span>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card" style="border-left: 4px solid #007bff;">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="card-title text-muted mb-1">住宿状态</h6>
                                        <h5 class="mb-0" id="checkinStatus">--</h5>
                                    </div>
                                    <div style="font-size: 40px; color: #007bff; opacity: 0.3;">
                                        <i class="fas fa-bed"></i>
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
                                        <a href="${pageContext.request.contextPath}/student/checkin/info" class="btn btn-outline-primary w-100">
                                            <i class="fas fa-bed mr-2"></i>住宿信息
                                        </a>
                                    </div>
                                    <div class="col-6 mb-3">
                                        <a href="${pageContext.request.contextPath}/student/move/list" class="btn btn-outline-info w-100">
                                            <i class="fas fa-exchange-alt mr-2"></i>调宿申请
                                        </a>
                                    </div>
                                    <div class="col-6 mb-3">
                                        <a href="${pageContext.request.contextPath}/student/repair/submit" class="btn btn-outline-warning w-100">
                                            <i class="fas fa-wrench mr-2"></i>提交报修
                                        </a>
                                    </div>
                                    <div class="col-6 mb-3">
                                        <a href="${pageContext.request.contextPath}/student/late-return/list" class="btn btn-outline-secondary w-100">
                                            <i class="fas fa-moon mr-2"></i>晚归记录
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
                                        <span class="badge bg-info">学生</span>
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

    <script>
        $(function() {
            // 更新当前时间
            function updateTime() {
                var now = new Date();
                var timeStr = $.formatDate(now, 'yyyy-MM-dd HH:mm:ss');
                $('#currentTime').text(timeStr);
            }
            updateTime();
            setInterval(updateTime, 1000);

            // 加载统计数据
            loadCheckinStatus();
        });

        /**
         * 加载住宿状态
         */
        function loadCheckinStatus() {
            $.ajaxRequest('/student/checkin/info', 'GET', {}, function(result) {
                if (result.code === 200 && result.data) {
                    $('#checkinStatus').html('<span class="badge bg-success">在住</span>');
                } else {
                    $('#checkinStatus').html('<span class="badge bg-secondary">未入住</span>');
                }
            });
        }
    </script>
</body>
</html>
