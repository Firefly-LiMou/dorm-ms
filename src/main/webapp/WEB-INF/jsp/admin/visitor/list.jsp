<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>访客登记 - 高校公寓管理系统</title>
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
                        <h4 style="color: #333; margin-bottom: 8px;">访客登记</h4>
                        <p style="color: #666; margin: 0;">管理公寓访客记录</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/visitor/addPage" class="btn btn-primary">
                        <i class="fas fa-plus mr-1"></i>录入访客
                    </a>
                </div>

                <!-- 查询区域 -->
                <div class="form-container mb-4">
                    <form id="searchForm" class="row g-3">
                        <div class="col-md-3">
                            <label for="searchStudentId" class="form-label">被访学生ID</label>
                            <input type="text" class="form-control" id="searchStudentId" placeholder="请输入被访学生ID">
                        </div>
                        <div class="col-md-3">
                            <label for="searchBuildingId" class="form-label">楼栋ID</label>
                            <input type="text" class="form-control" id="searchBuildingId" placeholder="请输入楼栋ID">
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

                <!-- 访客记录列表 -->
                <div class="form-container">
                    <div class="table-container">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>访客姓名</th>
                                    <th>身份证号</th>
                                    <th>被访学生</th>
                                    <th>楼栋</th>
                                    <th>来访时间</th>
                                    <th>离开时间</th>
                                    <th>状态</th>
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
            loadData(pageQueryParams);
        });

        /**
         * 加载数据
         * @param {object} params - 查询参数
         */
        function loadData(params) {
            var queryParams = $.extend({}, params, {
                studentId: $('#searchStudentId').val().trim() || null,
                buildingId: $('#searchBuildingId').val().trim() || null
            });

            $.ajaxRequest('/admin/visitor/page', 'GET', queryParams, function(result) {
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
         * @param {Array} list - 访客记录列表
         */
        function renderTable(list) {
            var $tbody = $('#tableBody');
            $tbody.empty();

            if (!list || list.length === 0) {
                $tbody.html('<tr><td colspan="8" class="text-center py-4 text-muted"><i class="fas fa-inbox mr-2"></i>暂无数据</td></tr>');
                return;
            }

            list.forEach(function(item) {
                var statusBadge = item.leaveTime
                    ? '<span class="badge bg-secondary">已离开</span>'
                    : '<span class="badge bg-success">在访</span>';

                // 操作按钮
                var actionBtn = '';
                if (!item.leaveTime) {
                    actionBtn = '<button class="btn btn-sm btn-warning" onclick="confirmLeave(' + item.visitorId + ')"><i class="fas fa-sign-out-alt mr-1"></i>确认离开</button> ';
                }
                actionBtn += '<a href="${pageContext.request.contextPath}/admin/visitor/detailPage?visitorId=' + item.visitorId + '" class="btn btn-sm btn-info"><i class="fas fa-eye mr-1"></i>详情</a>';

                var row = '<tr>';
                row += '<td>' + (item.visitorName || '-') + '</td>';
                row += '<td>' + (item.idCard || '-') + '</td>';
                row += '<td>' + (item.studentName || '-') + '</td>';
                row += '<td>' + (item.buildingName || '-') + '</td>';
                row += '<td>' + $.formatDate(item.visitTime) + '</td>';
                row += '<td>' + (item.leaveTime ? $.formatDate(item.leaveTime) : '-') + '</td>';
                row += '<td>' + statusBadge + '</td>';
                row += '<td>' + actionBtn + '</td>';
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
            $('#searchStudentId').val('');
            $('#searchBuildingId').val('');
            search();
        }

        /**
         * 确认访客离开
         * @param {number} visitorId - 访客ID
         */
        function confirmLeave(visitorId) {
            $.confirm('确定要确认该访客已离开吗？', function() {
                $.ajaxRequest('/admin/visitor/leave/' + visitorId, 'POST', null, function(result) {
                    $.toast('success', '已确认访客离开');
                    loadData(pageQueryParams);
                }, function(result) {
                    $.toast('error', result.msg || '操作失败');
                });
            });
        }
    </script>
</body>
</html>
