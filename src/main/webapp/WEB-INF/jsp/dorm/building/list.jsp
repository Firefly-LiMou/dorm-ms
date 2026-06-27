<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>宿舍信息 - 高校公寓管理系统</title>
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
                <div class="mb-4">
                    <h4 style="color: #333; margin-bottom: 8px;">宿舍信息</h4>
                    <p style="color: #666; margin: 0;">查看负责楼栋的房间和床位信息</p>
                </div>

                <!-- 级联选择区域 -->
                <div class="form-container mb-4">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label for="buildingId" class="form-label">选择楼栋</label>
                            <select class="form-control" id="buildingId">
                                <option value="">请选择楼栋</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="roomId" class="form-label">选择房间</label>
                            <select class="form-control" id="roomId" disabled>
                                <option value="">请先选择楼栋</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- 房间信息卡片 -->
                <div id="roomInfoCard" style="display: none;">
                    <div class="form-container mb-4">
                        <h6 class="mb-3"><i class="fas fa-door-open mr-2"></i>房间信息</h6>
                        <div class="row">
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label>房间编号</label>
                                    <input type="text" class="form-control" id="roomNo" readonly>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label>房间类型</label>
                                    <input type="text" class="form-control" id="roomType" readonly>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label>额定床位</label>
                                    <input type="text" class="form-control" id="bedTotal" readonly>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label>已入住</label>
                                    <input type="text" class="form-control" id="bedUsed" readonly>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 床位列表 -->
                    <div class="form-container">
                        <h6 class="mb-3"><i class="fas fa-bed mr-2"></i>床位信息</h6>
                        <div id="bedListContainer">
                            <div class="text-center py-4">
                                <i class="fas fa-spinner fa-spin mr-2"></i>加载中...
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 未选择房间提示 -->
                <div id="emptyTip" class="form-container">
                    <div class="text-center py-4 text-muted">
                        <i class="fas fa-info-circle mr-2"></i>请选择楼栋和房间查看床位信息
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
            // 加载负责楼栋列表
            loadBuildingList();

            // 楼栋选择变化事件
            $('#buildingId').on('change', function() {
                var buildingId = $(this).val();
                if (buildingId) {
                    loadRoomList(buildingId);
                } else {
                    $('#roomId').html('<option value="">请先选择楼栋</option>').prop('disabled', true);
                    hideRoomInfo();
                }
            });

            // 房间选择变化事件
            $('#roomId').on('change', function() {
                var roomId = $(this).val();
                if (roomId) {
                    loadRoomInfo(roomId);
                    loadBedList(roomId);
                } else {
                    hideRoomInfo();
                }
            });
        });

        /**
         * 加载负责楼栋列表
         */
        function loadBuildingList() {
            $.ajaxRequest('/dorm/building/list', 'GET', null, function(result) {
                if (result.data) {
                    var $select = $('#buildingId');
                    result.data.forEach(function(building) {
                        $select.append('<option value="' + building.buildingId + '">' + building.buildingName + '</option>');
                    });

                    // 如果只有一个楼栋，自动选中
                    if (result.data.length === 1) {
                        $select.val(result.data[0].buildingId).trigger('change');
                    }
                }
            }, function(result) {
                if (result.msg && result.msg.indexOf('未负责任何楼栋') !== -1) {
                    $.toast('warning', '您暂未负责任何楼栋，请联系管理员');
                }
            });
        }

        /**
         * 加载房间列表
         * @param {number} buildingId - 楼栋ID
         */
        function loadRoomList(buildingId) {
            var $select = $('#roomId');
            $select.html('<option value="">请选择房间</option>').prop('disabled', true);

            $.ajaxRequest('/dorm/room/building/' + buildingId, 'GET', null, function(result) {
                if (result.data) {
                    result.data.forEach(function(room) {
                        $select.append('<option value="' + room.roomId + '">' + room.roomNo + ' (' + room.roomTypeText + ')</option>');
                    });
                    $select.prop('disabled', false);
                }
            });
        }

        /**
         * 加载房间信息
         * @param {number} roomId - 房间ID
         */
        function loadRoomInfo(roomId) {
            $.ajaxRequest('/dorm/room/building/' + $('#buildingId').val(), 'GET', null, function(result) {
                if (result.data) {
                    var room = result.data.find(function(r) { return r.roomId == roomId; });
                    if (room) {
                        $('#roomNo').val(room.roomNo);
                        $('#roomType').val(room.roomTypeText);
                        $('#bedTotal').val(room.bedTotal);
                        $('#bedUsed').val(room.bedUsed || 0);
                        showRoomInfo();
                    }
                }
            });
        }

        /**
         * 加载床位列表
         * @param {number} roomId - 房间ID
         */
        function loadBedList(roomId) {
            var $container = $('#bedListContainer');
            $container.html('<div class="text-center py-4"><i class="fas fa-spinner fa-spin mr-2"></i>加载中...</div>');

            $.ajaxRequest('/dorm/bed/room/' + roomId, 'GET', null, function(result) {
                if (result.data && result.data.length > 0) {
                    renderBedList(result.data);
                } else {
                    $container.html('<div class="text-center py-4 text-muted"><i class="fas fa-bed mr-2"></i>该房间暂无床位</div>');
                }
            }, function() {
                $container.html('<div class="text-center py-4 text-danger"><a href="javascript:void(0)" onclick="loadBedList(' + roomId + ')" style="color: #dc3545;"><i class="fas fa-exclamation-circle mr-2"></i>加载失败，点击重试</a></div>');
            });
        }

        /**
         * 渲染床位列表
         * @param {Array} bedList - 床位列表
         */
        function renderBedList(bedList) {
            var $container = $('#bedListContainer');
            var html = '<div class="table-container"><table class="table">';
            html += '<thead><tr>';
            html += '<th>床位编号</th>';
            html += '<th>状态</th>';
            html += '<th>入住学生</th>';
            html += '<th>备注</th>';
            html += '</tr></thead>';
            html += '<tbody>';

            bedList.forEach(function(bed) {
                var statusBadge = getStatusBadge(bed.bedStatus);
                html += '<tr>';
                html += '<td>' + (bed.bedNo || '-') + '</td>';
                html += '<td>' + statusBadge + '</td>';
                html += '<td>' + (bed.studentName || '-') + '</td>';
                html += '<td>' + (bed.remark || '-') + '</td>';
                html += '</tr>';
            });

            html += '</tbody></table></div>';
            $container.html(html);
        }

        /**
         * 获取状态徽章
         * @param {number} status - 床位状态
         * @returns {string} 状态徽章HTML
         */
        function getStatusBadge(status) {
            var map = {
                0: '<span class="badge bg-success">空闲</span>',
                1: '<span class="badge bg-primary">已入住</span>',
                2: '<span class="badge bg-warning">维修禁用</span>'
            };
            return map[status] || '<span class="badge bg-secondary">未知</span>';
        }

        /**
         * 显示房间信息卡片
         */
        function showRoomInfo() {
            $('#roomInfoCard').show();
            $('#emptyTip').hide();
        }

        /**
         * 隐藏房间信息卡片
         */
        function hideRoomInfo() {
            $('#roomInfoCard').hide();
            $('#emptyTip').show();
        }
    </script>
</body>
</html>
