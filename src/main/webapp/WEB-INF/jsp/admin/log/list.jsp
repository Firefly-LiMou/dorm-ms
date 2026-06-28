<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>操作日志 - 高校公寓管理系统</title>
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
                    <h4 style="color: #333; margin-bottom: 8px;">操作日志</h4>
                    <p style="color: #666; margin: 0;">查看系统操作记录</p>
                </div>

                <!-- 查询区域 -->
                <div class="form-container mb-4">
                    <form id="searchForm" class="row g-3">
                        <div class="col-md-2">
                            <label for="searchOperatorId" class="form-label">操作人ID</label>
                            <input type="text" class="form-control" id="searchOperatorId" placeholder="请输入操作人ID">
                        </div>
                        <div class="col-md-3">
                            <label for="searchModuleName" class="form-label">操作模块</label>
                            <select class="form-control" id="searchModuleName">
                                <option value="">全部</option>
                                <option value="楼栋管理">楼栋管理</option>
                                <option value="房间管理">房间管理</option>
                                <option value="床位管理">床位管理</option>
                                <option value="入住管理">入住管理</option>
                                <option value="调宿管理">调宿管理</option>
                                <option value="报修管理">报修管理</option>
                                <option value="晚归管理">晚归管理</option>
                                <option value="访客管理">访客管理</option>
                                <option value="用户认证">用户认证</option>
                                <option value="个人信息">个人信息</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label for="searchOperType" class="form-label">操作类型</label>
                            <select class="form-control" id="searchOperType">
                                <option value="">全部</option>
                                <option value="新增">新增</option>
                                <option value="修改">修改</option>
                                <option value="删除">删除</option>
                                <option value="审批">审批</option>
                                <option value="登录">登录</option>
                                <option value="登出">登出</option>
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

                <!-- 操作日志列表 -->
                <div class="form-container">
                    <div class="table-container">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>操作人ID</th>
                                    <th>操作模块</th>
                                    <th>操作类型</th>
                                    <th>操作描述</th>
                                    <th>操作IP</th>
                                    <th>请求参数</th>
                                    <th>操作时间</th>
                                </tr>
                            </thead>
                            <tbody id="tableBody">
                                <tr>
                                    <td colspan="7" class="text-center py-4">
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
            var queryParams = {
                pageNum: params.pageNum || 1,
                pageSize: params.pageSize || 10
            };

            var operatorId = $('#searchOperatorId').val().trim();
            var moduleName = $('#searchModuleName').val();
            var operType = $('#searchOperType').val();

            if (operatorId) {
                queryParams.operatorId = operatorId;
            }
            if (moduleName) {
                queryParams.moduleName = moduleName;
            }
            if (operType) {
                queryParams.operType = operType;
            }

            $.ajaxRequest('/admin/log/page', 'GET', queryParams, function(result) {
                if (result.data) {
                    renderTable(result.data.list);
                    renderPagination(result.data);
                    pageQueryParams.pageNum = result.data.pageNum;
                    pageQueryParams.pageSize = result.data.pageSize;
                }
            }, function() {
                $('#tableBody').html('<tr><td colspan="7" class="text-center py-4 text-danger"><a href="javascript:void(0)" onclick="loadData(pageQueryParams)" style="color: #dc3545;"><i class="fas fa-exclamation-circle mr-2"></i>加载失败，点击重试</a></td></tr>');
            });
        }

        /**
         * 渲染表格
         * @param {Array} list - 操作日志列表
         */
        function renderTable(list) {
            var $tbody = $('#tableBody');
            $tbody.empty();

            if (!list || list.length === 0) {
                $tbody.html('<tr><td colspan="7" class="text-center py-4 text-muted"><i class="fas fa-inbox mr-2"></i>暂无数据</td></tr>');
                return;
            }

            list.forEach(function(item) {
                var operTypeBadge = getOperTypeBadge(item.operType);
                var requestParam = item.requestParam || '-';
                var requestParamDisplay = requestParam.length > 50 ? requestParam.substring(0, 50) + '...' : requestParam;
                var requestParamTitle = requestParam !== '-' ? ' title="' + escapeHtml(requestParam) + '"' : '';

                var row = '<tr>';
                row += '<td>' + (item.operatorId || '-') + '</td>';
                row += '<td>' + (item.moduleName || '-') + '</td>';
                row += '<td>' + operTypeBadge + '</td>';
                row += '<td>' + (item.operDesc || '-') + '</td>';
                row += '<td>' + (item.operIp || '-') + '</td>';
                row += '<td' + requestParamTitle + '><span class="text-truncate" style="max-width: 200px; display: inline-block;">' + escapeHtml(requestParamDisplay) + '</span></td>';
                row += '<td>' + $.formatDate(item.operTime) + '</td>';
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
            $('#searchOperatorId').val('');
            $('#searchModuleName').val('');
            $('#searchOperType').val('');
            search();
        }

        /**
         * 获取操作类型徽章
         * @param {string} operType - 操作类型
         * @returns {string} 状态徽章HTML
         */
        function getOperTypeBadge(operType) {
            var map = {
                '新增': '<span class="badge bg-success">新增</span>',
                '修改': '<span class="badge bg-primary">修改</span>',
                '删除': '<span class="badge bg-danger">删除</span>',
                '审批': '<span class="badge bg-warning">审批</span>',
                '登录': '<span class="badge bg-info">登录</span>',
                '登出': '<span class="badge bg-secondary">登出</span>'
            };
            return map[operType] || '<span class="badge bg-secondary">' + (operType || '-') + '</span>';
        }

        /**
         * HTML转义
         * @param {string} str - 原始字符串
         * @returns {string} 转义后的字符串
         */
        function escapeHtml(str) {
            if (!str) return '';
            return str.replace(/&/g, '&amp;')
                      .replace(/</g, '&lt;')
                      .replace(/>/g, '&gt;')
                      .replace(/"/g, '&quot;')
                      .replace(/'/g, '&#039;');
        }
    </script>
</body>
</html>
