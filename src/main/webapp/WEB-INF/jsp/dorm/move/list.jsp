<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>调宿管理 - 高校公寓管理系统</title>
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
                    <h4 style="color: #333; margin-bottom: 8px;">调宿管理</h4>
                    <p style="color: #666; margin: 0;">审批本楼栋学生的调宿申请</p>
                </div>

                <!-- 查询区域 -->
                <div class="form-container mb-4">
                    <form id="searchForm" class="row g-3">
                        <div class="col-md-3">
                            <label for="searchStatus" class="form-label">审批状态</label>
                            <select class="form-control" id="searchStatus">
                                <option value="">全部</option>
                                <option value="0">待审批</option>
                                <option value="1">已通过</option>
                                <option value="2">已驳回</option>
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

                <!-- 调宿申请列表 -->
                <div class="form-container">
                    <div class="table-container">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>学生姓名</th>
                                    <th>学号</th>
                                    <th>原床位</th>
                                    <th>目标床位</th>
                                    <th>申请原因</th>
                                    <th>申请时间</th>
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

    <!-- 审批模态框 -->
    <div class="modal fade" id="auditModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">审批调宿申请</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <!-- 申请详情 -->
                    <div class="mb-3">
                        <h6>申请信息</h6>
                        <table class="table table-bordered">
                            <tr>
                                <td class="bg-light" style="width: 120px;">申请人</td>
                                <td id="auditStudentName"></td>
                            </tr>
                            <tr>
                                <td class="bg-light">原床位</td>
                                <td id="auditOriginalBed"></td>
                            </tr>
                            <tr>
                                <td class="bg-light">目标床位</td>
                                <td id="auditTargetBed"></td>
                            </tr>
                            <tr>
                                <td class="bg-light">申请原因</td>
                                <td id="auditReason"></td>
                            </tr>
                            <tr>
                                <td class="bg-light">申请时间</td>
                                <td id="auditTime"></td>
                            </tr>
                        </table>
                    </div>
                    <!-- 审批表单 -->
                    <form id="auditForm">
                        <input type="hidden" id="auditApplyId">
                        <div class="mb-3">
                            <label class="form-label">审批结果 <span class="text-danger">*</span></label>
                            <div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="auditStatus" id="auditPass" value="1" checked>
                                    <label class="form-check-label" for="auditPass">通过</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="auditStatus" id="auditReject" value="2">
                                    <label class="form-check-label" for="auditReject">驳回</label>
                                </div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="auditOpinion" class="form-label">审批意见</label>
                            <textarea class="form-control" id="auditOpinion" rows="3" placeholder="可选填审批意见" maxlength="255"></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="button" class="btn btn-primary" id="btnAuditSubmit" onclick="submitAudit()">确认提交</button>
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
                auditStatus: $('#searchStatus').val() || null
            });

            $.ajaxRequest('/dorm/move/page', 'GET', queryParams, function(result) {
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
         * @param {Array} list - 调宿申请列表
         */
        function renderTable(list) {
            var $tbody = $('#tableBody');
            $tbody.empty();

            if (!list || list.length === 0) {
                $tbody.html('<tr><td colspan="8" class="text-center py-4 text-muted"><i class="fas fa-inbox mr-2"></i>暂无数据</td></tr>');
                return;
            }

            list.forEach(function(item) {
                var statusBadge = getStatusBadge(item.auditStatus);
                var actionBtn = '';
                if (item.auditStatus === 0) {
                    actionBtn = '<button class="btn btn-sm btn-primary" onclick="showAuditModal(' + item.applyId + ')"><i class="fas fa-gavel mr-1"></i>审批</button>';
                } else {
                    actionBtn = '<span class="text-muted">已处理</span>';
                }

                var row = '<tr>';
                row += '<td>' + (item.studentName || '-') + '</td>';
                row += '<td>' + (item.studentNo || '-') + '</td>';
                row += '<td>' + (item.originalBedInfo || '-') + '</td>';
                row += '<td>' + (item.targetBedInfo || '-') + '</td>';
                row += '<td>' + (item.applyReason || '-') + '</td>';
                row += '<td>' + $.formatDate(item.applyTime) + '</td>';
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
            $('#searchStatus').val('');
            search();
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
         * 显示审批模态框
         * @param {number} applyId - 申请ID
         */
        function showAuditModal(applyId) {
            $.ajaxRequest('/dorm/move/' + applyId, 'GET', null, function(result) {
                if (result.data) {
                    var apply = result.data;
                    $('#auditApplyId').val(apply.applyId);
                    $('#auditStudentName').text(apply.studentName + ' (' + apply.studentNo + ')');
                    $('#auditOriginalBed').text(apply.originalBedInfo || '-');
                    $('#auditTargetBed').text(apply.targetBedInfo || '-');
                    $('#auditReason').text(apply.applyReason || '-');
                    $('#auditTime').text($.formatDate(apply.applyTime));
                    $('#auditPass').prop('checked', true);
                    $('#auditOpinion').val('');
                    $('#auditModal').modal('show');
                }
            }, function(result) {
                $.toast('error', result.msg || '加载申请详情失败');
            });
        }

        /**
         * 提交审批
         */
        function submitAudit() {
            var applyId = $('#auditApplyId').val();
            var auditStatus = $('input[name="auditStatus"]:checked').val();
            var auditOpinion = $('#auditOpinion').val().trim();

            var formData = {
                auditStatus: parseInt(auditStatus),
                auditOpinion: auditOpinion || null
            };

            $('#btnAuditSubmit').prop('disabled', true).text('提交中...');

            $.ajaxRequest('/dorm/move/audit/' + applyId, 'POST', formData, function(result) {
                $.toast('success', '审批提交成功');
                $('#auditModal').modal('hide');
                $('#btnAuditSubmit').prop('disabled', false).text('确认提交');
                loadData(pageQueryParams);
            }, function(result) {
                $.toast('error', result.msg || '审批提交失败');
                $('#btnAuditSubmit').prop('disabled', false).text('确认提交');
            });
        }
    </script>
</body>
</html>
