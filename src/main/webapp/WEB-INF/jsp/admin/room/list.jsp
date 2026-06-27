<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>房间管理 - 高校公寓管理系统</title>
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
                        <h4 style="color: #333; margin-bottom: 8px;">房间管理</h4>
                        <p style="color: #666; margin: 0;">管理公寓房间信息</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/room/addPage" class="btn btn-primary">
                        <i class="fas fa-plus mr-2"></i>新增房间
                    </a>
                </div>

                <!-- 查询区域 -->
                <div class="form-container mb-4">
                    <form id="searchForm" class="row g-3">
                        <div class="col-md-3">
                            <label for="searchBuildingId" class="form-label">所属楼栋</label>
                            <select class="form-control" id="searchBuildingId">
                                <option value="">全部楼栋</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label for="searchRoomNo" class="form-label">房间编号</label>
                            <input type="text" class="form-control" id="searchRoomNo" placeholder="请输入房间号">
                        </div>
                        <div class="col-md-2">
                            <label for="searchFloorNum" class="form-label">楼层</label>
                            <input type="number" class="form-control" id="searchFloorNum" placeholder="楼层" min="1">
                        </div>
                        <div class="col-md-2">
                            <label for="searchRoomType" class="form-label">房间类型</label>
                            <select class="form-control" id="searchRoomType">
                                <option value="">全部</option>
                                <option value="1">四人间</option>
                                <option value="2">六人间</option>
                                <option value="3">八人间</option>
                            </select>
                        </div>
                        <div class="col-md-3 d-flex align-items-end gap-2">
                            <button type="button" class="btn btn-primary" onclick="search()">
                                <i class="fas fa-search mr-1"></i>查询
                            </button>
                            <button type="button" class="btn btn-secondary" onclick="resetSearch()">
                                <i class="fas fa-undo mr-1"></i>重置
                            </button>
                        </div>
                    </form>
                </div>

                <!-- 房间列表 -->
                <div class="form-container">
                    <div class="table-container">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>房间编号</th>
                                    <th>所属楼栋</th>
                                    <th>楼层</th>
                                    <th>房间类型</th>
                                    <th>额定床位</th>
                                    <th>已入住</th>
                                    <th>备注</th>
                                    <th>操作</th>
                                </tr>
                            </thead>
                            <tbody id="tableBody">
                                <tr>
                                    <td colspan="8" class="text-center py-4">
                                        <i class="fas fa-spinner fa-spin mr-2"></i>加载中...
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- 分页 -->
                    <div id="paginationContainer"></div>
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
        // 分页参数
        var pageQueryParams = {
            pageNum: 1,
            pageSize: 10
        };

        $(function() {
            // 加载楼栋列表（用于筛选下拉框）
            loadBuildingList();
            // 加载房间数据
            loadData(pageQueryParams);
        });

        /**
         * 加载楼栋列表
         */
        function loadBuildingList() {
            $.ajaxRequest('/admin/building/page', 'GET', {pageSize: 100}, function(result) {
                if (result.data && result.data.list) {
                    var $select = $('#searchBuildingId');
                    result.data.list.forEach(function(building) {
                        $select.append('<option value="' + building.buildingId + '">' + building.buildingName + '</option>');
                    });
                }
            });
        }

        /**
         * 加载数据
         * @param {object} params - 查询参数
         */
        function loadData(params) {
            var queryParams = $.extend({}, params, {
                buildingId: $('#searchBuildingId').val() || null,
                roomNo: $('#searchRoomNo').val().trim(),
                floorNum: $('#searchFloorNum').val() || null,
                roomType: $('#searchRoomType').val() || null
            });

            $.ajaxRequest('/admin/room/page', 'GET', queryParams, function(result) {
                if (result.data) {
                    renderTable(result.data.list);
                    renderPagination(result.data);
                    pageQueryParams.pageNum = result.data.pageNum;
                    pageQueryParams.pageSize = result.data.pageSize;
                }
            }, function() {
                $('#tableBody').html('<tr><td colspan="8" class="text-center py-4 text-danger"><a href="javascript:void(0)" onclick="loadData(pageQueryParams)" style="color: #dc3545;"><i class="fas fa-exclamation-circle mr-2"></i>加载失败，点击重试</a></td></tr>');
            });
        }

        /**
         * 渲染表格
         * @param {Array} list - 房间列表
         */
        function renderTable(list) {
            var $tbody = $('#tableBody');
            $tbody.empty();

            if (!list || list.length === 0) {
                $tbody.html('<tr><td colspan="8" class="text-center py-4 text-muted"><i class="fas fa-inbox mr-2"></i>暂无数据</td></tr>');
                return;
            }

            list.forEach(function(item) {
                var roomTypeText = getRoomTypeText(item.roomType);
                var row = '<tr>';
                row += '<td>' + (item.roomNo || '-') + '</td>';
                row += '<td>' + (item.buildingName || '-') + '</td>';
                row += '<td>' + (item.floorNum || '-') + '</td>';
                row += '<td>' + roomTypeText + '</td>';
                row += '<td>' + (item.bedTotal || '-') + '</td>';
                row += '<td>' + (item.bedUsed || 0) + '</td>';
                row += '<td>' + (item.remark || '-') + '</td>';
                row += '<td class="actions">';
                row += '<a href="${pageContext.request.contextPath}/admin/room/editPage?roomId=' + item.roomId + '" class="btn btn-sm btn-primary"><i class="fas fa-edit mr-1"></i>编辑</a>';
                row += '<button class="btn btn-sm btn-danger" onclick="deleteRoom(' + item.roomId + ')"><i class="fas fa-trash mr-1"></i>删除</button>';
                row += '</td>';
                row += '</tr>';
                $tbody.append(row);
            });
        }

        /**
         * 渲染分页
         * @param {object} pageInfo - 分页信息
         */
        function renderPagination(pageInfo) {
            var $container = $('#paginationContainer');
            $container.empty();

            if (!pageInfo || pageInfo.pages <= 1) {
                return;
            }

            var html = '<div class="pagination-container">';
            html += '<div class="pagination-info">共 <span>' + pageInfo.total + '</span> 条记录，第 <span>' + pageInfo.pageNum + '</span>/<span>' + pageInfo.pages + '</span> 页</div>';
            html += '<div class="d-flex align-items-center gap-3">';
            html += '<div class="page-size-select"><label>每页</label>';
            html += '<select onchange="changePageSize(this.value)">';
            html += '<option value="10"' + (pageInfo.pageSize === 10 ? ' selected' : '') + '>10</option>';
            html += '<option value="20"' + (pageInfo.pageSize === 20 ? ' selected' : '') + '>20</option>';
            html += '<option value="50"' + (pageInfo.pageSize === 50 ? ' selected' : '') + '>50</option>';
            html += '</select><label>条</label></div>';
            html += '<nav><ul class="pagination mb-0">';

            html += '<li class="page-item' + (pageInfo.pageNum === 1 ? ' disabled' : '') + '">';
            html += '<a class="page-link" href="javascript:void(0)" onclick="goToPage(1)"><i class="fas fa-angle-double-left"></i></a></li>';

            html += '<li class="page-item' + (!pageInfo.hasPreviousPage ? ' disabled' : '') + '">';
            html += '<a class="page-link" href="javascript:void(0)" onclick="goToPage(' + (pageInfo.pageNum - 1) + ')"><i class="fas fa-angle-left"></i></a></li>';

            var startPage = Math.max(1, pageInfo.pageNum - 2);
            var endPage = Math.min(pageInfo.pages, pageInfo.pageNum + 2);
            for (var i = startPage; i <= endPage; i++) {
                html += '<li class="page-item' + (pageInfo.pageNum === i ? ' active' : '') + '">';
                html += '<a class="page-link" href="javascript:void(0)" onclick="goToPage(' + i + ')">' + i + '</a></li>';
            }

            html += '<li class="page-item' + (!pageInfo.hasNextPage ? ' disabled' : '') + '">';
            html += '<a class="page-link" href="javascript:void(0)" onclick="goToPage(' + (pageInfo.pageNum + 1) + ')"><i class="fas fa-angle-right"></i></a></li>';

            html += '<li class="page-item' + (pageInfo.pageNum === pageInfo.pages ? ' disabled' : '') + '">';
            html += '<a class="page-link" href="javascript:void(0)" onclick="goToPage(' + pageInfo.pages + ')"><i class="fas fa-angle-double-right"></i></a></li>';

            html += '</ul></nav></div></div>';
            $container.html(html);
        }

        function goToPage(pageNum) {
            pageQueryParams.pageNum = pageNum;
            loadData(pageQueryParams);
        }

        function changePageSize(pageSize) {
            pageQueryParams.pageNum = 1;
            pageQueryParams.pageSize = parseInt(pageSize);
            loadData(pageQueryParams);
        }

        function search() {
            pageQueryParams.pageNum = 1;
            loadData(pageQueryParams);
        }

        function resetSearch() {
            $('#searchBuildingId').val('');
            $('#searchRoomNo').val('');
            $('#searchFloorNum').val('');
            $('#searchRoomType').val('');
            search();
        }

        /**
         * 删除房间
         * @param {number} roomId - 房间ID
         */
        function deleteRoom(roomId) {
            $.confirm('确定删除该房间吗？', function() {
                $.ajaxRequest('/admin/room/delete/' + roomId, 'POST', null, function(result) {
                    $.toast('success', '删除成功');
                    loadData(pageQueryParams);
                }, function(result) {
                    $.toast('error', result.msg || '删除失败');
                });
            });
        }

        /**
         * 获取房间类型文本
         * @param {number} roomType - 房间类型
         * @returns {string} 房间类型文本
         */
        function getRoomTypeText(roomType) {
            var typeMap = {1: '四人间', 2: '六人间', 3: '八人间'};
            return typeMap[roomType] || '-';
        }
    </script>
</body>
</html>
