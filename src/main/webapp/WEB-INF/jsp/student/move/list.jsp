<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>调宿申请 - 高校公寓管理系统</title>
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
                        <h4 style="color: #333; margin-bottom: 8px;">调宿申请</h4>
                        <p style="color: #666; margin: 0;">查看和管理我的调宿申请</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/student/move/applyPage" class="btn btn-primary">
                        <i class="fas fa-plus mr-2"></i>提交新申请
                    </a>
                </div>

                <!-- 调宿申请列表 -->
                <div class="form-container">
                    <div class="table-container">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>原床位</th>
                                    <th>目标床位</th>
                                    <th>申请原因</th>
                                    <th>申请时间</th>
                                    <th>状态</th>
                                    <th>审批意见</th>
                                    <th>操作</th>
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
            $.ajaxRequest('/student/move/page', 'GET', params, function(result) {
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
         * @param {Array} list - 调宿申请列表
         */
        function renderTable(list) {
            var $tbody = $('#tableBody');
            $tbody.empty();

            if (!list || list.length === 0) {
                $tbody.html('<tr><td colspan="7" class="text-center py-4 text-muted"><i class="fas fa-inbox mr-2"></i>暂无调宿申请记录</td></tr>');
                return;
            }

            list.forEach(function(item) {
                var statusBadge = getStatusBadge(item.auditStatus);
                var actionBtn = '';
                if (item.auditStatus === 0) {
                    actionBtn = '<button class="btn btn-sm btn-danger" onclick="cancelApply(' + item.applyId + ')"><i class="fas fa-times mr-1"></i>撤销</button>';
                } else {
                    actionBtn = '<span class="text-muted">-</span>';
                }

                var row = '<tr>';
                row += '<td>' + (item.originalBedInfo || '-') + '</td>';
                row += '<td>' + (item.targetBedInfo || '-') + '</td>';
                row += '<td>' + (item.applyReason || '-') + '</td>';
                row += '<td>' + $.formatDate(item.applyTime) + '</td>';
                row += '<td>' + statusBadge + '</td>';
                row += '<td>' + (item.auditOpinion || '-') + '</td>';
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

        /**
         * 获取状态徽章
         * @param {number} status - 审批状态
         * @returns {string} 状态徽章HTML
         */
        function getStatusBadge(status) {
            var map = {
                0: '<span class="badge bg-warning">待审批</span>',
                1: '<span class="badge bg-success">已通过</span>',
                2: '<span class="badge bg-danger">已驳回</span>'
            };
            return map[status] || '<span class="badge bg-secondary">未知</span>';
        }

        /**
         * 撤销调宿申请
         * @param {number} applyId - 申请ID
         */
        function cancelApply(applyId) {
            $.confirm('确定要撤销该调宿申请吗？撤销后状态将变为"已驳回"。', function() {
                $.ajaxRequest('/student/move/cancel/' + applyId, 'POST', null, function(result) {
                    $.toast('success', '申请已撤销');
                    loadData(pageQueryParams);
                }, function(result) {
                    $.toast('error', result.msg || '撤销失败');
                });
            });
        }
    </script>
</body>
</html>
