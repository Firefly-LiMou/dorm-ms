<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>访客详情 - 高校公寓管理系统</title>
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
                <!-- 页面标题 -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h4 style="color: #333; margin-bottom: 8px;">访客详情</h4>
                        <p style="color: #666; margin: 0;">查看访客信息</p>
                    </div>
                    <div>
                        <button type="button" class="btn btn-warning mr-2" id="btnLeave" style="display: none;" onclick="confirmLeave()">
                            <i class="fas fa-sign-out-alt mr-1"></i>确认离开
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/visitor/list" class="btn btn-secondary">
                            <i class="fas fa-arrow-left mr-1"></i>返回列表
                        </a>
                    </div>
                </div>

                <!-- 访客信息 -->
                <div class="form-container" id="visitorInfo">
                    <div class="text-center py-4">
                        <i class="fas fa-spinner fa-spin mr-2"></i>加载中...
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
        // 当前访客ID
        var currentVisitorId = null;

        $(function() {
            // 从URL参数获取访客ID
            var urlParams = new URLSearchParams(window.location.search);
            currentVisitorId = urlParams.get('visitorId');

            if (!currentVisitorId) {
                $('#visitorInfo').html('<div class="text-center py-4 text-danger"><i class="fas fa-exclamation-circle mr-2"></i>参数错误，未指定访客ID</div>');
                return;
            }

            loadVisitorDetail(currentVisitorId);
        });

        /**
         * 加载访客详情
         * @param {number} visitorId - 访客ID
         */
        function loadVisitorDetail(visitorId) {
            $.ajaxRequest('/admin/visitor/' + visitorId, 'GET', null, function(result) {
                if (result.data) {
                    renderVisitorInfo(result.data);
                }
            }, function(result) {
                $('#visitorInfo').html('<div class="text-center py-4 text-danger"><a href="javascript:void(0)" onclick="loadVisitorDetail(' + visitorId + ')" style="color: #dc3545;"><i class="fas fa-exclamation-circle mr-2"></i>加载失败，点击重试</a></div>');
            });
        }

        /**
         * 渲染访客信息
         * @param {object} visitor - 访客数据
         */
        function renderVisitorInfo(visitor) {
            var statusBadge = visitor.leaveTime
                ? '<span class="badge bg-secondary">已离开</span>'
                : '<span class="badge bg-success">在访</span>';

            // 显示/隐藏确认离开按钮
            if (!visitor.leaveTime) {
                $('#btnLeave').show();
            } else {
                $('#btnLeave').hide();
            }

            var html = '<div class="row">';
            // 左侧：访客信息
            html += '<div class="col-md-6">';
            html += '<h6 class="mb-3"><i class="fas fa-user-friends mr-2"></i>访客信息</h6>';
            html += '<table class="table table-bordered">';
            html += '<tr><td class="bg-light" style="width: 120px;">访客ID</td><td>' + visitor.visitorId + '</td></tr>';
            html += '<tr><td class="bg-light">访客姓名</td><td>' + (visitor.visitorName || '-') + '</td></tr>';
            html += '<tr><td class="bg-light">身份证号</td><td>' + (visitor.idCard || '-') + '</td></tr>';
            html += '<tr><td class="bg-light">来访时间</td><td>' + $.formatDate(visitor.visitTime) + '</td></tr>';
            html += '<tr><td class="bg-light">离开时间</td><td>' + (visitor.leaveTime ? $.formatDate(visitor.leaveTime) : '-') + '</td></tr>';
            html += '<tr><td class="bg-light">来访事由</td><td>' + (visitor.visitReason || '-') + '</td></tr>';
            html += '</table>';
            html += '</div>';

            // 右侧：被访学生和状态
            html += '<div class="col-md-6">';
            html += '<h6 class="mb-3"><i class="fas fa-info-circle mr-2"></i>其他信息</h6>';
            html += '<table class="table table-bordered">';
            html += '<tr><td class="bg-light" style="width: 120px;">状态</td><td>' + statusBadge + '</td></tr>';
            html += '<tr><td class="bg-light">被访学生</td><td>' + (visitor.studentName || '-') + '</td></tr>';
            html += '<tr><td class="bg-light">楼栋</td><td>' + (visitor.buildingName || '-') + '</td></tr>';
            html += '<tr><td class="bg-light">登记人</td><td>' + (visitor.registrarName || '-') + '</td></tr>';
            html += '</table>';
            html += '</div>';
            html += '</div>';

            $('#visitorInfo').html(html);
        }

        /**
         * 确认访客离开
         */
        function confirmLeave() {
            $.confirm('确定要确认该访客已离开吗？', function() {
                $.ajaxRequest('/admin/visitor/leave/' + currentVisitorId, 'POST', null, function(result) {
                    $.toast('success', '已确认访客离开');
                    loadVisitorDetail(currentVisitorId);
                }, function(result) {
                    $.toast('error', result.msg || '操作失败');
                });
            });
        }
    </script>
</body>
</html>
