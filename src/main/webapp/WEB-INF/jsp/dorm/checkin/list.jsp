<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>入住管理 - 高校公寓管理系统</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/bootstrap/css/bootstrap.min.css">
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
                <div class="page-header">
                    <div>
                        <h1>入住管理</h1>
                        <p class="page-meta">管理本楼栋学生入住和退宿</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/dorm/checkin/checkinPage" class="btn btn-primary">
                        办理入住
                    </a>
                </div>

                <!-- 查询区域 -->
                <div class="form-container mb-4">
                    <form id="searchForm" class="row g-3">
                        <div class="col-md-3">
                            <label for="searchStudentNo" class="form-label">学号</label>
                            <input type="text" class="form-control" id="searchStudentNo" placeholder="请输入学号">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">入住状态</label>
                            <div class="cselect" id="searchStatusCselect">
                                <div class="cselect-trigger" tabindex="0" aria-haspopup="listbox" aria-expanded="false">
                                    <span class="cselect-val placeholder">全部</span>
                                    <svg class="cselect-arrow" viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg>
                                </div>
                                <div class="cselect-panel" role="listbox">
                                    <div class="cselect-option" data-value="">全部</div>
                                    <div class="cselect-option" data-value="1">在住</div>
                                    <div class="cselect-option" data-value="2">已退宿</div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 d-flex align-items-end gap-2">
                            <button type="button" class="btn btn-primary" onclick="search()">
                                <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                                查询
                            </button>
                            <button type="button" class="btn btn-secondary" onclick="resetSearch()">重置</button>
                        </div>
                    </form>
                </div>

                <!-- 入住记录列表 -->
                <div class="form-container">
                    <div class="data-panel">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>学生姓名</th>
                                    <th>学号</th>
                                    <th>楼栋</th>
                                    <th>房间</th>
                                    <th>床位</th>
                                    <th>入住时间</th>
                                    <th>状态</th>
                                    <th>办理人</th>
                                    <th>操作</th>
                                </tr>
                            </thead>
                            <tbody id="tableBody">
                                <tr>
                                    <td colspan="9" class="text-center py-4">
                                        加载中...
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
            $.initCustomSelect();
            loadData(pageQueryParams);
        });

        /**
         * 加载数据
         * @param {object} params - 查询参数
         */
        function loadData(params) {
            var studentNo = $('#searchStudentNo').val().trim();
            var checkinStatus = document.querySelector('#searchStatusCselect').dataset.value;

            var queryParams = {
                pageNum: params.pageNum || 1,
                pageSize: params.pageSize || 10
            };

            if (studentNo) {
                queryParams.studentNo = studentNo;
            }
            if (checkinStatus) {
                queryParams.checkinStatus = checkinStatus;
            }

            $.ajaxRequest('/dorm/checkin/page', 'GET', queryParams, function(result) {
                if (result.data) {
                    renderTable(result.data.list);
                    renderPagination(result.data);
                    pageQueryParams.pageNum = result.data.pageNum;
                    pageQueryParams.pageSize = result.data.pageSize;
                }
            }, function(result) {
                if (result.msg && result.msg.indexOf('未负责任何楼栋') !== -1) {
                    $('#tableBody').html('<tr><td colspan="9" class="text-center py-4" style="color: var(--accent-2);">您暂未负责任何楼栋，请联系管理员</td></tr>');
                } else {
                    $('#tableBody').html('<tr><td colspan="9" class="text-center py-4"><a href="javascript:void(0)" onclick="loadData(pageQueryParams)" style="color: var(--accent);">加载失败，点击重试</a></td></tr>');
                }
            });
        }

        /**
         * 渲染表格
         * @param {Array} list - 入住记录列表
         */
        function renderTable(list) {
            var $tbody = $('#tableBody');
            $tbody.empty();

            if (!list || list.length === 0) {
                $tbody.html('<tr><td colspan="9" class="text-center py-4 text-muted">暂无数据</td></tr>');
                return;
            }

            list.forEach(function(item) {
                var statusPill = item.checkinStatus === 1
                    ? '<span class="pill pill-active">在住</span>'
                    : '<span class="pill pill-done">已退宿</span>';
                var actionBtn = '';
                if (item.checkinStatus === 1) {
                    actionBtn = '<button class="btn btn-sm btn-primary" onclick="checkout(' + item.checkinId + ')">退宿</button>';
                } else {
                    actionBtn = '<span class="text-muted">-</span>';
                }

                var row = '<tr>';
                row += '<td>' + (item.studentName || '-') + '</td>';
                row += '<td>' + (item.studentNo || '-') + '</td>';
                row += '<td>' + (item.buildingName || '-') + '</td>';
                row += '<td>' + (item.roomNo || '-') + '</td>';
                row += '<td>' + (item.bedNo || '-') + '</td>';
                row += '<td>' + $.formatDate(item.checkinTime) + '</td>';
                row += '<td>' + statusPill + '</td>';
                row += '<td>' + (item.operatorName || '-') + '</td>';
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
            html += '<a class="page-link" href="javascript:void(0)" onclick="goToPage(1)">&laquo;</a></li>';

            html += '<li class="page-item' + (!pageInfo.hasPreviousPage ? ' disabled' : '') + '">';
            html += '<a class="page-link" href="javascript:void(0)" onclick="goToPage(' + (pageInfo.pageNum - 1) + ')">&lsaquo;</a></li>';

            var startPage = Math.max(1, pageInfo.pageNum - 2);
            var endPage = Math.min(pageInfo.pages, pageInfo.pageNum + 2);
            for (var i = startPage; i <= endPage; i++) {
                html += '<li class="page-item' + (pageInfo.pageNum === i ? ' active' : '') + '">';
                html += '<a class="page-link" href="javascript:void(0)" onclick="goToPage(' + i + ')">' + i + '</a></li>';
            }

            html += '<li class="page-item' + (!pageInfo.hasNextPage ? ' disabled' : '') + '">';
            html += '<a class="page-link" href="javascript:void(0)" onclick="goToPage(' + (pageInfo.pageNum + 1) + ')">&rsaquo;</a></li>';

            html += '<li class="page-item' + (pageInfo.pageNum === pageInfo.pages ? ' disabled' : '') + '">';
            html += '<a class="page-link" href="javascript:void(0)" onclick="goToPage(' + pageInfo.pages + ')">&raquo;</a></li>';

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
            $('#searchStudentNo').val('');
            $.updateCselectOptions(document.querySelector('#searchStatusCselect'), [
                {value: '', text: '全部'},
                {value: '1', text: '在住'},
                {value: '2', text: '已退宿'}
            ]);
            search();
        }

        /**
         * 办理退宿
         * @param {number} checkinId - 入住记录ID
         */
        function checkout(checkinId) {
            $.confirm('确定为该学生办理退宿吗？', function() {
                $.ajaxRequest('/dorm/checkin/checkout/' + checkinId, 'POST', null, function(result) {
                    $.toast('success', '退宿办理成功');
                    loadData(pageQueryParams);
                }, function(result) {
                    $.toast('error', result.msg || '退宿办理失败');
                });
            });
        }
    </script>
</body>
</html>
