<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>床位管理 - 高校公寓管理系统</title>
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
                        <h4 style="color: #333; margin-bottom: 8px;">床位管理</h4>
                        <p style="color: #666; margin: 0;">管理公寓床位信息</p>
                    </div>
                    <button type="button" class="btn btn-primary" onclick="showBatchModal()" id="btnBatch" disabled>
                        <i class="fas fa-plus mr-2"></i>批量初始化
                    </button>
                </div>

                <!-- 房间选择区域 -->
                <div class="form-container mb-4">
                    <div class="row g-3">
                        <div class="col-md-5">
                            <label for="buildingId" class="form-label">选择楼栋</label>
                            <select class="form-control" id="buildingId">
                                <option value="">请选择楼栋</option>
                            </select>
                        </div>
                        <div class="col-md-5">
                            <label for="roomId" class="form-label">选择房间</label>
                            <select class="form-control" id="roomId" disabled>
                                <option value="">请先选择楼栋</option>
                            </select>
                        </div>
                        <div class="col-md-2 d-flex align-items-end">
                            <button type="button" class="btn btn-primary w-100" onclick="loadBedList()" id="btnSearch" disabled>
                                <i class="fas fa-search mr-1"></i>查询床位
                            </button>
                        </div>
                    </div>
                </div>

                <!-- 床位列表 -->
                <div class="form-container">
                    <h6 class="mb-3"><i class="fas fa-bed mr-2"></i>床位列表</h6>
                    <div id="bedListContainer">
                        <div class="text-center py-4 text-muted">
                            <i class="fas fa-info-circle mr-2"></i>请先选择楼栋和房间
                        </div>
                    </div>
                </div>
            </div>

            <!-- 底部 -->
            <%@ include file="/WEB-INF/jsp/common/footer.jsp" %>
        </div>
    </div>

    <!-- 批量初始化模态框 -->
    <div class="modal fade" id="batchModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">批量初始化床位</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle mr-2"></i>
                        将为房间 <strong id="batchRoomName"></strong> 自动生成床位，床位号格式为"1号床"、"2号床"...
                    </div>
                    <form id="batchForm">
                        <div class="mb-3">
                            <label for="bedCount" class="form-label">床位数量 <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" id="bedCount" placeholder="请输入床位数量" min="1" max="20">
                            <div class="invalid-feedback" id="bedCountError"></div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="button" class="btn btn-primary" id="btnBatchSubmit" onclick="batchSubmit()">确认初始化</button>
                </div>
            </div>
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
        // 当前选中的房间ID
        var currentRoomId = null;

        $(function() {
            // 加载楼栋列表
            loadBuildingList();

            // 楼栋选择变化事件
            $('#buildingId').on('change', function() {
                var buildingId = $(this).val();
                if (buildingId) {
                    loadRoomList(buildingId);
                } else {
                    $('#roomId').html('<option value="">请先选择楼栋</option>').prop('disabled', true);
                    $('#btnSearch').prop('disabled', true);
                    $('#btnBatch').prop('disabled', true);
                    currentRoomId = null;
                }
            });

            // 房间选择变化事件
            $('#roomId').on('change', function() {
                currentRoomId = $(this).val();
                if (currentRoomId) {
                    $('#btnSearch').prop('disabled', false);
                    $('#btnBatch').prop('disabled', false);
                } else {
                    $('#btnSearch').prop('disabled', true);
                    $('#btnBatch').prop('disabled', true);
                }
            });
        });

        /**
         * 加载楼栋列表
         */
        function loadBuildingList() {
            $.ajaxRequest('/admin/building/page', 'GET', {pageSize: 100}, function(result) {
                if (result.data && result.data.list) {
                    var $select = $('#buildingId');
                    result.data.list.forEach(function(building) {
                        $select.append('<option value="' + building.buildingId + '">' + building.buildingName + '</option>');
                    });
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

            $.ajaxRequest('/admin/room/building/' + buildingId, 'GET', null, function(result) {
                if (result.data) {
                    result.data.forEach(function(room) {
                        $select.append('<option value="' + room.roomId + '">' + room.roomNo + ' (' + room.roomTypeText + ')</option>');
                    });
                    $select.prop('disabled', false);
                }
            });
        }

        /**
         * 加载床位列表
         */
        function loadBedList() {
            if (!currentRoomId) {
                return;
            }

            var $container = $('#bedListContainer');
            $container.html('<div class="text-center py-4"><i class="fas fa-spinner fa-spin mr-2"></i>加载中...</div>');

            $.ajaxRequest('/admin/bed/room/' + currentRoomId, 'GET', null, function(result) {
                if (result.data && result.data.length > 0) {
                    renderBedList(result.data);
                } else {
                    $container.html('<div class="text-center py-4 text-muted"><i class="fas fa-bed mr-2"></i>该房间暂无床位，请点击"批量初始化"创建床位</div>');
                }
            }, function() {
                $container.html('<div class="text-center py-4 text-danger"><a href="javascript:void(0)" onclick="loadBedList()" style="color: #dc3545;"><i class="fas fa-exclamation-circle mr-2"></i>加载失败，点击重试</a></div>');
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
            html += '<th>操作</th>';
            html += '</tr></thead>';
            html += '<tbody>';

            bedList.forEach(function(bed) {
                var statusBadge = getStatusBadge(bed.bedStatus);
                var actionBtn = '';

                if (bed.bedStatus === 0) {
                    // 空闲状态，可以设为维修
                    actionBtn = '<button class="btn btn-sm btn-warning" onclick="updateStatus(' + bed.bedId + ', 2)"><i class="fas fa-tools mr-1"></i>设为维修</button>';
                } else if (bed.bedStatus === 2) {
                    // 维修状态，可以设为空闲
                    actionBtn = '<button class="btn btn-sm btn-success" onclick="updateStatus(' + bed.bedId + ', 0)"><i class="fas fa-check mr-1"></i>设为空闲</button>';
                } else {
                    // 已入住状态
                    actionBtn = '<span class="text-muted">-</span>';
                }

                html += '<tr>';
                html += '<td>' + (bed.bedNo || '-') + '</td>';
                html += '<td>' + statusBadge + '</td>';
                html += '<td>' + (bed.studentName || '-') + '</td>';
                html += '<td>' + (bed.remark || '-') + '</td>';
                html += '<td>' + actionBtn + '</td>';
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
         * 显示批量初始化模态框
         */
        function showBatchModal() {
            if (!currentRoomId) {
                $.toast('warning', '请先选择房间');
                return;
            }

            var roomName = $('#roomId option:selected').text();
            $('#batchRoomName').text(roomName);
            $('#bedCount').val('').removeClass('is-invalid');
            $('#bedCountError').text('');
            $('#batchModal').modal('show');
        }

        /**
         * 批量初始化提交
         */
        function batchSubmit() {
            var bedCount = $('#bedCount').val();

            if (!bedCount || bedCount < 1) {
                $('#bedCount').addClass('is-invalid');
                $('#bedCountError').text('请输入有效的床位数量');
                return;
            }

            $('#bedCount').removeClass('is-invalid');
            $('#bedCountError').text('');

            $('#btnBatchSubmit').prop('disabled', true).text('初始化中...');

            $.ajaxRequest('/admin/bed/batch', 'POST', {
                roomId: parseInt(currentRoomId),
                bedCount: parseInt(bedCount)
            }, function(result) {
                $.toast('success', '批量初始化成功');
                $('#batchModal').modal('hide');
                $('#btnBatchSubmit').prop('disabled', false).text('确认初始化');
                loadBedList();
            }, function(result) {
                $.toast('error', result.msg || '初始化失败');
                $('#btnBatchSubmit').prop('disabled', false).text('确认初始化');
            });
        }

        /**
         * 修改床位状态
         * @param {number} bedId - 床位ID
         * @param {number} status - 目标状态
         */
        function updateStatus(bedId, status) {
            var actionText = status === 0 ? '设为空闲' : '设为维修';
            $.confirm('确定要' + actionText + '吗？', function() {
                $.ajaxRequest('/admin/bed/status/' + bedId + '?status=' + status, 'POST', null, function(result) {
                    $.toast('success', actionText + '成功');
                    loadBedList();
                }, function(result) {
                    $.toast('error', result.msg || actionText + '失败');
                });
            });
        }
    </script>
</body>
</html>
