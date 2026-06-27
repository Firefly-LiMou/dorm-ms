<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>房间信息 - 高校公寓管理系统</title>
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
                    <h4 style="color: #333; margin-bottom: 8px;">房间信息</h4>
                    <p style="color: #666; margin: 0;">查看负责楼栋的房间信息</p>
                </div>

                <!-- 楼栋选择 -->
                <div class="form-container mb-4">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label for="buildingId" class="form-label">选择楼栋</label>
                            <select class="form-control" id="buildingId">
                                <option value="">请选择楼栋</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- 房间列表 -->
                <div class="form-container">
                    <div class="table-container">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>房间编号</th>
                                    <th>楼层</th>
                                    <th>房间类型</th>
                                    <th>额定床位</th>
                                    <th>已入住</th>
                                    <th>备注</th>
                                </tr>
                            </thead>
                            <tbody id="tableBody">
                                <tr>
                                    <td colspan="6" class="text-center py-4 text-muted">
                                        <i class="fas fa-info-circle mr-2"></i>请先选择楼栋
                                    </td>
                                </tr>
                            </tbody>
                        </table>
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
                    $('#tableBody').html('<tr><td colspan="6" class="text-center py-4 text-muted"><i class="fas fa-info-circle mr-2"></i>请先选择楼栋</td></tr>');
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
            var $tbody = $('#tableBody');
            $tbody.html('<tr><td colspan="6" class="text-center py-4"><i class="fas fa-spinner fa-spin mr-2"></i>加载中...</td></tr>');

            $.ajaxRequest('/dorm/room/building/' + buildingId, 'GET', null, function(result) {
                if (result.data && result.data.length > 0) {
                    renderTable(result.data);
                } else {
                    $tbody.html('<tr><td colspan="6" class="text-center py-4 text-muted"><i class="fas fa-inbox mr-2"></i>暂无房间数据</td></tr>');
                }
            }, function() {
                $tbody.html('<tr><td colspan="6" class="text-center py-4 text-danger"><a href="javascript:void(0)" onclick="loadRoomList(' + buildingId + ')" style="color: #dc3545;"><i class="fas fa-exclamation-circle mr-2"></i>加载失败，点击重试</a></td></tr>');
            });
        }

        /**
         * 渲染表格
         * @param {Array} list - 房间列表
         */
        function renderTable(list) {
            var $tbody = $('#tableBody');
            $tbody.empty();

            list.forEach(function(room) {
                var row = '<tr>';
                row += '<td>' + (room.roomNo || '-') + '</td>';
                row += '<td>' + (room.floorNum || '-') + '</td>';
                row += '<td>' + (room.roomTypeText || '-') + '</td>';
                row += '<td>' + (room.bedTotal || '-') + '</td>';
                row += '<td>' + (room.bedUsed || 0) + '</td>';
                row += '<td>' + (room.remark || '-') + '</td>';
                row += '</tr>';
                $tbody.append(row);
            });
        }
    </script>
</body>
</html>
