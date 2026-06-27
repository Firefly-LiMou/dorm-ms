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
    <div class="pagination-info">
        共 <span id="totalCount">${pageInfo.total}</span> 条记录，
        第 <span id="currentPage">${pageInfo.pageNum}</span>/<span id="totalPages">${pageInfo.pages}</span> 页
    </div>

    <!-- 分页控件 -->
    <div class="d-flex align-items-center gap-3">
        <!-- 每页条数选择 -->
        <div class="page-size-select">
            <label>每页</label>
            <select id="pageSizeSelect" onchange="changePageSize(this.value)">
                <option value="10" ${pageInfo.pageSize == 10 ? 'selected' : ''}>10</option>
                <option value="20" ${pageInfo.pageSize == 20 ? 'selected' : ''}>20</option>
                <option value="50" ${pageInfo.pageSize == 50 ? 'selected' : ''}>50</option>
            </select>
            <label>条</label>
        </div>

        <!-- 分页按钮 -->
        <nav>
            <ul class="pagination mb-0">
                <!-- 首页 -->
                <li class="page-item ${pageInfo.pageNum == 1 ? 'disabled' : ''}">
                    <a class="page-link" href="javascript:void(0)" onclick="goToPage(1)" title="首页">
                        <i class="fas fa-angle-double-left"></i>
                    </a>
                </li>

                <!-- 上一页 -->
                <li class="page-item ${!pageInfo.hasPreviousPage ? 'disabled' : ''}">
                    <a class="page-link" href="javascript:void(0)" onclick="goToPage(${pageInfo.pageNum - 1})" title="上一页">
                        <i class="fas fa-angle-left"></i>
                    </a>
                </li>

                <!-- 页码 -->
                <c:choose>
                    <c:when test="${pageInfo.pages <= 7}">
                        <!-- 总页数小于等于7，显示所有页码 -->
                        <c:forEach begin="1" end="${pageInfo.pages}" var="i">
                            <li class="page-item ${pageInfo.pageNum == i ? 'active' : ''}">
                                <a class="page-link" href="javascript:void(0)" onclick="goToPage(${i})">${i}</a>
                            </li>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <!-- 总页数大于7，显示部分页码 -->
                        <c:choose>
                            <c:when test="${pageInfo.pageNum <= 4}">
                                <!-- 当前页在前面 -->
                                <c:forEach begin="1" end="5" var="i">
                                    <li class="page-item ${pageInfo.pageNum == i ? 'active' : ''}">
                                        <a class="page-link" href="javascript:void(0)" onclick="goToPage(${i})">${i}</a>
                                    </li>
                                </c:forEach>
                                <li class="page-item disabled"><span class="page-link">...</span></li>
                                <li class="page-item">
                                    <a class="page-link" href="javascript:void(0)" onclick="goToPage(${pageInfo.pages})">${pageInfo.pages}</a>
                                </li>
                            </c:when>
                            <c:when test="${pageInfo.pageNum >= pageInfo.pages - 3}">
                                <!-- 当前页在后面 -->
                                <li class="page-item">
                                    <a class="page-link" href="javascript:void(0)" onclick="goToPage(1)">1</a>
                                </li>
                                <li class="page-item disabled"><span class="page-link">...</span></li>
                                <c:forEach begin="${pageInfo.pages - 4}" end="${pageInfo.pages}" var="i">
                                    <li class="page-item ${pageInfo.pageNum == i ? 'active' : ''}">
                                        <a class="page-link" href="javascript:void(0)" onclick="goToPage(${i})">${i}</a>
                                    </li>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <!-- 当前页在中间 -->
                                <li class="page-item">
                                    <a class="page-link" href="javascript:void(0)" onclick="goToPage(1)">1</a>
                                </li>
                                <li class="page-item disabled"><span class="page-link">...</span></li>
                                <c:forEach begin="${pageInfo.pageNum - 1}" end="${pageInfo.pageNum + 1}" var="i">
                                    <li class="page-item ${pageInfo.pageNum == i ? 'active' : ''}">
                                        <a class="page-link" href="javascript:void(0)" onclick="goToPage(${i})">${i}</a>
                                    </li>
                                </c:forEach>
                                <li class="page-item disabled"><span class="page-link">...</span></li>
                                <li class="page-item">
                                    <a class="page-link" href="javascript:void(0)" onclick="goToPage(${pageInfo.pages})">${pageInfo.pages}</a>
                                </li>
                            </c:otherwise>
                        </c:choose>
                    </c:otherwise>
                </c:choose>

                <!-- 下一页 -->
                <li class="page-item ${!pageInfo.hasNextPage ? 'disabled' : ''}">
                    <a class="page-link" href="javascript:void(0)" onclick="goToPage(${pageInfo.pageNum + 1})" title="下一页">
                        <i class="fas fa-angle-right"></i>
                    </a>
                </li>

                <!-- 末页 -->
                <li class="page-item ${pageInfo.pageNum == pageInfo.pages ? 'disabled' : ''}">
                    <a class="page-link" href="javascript:void(0)" onclick="goToPage(${pageInfo.pages})" title="末页">
                        <i class="fas fa-angle-double-right"></i>
                    </a>
                </li>
            </ul>
        </nav>
    </div>
</div>

<script>
    /**
     * 跳转到指定页
     * @param {number} pageNum - 页码
     */
    function goToPage(pageNum) {
        // 边界检查
        if (pageNum < 1 || pageNum > ${pageInfo.pages}) {
            return;
        }

        // 获取查询参数
        var queryParams = window.pageQueryParams || {};

        // 更新页码
        queryParams.pageNum = pageNum;
        queryParams.pageSize = ${pageInfo.pageSize};

        // 调用页面的查询函数
        if (typeof window.loadData === 'function') {
            window.loadData(queryParams);
        } else {
            $.toast('error', '页面加载异常');
        }
    }

    /**
     * 切换每页条数
     * @param {number} pageSize - 每页条数
     */
    function changePageSize(pageSize) {
        // 获取查询参数
        var queryParams = window.pageQueryParams || {};

        // 更新分页参数
        queryParams.pageNum = 1;
        queryParams.pageSize = parseInt(pageSize);

        // 调用页面的查询函数
        if (typeof window.loadData === 'function') {
            window.loadData(queryParams);
        } else {
            $.toast('error', '页面加载异常');
        }
    }
</script>
