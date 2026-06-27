<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>报修详情 - 高校公寓管理系统</title>
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
                        <h4 style="color: #333; margin-bottom: 8px;">报修详情</h4>
                        <p style="color: #666; margin: 0;">查看报修处理进度</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/student/repair/list" class="btn btn-secondary">
                        <i class="fas fa-arrow-left mr-1"></i>返回列表
                    </a>
                </div>

                <!-- 报修信息 -->
                <div class="form-container" id="repairInfo">
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
        // 当前报修ID
        var currentRepairId = null;

        $(function() {
            // 从URL参数获取报修ID
            var urlParams = new URLSearchParams(window.location.search);
            currentRepairId = urlParams.get('repairId');

            if (!currentRepairId) {
                $('#repairInfo').html('<div class="text-center py-4 text-danger"><i class="fas fa-exclamation-circle mr-2"></i>参数错误，未指定报修ID</div>');
                return;
            }

            loadRepairDetail(currentRepairId);
        });

        /**
         * 加载报修详情
         * @param {number} repairId - 报修ID
         */
        function loadRepairDetail(repairId) {
            $.ajaxRequest('/student/repair/' + repairId, 'GET', null, function(result) {
                if (result.data) {
                    renderRepairInfo(result.data);
                }
            }, function(result) {
                $('#repairInfo').html('<div class="text-center py-4 text-danger"><a href="javascript:void(0)" onclick="loadRepairDetail(' + repairId + ')" style="color: #dc3545;"><i class="fas fa-exclamation-circle mr-2"></i>加载失败，点击重试</a></div>');
            });
        }

        /**
         * 渲染报修信息
         * @param {object} repair - 报修数据
         */
        function renderRepairInfo(repair) {
            var statusBadge = getStatusBadge(repair.repairStatus);
            var typeText = getRepairTypeText(repair.repairType);
            var timeoutBadge = repair.isTimeout ? ' <span class="badge bg-danger">超时</span>' : '';

            // 状态步骤条
            var steps = [
                { label: '待处理', status: 0 },
                { label: '处理中', status: 1 },
                { label: '已完成', status: 2 }
            ];
            var currentStepIndex = steps.findIndex(function(s) { return s.status === repair.repairStatus; });

            var html = '<div class="mb-4">';
            html += '<h6 class="mb-3"><i class="fas fa-tasks mr-2"></i>处理进度</h6>';
            html += '<div class="d-flex align-items-center">';
            steps.forEach(function(step, index) {
                var isActive = index <= currentStepIndex;
                var isCurrent = index === currentStepIndex;
                var stepClass = isActive ? (isCurrent ? 'bg-primary text-white' : 'bg-success text-white') : 'bg-light text-muted';
                var lineClass = index < steps.length - 1 ? (isActive && index < currentStepIndex ? 'bg-success' : 'bg-light') : '';

                html += '<div class="d-flex align-items-center">';
                html += '<div class="rounded-circle d-flex align-items-center justify-content-center ' + stepClass + '" style="width: 36px; height: 36px; font-size: 14px;">';
                if (index < currentStepIndex) {
                    html += '<i class="fas fa-check"></i>';
                } else {
                    html += (index + 1);
                }
                html += '</div>';
                html += '<span class="ms-2 ' + (isActive ? '' : 'text-muted') + '">' + step.label + '</span>';
                html += '</div>';

                if (index < steps.length - 1) {
                    html += '<div class="flex-grow-1 mx-3" style="height: 2px; background-color: ' + (isActive && index < currentStepIndex ? '#28a745' : '#e0e0e0') + ';"></div>';
                }
            });
            html += '</div>';
            html += '</div>';

            // 报修详细信息
            html += '<div class="row">';
            // 左侧：基本信息
            html += '<div class="col-md-6">';
            html += '<h6 class="mb-3"><i class="fas fa-info-circle mr-2"></i>基本信息</h6>';
            html += '<table class="table table-bordered">';
            html += '<tr><td class="bg-light" style="width: 120px;">楼栋</td><td>' + (repair.buildingName || '-') + '</td></tr>';
            html += '<tr><td class="bg-light">房间</td><td>' + (repair.roomNo || '-') + '</td></tr>';
            html += '<tr><td class="bg-light">报修类型</td><td>' + typeText + '</td></tr>';
            html += '<tr><td class="bg-light">报修内容</td><td>' + (repair.repairContent || '-') + '</td></tr>';
            html += '<tr><td class="bg-light">联系电话</td><td>' + (repair.contactPhone || '-') + '</td></tr>';
            html += '<tr><td class="bg-light">提交时间</td><td>' + $.formatDate(repair.submitTime) + '</td></tr>';
            html += '</table>';
            html += '</div>';

            // 右侧：处理信息
            html += '<div class="col-md-6">';
            html += '<h6 class="mb-3"><i class="fas fa-wrench mr-2"></i>处理信息</h6>';
            html += '<table class="table table-bordered">';
            html += '<tr><td class="bg-light" style="width: 120px;">状态</td><td>' + statusBadge + timeoutBadge + '</td></tr>';
            html += '<tr><td class="bg-light">处理人</td><td>' + (repair.handlerName || '-') + '</td></tr>';
            html += '<tr><td class="bg-light">处理结果</td><td>' + (repair.handleResult || '-') + '</td></tr>';
            html += '<tr><td class="bg-light">完成时间</td><td>' + (repair.finishTime ? $.formatDate(repair.finishTime) : '-') + '</td></tr>';
            html += '</table>';
            html += '</div>';
            html += '</div>';

            $('#repairInfo').html(html);
        }

        /**
         * 获取状态徽章
         * @param {number} status - 处理状态
         * @returns {string} 状态徽章HTML
         */
        function getStatusBadge(status) {
            var map = {
                0: '<span class="badge bg-warning">待处理</span>',
                1: '<span class="badge bg-info">处理中</span>',
                2: '<span class="badge bg-success">已完成</span>'
            };
            return map[status] || '<span class="badge bg-secondary">未知</span>';
        }

        /**
         * 获取报修类型文本
         * @param {number} type - 报修类型
         * @returns {string} 类型文本
         */
        function getRepairTypeText(type) {
            var map = {
                1: '水电故障',
                2: '家具损坏',
                3: '门窗故障',
                4: '其他'
            };
            return map[type] || '-';
        }
    </script>
</body>
</html>
