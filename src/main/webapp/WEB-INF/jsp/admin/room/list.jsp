<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>房间管理 - 高校公寓管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/fontawesome/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css">
</head>
<body>
    <div class="main-container">
        <%@ include file="/WEB-INF/jsp/common/sidebar.jsp" %>

        <div class="content-wrapper">
            <%@ include file="/WEB-INF/jsp/common/header.jsp" %>

            <div class="content-body">
                <div class="page-header">
                    <div>
                        <h1>房间管理</h1>
                        <p class="page-meta">管理公寓房间信息</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/room/addPage" class="btn btn-primary">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                        新增房间
                    </a>
                </div>

                <div class="filter-bar">
                    <div class="filter-field">
                        <label>所属楼栋</label>
                        <div class="cselect">
                            <select id="searchBuildingId">
                                <option value="">全部楼栋</option>
                            </select>
                        </div>
                    </div>
                    <div class="filter-field">
                        <label>房间编号</label>
                        <input type="text" id="searchRoomNo" placeholder="请输入房间号">
                    </div>
                    <div class="filter-field">
                        <label>楼层</label>
                        <input type="number" id="searchFloorNum" placeholder="楼层" min="1">
                    </div>
                    <div class="filter-field">
                        <label>房间类型</label>
                        <div class="cselect">
                            <select id="searchRoomType">
                                <option value="">全部</option>
                                <option value="1">四人间</option>
                                <option value="2">六人间</option>
                                <option value="3">八人间</option>
                            </select>
                        </div>
                    </div>
                    <div class="filter-actions">
                        <button type="button" class="btn btn-secondary btn-sm" onclick="search()">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="14" height="14"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                            查询
                        </button>
                        <button type="button" class="btn btn-ghost btn-sm" onclick="resetSearch()">重置</button>
                    </div>
                </div>

                <div class="data-panel">
                    <table>
                        <thead>
                            <tr>
                                <th>房间编号</th>
                                <th>所属楼栋</th>
                                <th>楼层</th>
                                <th>房间类型</th>
                                <th>额定床位</th>
                                <th>已入住</th>
                                <th>备注</th>
                                <th style="width: 120px;">操作</th>
                            </tr>
                        </thead>
                        <tbody id="tableBody">
                            <tr><td colspan="8" class="text-center" style="padding: 40px 0; color: var(--muted);">加载中...</td></tr>
                        </tbody>
                    </table>
                    <div id="paginationContainer"></div>
                </div>
            </div>

            <%@ include file="/WEB-INF/jsp/common/footer.jsp" %>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/common.js"></script>
    <script>window.needChangePasswordFlag = '${sessionScope.needChangePassword}';</script>
    <script src="${pageContext.request.contextPath}/static/js/header.js"></script>

    <script>
        // 分页参数
        var pageQueryParams = {
            pageNum: 1,
            pageSize: 10
        };

        $(function() {
            $.initCustomSelect();
            loadBuildingList();
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
                    $.renderPagination(result.data, 'paginationContainer', function(page) {
                        pageQueryParams.pageNum = page;
                        loadData(pageQueryParams);
                    });
                    pageQueryParams.pageNum = result.data.pageNum;
                    pageQueryParams.pageSize = result.data.pageSize;
                }
            }, function() {
                $('#tableBody').html('<tr><td colspan="8" class="text-center" style="padding: 40px 0;"><a href="javascript:void(0)" onclick="loadData(pageQueryParams)" style="color: var(--accent);">加载失败，点击重试</a></td></tr>');
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
                $tbody.html('<tr><td colspan="8" class="text-center" style="padding: 40px 0; color: var(--muted);">暂无数据</td></tr>');
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
                row += '<td class="text-muted">' + (item.remark || '-') + '</td>';
                row += '<td class="actions">';
                row += '<a href="${pageContext.request.contextPath}/admin/room/editPage?roomId=' + item.roomId + '" class="btn btn-ghost btn-sm">编辑</a>';
                row += '<button class="btn btn-ghost btn-sm" onclick="deleteRoom(' + item.roomId + ')">删除</button>';
                row += '</td>';
                row += '</tr>';
                $tbody.append(row);
            });
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
