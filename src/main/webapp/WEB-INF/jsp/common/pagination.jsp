<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
    分页组件
    使用说明：
    1. 在页面中引入此文件：<%@ include file="/WEB-INF/jsp/common/pagination.jsp" %>
    2. 需要传入以下参数：
       - pageInfo: PageInfo对象（由后端返回）
       - pageUrl: 分页请求的基础URL（如：/admin/user/page）
       - queryParams: 查询参数对象（可选）
--%>

<div class="pagination-container">
    <!-- 分页信息 -->
    <span class="pagination-info">
        共 <strong>${pageInfo.total}</strong> 条记录，
        第 <strong>${pageInfo.pageNum}</strong> / <strong>${pageInfo.pages}</strong> 页
    </span>

    <!-- 分页控件 -->
    <div class="d-flex align-items-center pagination-controls">
        <!-- 每页条数选择 -->
        <div class="page-size-select">
            <label>每页</label>
            <div class="cselect" id="pageSizeCselect" style="min-width: 70px;">
                <div class="cselect-trigger" tabindex="0" aria-haspopup="listbox" aria-expanded="false" style="padding: 4px 8px;">
                    <span class="cselect-val">${pageInfo.pageSize}</span>
                    <svg class="cselect-arrow" viewBox="0 0 24 24" width="12" height="12" stroke="currentColor" stroke-width="1.6" fill="none" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg>
                </div>
                <div class="cselect-panel" role="listbox">
                    <div class="cselect-option ${pageInfo.pageSize == 10 ? 'selected' : ''}" data-value="10">10</div>
                    <div class="cselect-option ${pageInfo.pageSize == 20 ? 'selected' : ''}" data-value="20">20</div>
                    <div class="cselect-option ${pageInfo.pageSize == 50 ? 'selected' : ''}" data-value="50">50</div>
                </div>
            </div>
            <label>条</label>
        </div>

        <!-- 分页按钮 -->
        <div class="pagination-pages">
            <!-- 首页 -->
            <button class="page-btn" ${pageInfo.pageNum == 1 ? 'disabled' : ''} onclick="goToPage(1)" title="首页">&laquo;</button>

            <!-- 上一页 -->
            <button class="page-btn" ${!pageInfo.hasPreviousPage ? 'disabled' : ''} onclick="goToPage(${pageInfo.pageNum - 1})" title="上一页">&lsaquo;</button>

            <!-- 页码 -->
            <c:choose>
                <c:when test="${pageInfo.pages <= 7}">
                    <c:forEach begin="1" end="${pageInfo.pages}" var="i">
                        <button class="page-btn ${pageInfo.pageNum == i ? 'active' : ''}" onclick="goToPage(${i})">${i}</button>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <c:choose>
                        <c:when test="${pageInfo.pageNum <= 4}">
                            <c:forEach begin="1" end="5" var="i">
                                <button class="page-btn ${pageInfo.pageNum == i ? 'active' : ''}" onclick="goToPage(${i})">${i}</button>
                            </c:forEach>
                            <span class="page-ellipsis">...</span>
                            <button class="page-btn" onclick="goToPage(${pageInfo.pages})">${pageInfo.pages}</button>
                        </c:when>
                        <c:when test="${pageInfo.pageNum >= pageInfo.pages - 3}">
                            <button class="page-btn" onclick="goToPage(1)">1</button>
                            <span class="page-ellipsis">...</span>
                            <c:forEach begin="${pageInfo.pages - 4}" end="${pageInfo.pages}" var="i">
                                <button class="page-btn ${pageInfo.pageNum == i ? 'active' : ''}" onclick="goToPage(${i})">${i}</button>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <button class="page-btn" onclick="goToPage(1)">1</button>
                            <span class="page-ellipsis">...</span>
                            <c:forEach begin="${pageInfo.pageNum - 1}" end="${pageInfo.pageNum + 1}" var="i">
                                <button class="page-btn ${pageInfo.pageNum == i ? 'active' : ''}" onclick="goToPage(${i})">${i}</button>
                            </c:forEach>
                            <span class="page-ellipsis">...</span>
                            <button class="page-btn" onclick="goToPage(${pageInfo.pages})">${pageInfo.pages}</button>
                        </c:otherwise>
                    </c:choose>
                </c:otherwise>
            </c:choose>

            <!-- 下一页 -->
            <button class="page-btn" ${!pageInfo.hasNextPage ? 'disabled' : ''} onclick="goToPage(${pageInfo.pageNum + 1})" title="下一页">&rsaquo;</button>

            <!-- 末页 -->
            <button class="page-btn" ${pageInfo.pageNum == pageInfo.pages ? 'disabled' : ''} onclick="goToPage(${pageInfo.pages})" title="末页">&raquo;</button>
        </div>
    </div>
</div>

<script>
    $(function() {
        $.initCustomSelect();
        document.querySelector('#pageSizeCselect').addEventListener('cselect:change', function(e) {
            changePageSize(e.detail.value);
        });
    });

    /**
     * 跳转到指定页
     */
    function goToPage(pageNum) {
        if (pageNum < 1 || pageNum > ${pageInfo.pages}) return;
        var queryParams = window.pageQueryParams || {};
        queryParams.pageNum = pageNum;
        queryParams.pageSize = ${pageInfo.pageSize};
        if (typeof window.loadData === 'function') {
            window.loadData(queryParams);
        } else {
            $.toast('error', '页面加载异常');
        }
    }

    /**
     * 切换每页条数
     */
    function changePageSize(pageSize) {
        var queryParams = window.pageQueryParams || {};
        queryParams.pageNum = 1;
        queryParams.pageSize = parseInt(pageSize);
        if (typeof window.loadData === 'function') {
            window.loadData(queryParams);
        } else {
            $.toast('error', '页面加载异常');
        }
    }
</script>
