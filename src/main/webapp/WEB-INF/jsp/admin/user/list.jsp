<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户管理 - 高校公寓管理系统</title>
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
                        <h4 style="color: #333; margin-bottom: 8px;">用户管理</h4>
                        <p style="color: #666; margin: 0;">管理系统中的所有用户账号</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/user/addPage" class="btn btn-primary">
                        <i class="fas fa-plus mr-2"></i>新增用户
                    </a>
                </div>

                <!-- 查询区域 -->
                <div class="form-container mb-4">
                    <form id="searchForm" class="row g-3">
                        <div class="col-md-3">
                            <label for="searchUsername" class="form-label">用户名</label>
                            <input type="text" class="form-control" id="searchUsername" placeholder="请输入用户名">
                        </div>
                        <div class="col-md-3">
                            <label for="searchRealName" class="form-label">姓名</label>
                            <input type="text" class="form-control" id="searchRealName" placeholder="请输入姓名">
                        </div>
                        <div class="col-md-2">
                            <label for="searchRoleType" class="form-label">角色</label>
                            <select class="form-control" id="searchRoleType">
                                <option value="">全部</option>
                                <option value="1">管理员</option>
                                <option value="2">宿管</option>
                                <option value="3">学生</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label for="searchStatus" class="form-label">状态</label>
                            <select class="form-control" id="searchStatus">
                                <option value="">全部</option>
                                <option value="1">正常</option>
                                <option value="0">禁用</option>
                            </select>
                        </div>
                        <div class="col-md-2 d-flex align-items-end gap-2">
                            <button type="button" class="btn btn-primary" onclick="search()">
                                <i class="fas fa-search mr-1"></i>查询
                            </button>
                            <button type="button" class="btn btn-secondary" onclick="resetSearch()">
                                <i class="fas fa-undo mr-1"></i>重置
                            </button>
                        </div>
                    </form>
                </div>

                <!-- 用户列表 -->
                <div class="form-container">
                    <div class="table-container">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>用户名</th>
                                    <th>姓名</th>
                                    <th>角色</th>
                                    <th>性别</th>
                                    <th>联系电话</th>
                                    <th>状态</th>
                                    <th>注册时间</th>
                                    <th>操作</th>
                                </tr>
                            </thead>
                            <tbody id="userTableBody">
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
            // 加载用户列表
            loadData(pageQueryParams);
        });

        /**
         * 加载用户数据
         * @param {object} params - 查询参数
         */
        function loadData(params) {
            // 合并查询参数
            var queryParams = $.extend({}, params, {
                username: $('#searchUsername').val().trim(),
                realName: $('#searchRealName').val().trim(),
                roleType: $('#searchRoleType').val(),
                status: $('#searchStatus').val()
            });

            $.ajaxRequest('/admin/user/page', 'GET', queryParams, function(result) {
                if (result.data) {
                    renderUserTable(result.data.list);
                    renderPagination(result.data);
                    // 更新分页参数
                    pageQueryParams.pageNum = result.data.pageNum;
                    pageQueryParams.pageSize = result.data.pageSize;
                }
            }, function() {
                $('#userTableBody').html('<tr><td colspan="8" class="text-center py-4 text-danger"><a href="javascript:void(0)" onclick="loadData(pageQueryParams)" style="color: #dc3545;"><i class="fas fa-exclamation-circle mr-2"></i>加载失败，点击重试</a></td></tr>');
            });
        }

        /**
         * 渲染用户表格
         * @param {Array} userList - 用户列表
         */
        function renderUserTable(userList) {
            var $tbody = $('#userTableBody');
            $tbody.empty();

            if (!userList || userList.length === 0) {
                $tbody.html('<tr><td colspan="8" class="text-center py-4 text-muted"><i class="fas fa-inbox mr-2"></i>暂无数据</td></tr>');
                return;
            }

            userList.forEach(function(user) {
                var roleText = getRoleText(user.roleType);
                var roleBadge = getRoleBadge(user.roleType);
                var genderText = user.gender === 1 ? '男' : '女';
                var statusHtml = user.status === 1
                    ? '<span class="badge bg-success">正常</span>'
                    : '<span class="badge bg-danger">禁用</span>';
                var toggleBtn = user.status === 1
                    ? '<button class="btn btn-sm btn-warning" onclick="toggleStatus(' + user.userId + ', 0)"><i class="fas fa-ban mr-1"></i>禁用</button>'
                    : '<button class="btn btn-sm btn-success" onclick="toggleStatus(' + user.userId + ', 1)"><i class="fas fa-check mr-1"></i>启用</button>';

                var row = '<tr>';
                row += '<td>' + (user.username || '-') + '</td>';
                row += '<td>' + (user.realName || '-') + '</td>';
                row += '<td><span class="badge ' + roleBadge + '">' + roleText + '</span></td>';
                row += '<td>' + genderText + '</td>';
                row += '<td>' + (user.phone || '-') + '</td>';
                row += '<td>' + statusHtml + '</td>';
                row += '<td>' + $.formatDate(user.createTime) + '</td>';
                row += '<td class="actions">';
                row += '<a href="${pageContext.request.contextPath}/admin/user/editPage?userId=' + user.userId + '" class="btn btn-sm btn-primary"><i class="fas fa-edit mr-1"></i>编辑</a>';
                row += toggleBtn;
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

            // 首页
            html += '<li class="page-item' + (pageInfo.pageNum === 1 ? ' disabled' : '') + '">';
            html += '<a class="page-link" href="javascript:void(0)" onclick="goToPage(1)"><i class="fas fa-angle-double-left"></i></a></li>';

            // 上一页
            html += '<li class="page-item' + (!pageInfo.hasPreviousPage ? ' disabled' : '') + '">';
            html += '<a class="page-link" href="javascript:void(0)" onclick="goToPage(' + (pageInfo.pageNum - 1) + ')"><i class="fas fa-angle-left"></i></a></li>';

            // 页码
            var startPage = Math.max(1, pageInfo.pageNum - 2);
            var endPage = Math.min(pageInfo.pages, pageInfo.pageNum + 2);
            for (var i = startPage; i <= endPage; i++) {
                html += '<li class="page-item' + (pageInfo.pageNum === i ? ' active' : '') + '">';
                html += '<a class="page-link" href="javascript:void(0)" onclick="goToPage(' + i + ')">' + i + '</a></li>';
            }

            // 下一页
            html += '<li class="page-item' + (!pageInfo.hasNextPage ? ' disabled' : '') + '">';
            html += '<a class="page-link" href="javascript:void(0)" onclick="goToPage(' + (pageInfo.pageNum + 1) + ')"><i class="fas fa-angle-right"></i></a></li>';

            // 末页
            html += '<li class="page-item' + (pageInfo.pageNum === pageInfo.pages ? ' disabled' : '') + '">';
            html += '<a class="page-link" href="javascript:void(0)" onclick="goToPage(' + pageInfo.pages + ')"><i class="fas fa-angle-double-right"></i></a></li>';

            html += '</ul></nav></div></div>';
            $container.html(html);
        }

        /**
         * 跳转到指定页
         * @param {number} pageNum - 页码
         */
        function goToPage(pageNum) {
            pageQueryParams.pageNum = pageNum;
            loadData(pageQueryParams);
        }

        /**
         * 切换每页条数
         * @param {number} pageSize - 每页条数
         */
        function changePageSize(pageSize) {
            pageQueryParams.pageNum = 1;
            pageQueryParams.pageSize = parseInt(pageSize);
            loadData(pageQueryParams);
        }

        /**
         * 查询
         */
        function search() {
            pageQueryParams.pageNum = 1;
            loadData(pageQueryParams);
        }

        /**
         * 重置查询条件
         */
        function resetSearch() {
            $('#searchUsername').val('');
            $('#searchRealName').val('');
            $('#searchRoleType').val('');
            $('#searchStatus').val('');
            search();
        }

        /**
         * 切换用户状态
         * @param {number} userId - 用户ID
         * @param {number} action - 操作：1-启用，0-禁用
         */
        function toggleStatus(userId, action) {
            var actionText = action === 1 ? '启用' : '禁用';
            $.confirm('确定要' + actionText + '该用户吗？', function() {
                $.ajaxRequest('/admin/user/toggleStatus/' + userId, 'POST', null, function(result) {
                    $.toast('success', actionText + '成功');
                    loadData(pageQueryParams);
                }, function(result) {
                    $.toast('error', result.msg || actionText + '失败');
                });
            });
        }

        /**
         * 获取角色文本
         * @param {number} roleType - 角色类型
         * @returns {string} 角色文本
         */
        function getRoleText(roleType) {
            var roleMap = {1: '管理员', 2: '宿管', 3: '学生'};
            return roleMap[roleType] || '-';
        }

        /**
         * 获取角色徽章样式
         * @param {number} roleType - 角色类型
         * @returns {string} 徽章样式类
         */
        function getRoleBadge(roleType) {
            var badgeMap = {1: 'bg-primary', 2: 'bg-success', 3: 'bg-info'};
            return badgeMap[roleType] || 'bg-secondary';
        }
    </script>
</body>
</html>
