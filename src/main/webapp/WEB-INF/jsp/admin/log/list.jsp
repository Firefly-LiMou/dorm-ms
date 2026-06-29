<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>操作日志 - 高校公寓管理系统</title>
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
                        <h1>操作日志</h1>
                        <p class="page-meta">查看系统操作记录</p>
                    </div>
                </div>

                <div class="filter-bar">
                    <div class="filter-field">
                        <label>操作人ID</label>
                        <input type="text" id="searchOperatorId" placeholder="请输入操作人ID">
                    </div>
                    <div class="filter-field">
                        <label>操作模块</label>
                        <div class="cselect">
                            <select id="searchModuleName">
                                <option value="">全部</option>
                                <option value="用户管理">用户管理</option>
                                <option value="楼栋管理">楼栋管理</option>
                                <option value="房间管理">房间管理</option>
                                <option value="床位管理">床位管理</option>
                                <option value="入住管理">入住管理</option>
                                <option value="调宿管理">调宿管理</option>
                                <option value="报修管理">报修管理</option>
                                <option value="晚归登记">晚归登记</option>
                                <option value="访客登记">访客登记</option>
                                <option value="用户认证">用户认证</option>
                                <option value="个人信息">个人信息</option>
                            </select>
                        </div>
                    </div>
                    <div class="filter-field">
                        <label>操作类型</label>
                        <div class="cselect">
                            <select id="searchOperType">
                                <option value="">全部</option>
                                <option value="新增">新增</option>
                                <option value="修改">修改</option>
                                <option value="删除">删除</option>
                                <option value="审批">审批</option>
                                <option value="登录">登录</option>
                                <option value="登出">登出</option>
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
                            <tr><td colspan="7" class="text-center" style="padding: 40px 0; color: var(--muted);">加载中...</td></tr>
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
                    $.renderPagination(result.data, 'paginationContainer', function(page) {
                        pageQueryParams.pageNum = page;
                        loadData(pageQueryParams);
                    });
                    pageQueryParams.pageNum = result.data.pageNum;
                    pageQueryParams.pageSize = result.data.pageSize;
                }
            }, function() {
                $('#tableBody').html('<tr><td colspan="7" class="text-center" style="padding: 40px 0;"><a href="javascript:void(0)" onclick="loadData(pageQueryParams)" style="color: var(--accent);">加载失败，点击重试</a></td></tr>');
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
                $tbody.html('<tr><td colspan="7" class="text-center" style="padding: 40px 0; color: var(--muted);">暂无数据</td></tr>');
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
         * 获取操作类型徽章
         * @param {string} operType - 操作类型
         * @returns {string} 状态徽章HTML
         */
        function getOperTypeBadge(operType) {
            var map = {
                '新增': '<span class="pill pill-done">新增</span>',
                '修改': '<span class="pill pill-admin">修改</span>',
                '删除': '<span class="pill pill-danger">删除</span>',
                '审批': '<span class="pill pill-pending">审批</span>',
                '登录': '<span class="pill pill-processing">登录</span>',
                '登出': '<span class="pill pill-quiet">登出</span>'
            };
            return map[operType] || '<span class="pill pill-quiet">' + (operType || '-') + '</span>';
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
    </script>
</body>
</html>
