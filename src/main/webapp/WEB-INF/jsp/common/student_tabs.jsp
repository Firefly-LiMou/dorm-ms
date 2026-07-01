<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- 学生端水平标签导航 -->
<c:set var="currentUri" value="${requestScope['javax.servlet.forward.request_uri']}" />
<nav class="student-tabs">
    <div class="student-tabs-inner">
        <a href="${pageContext.request.contextPath}/student/index"
           class="student-tab ${currentUri.endsWith('/student/index') ? 'active' : ''}">我的主页</a>
        <a href="${pageContext.request.contextPath}/student/user/info"
           class="student-tab ${currentUri.contains('/student/user/') ? 'active' : ''}">个人信息</a>
        <a href="${pageContext.request.contextPath}/student/checkin/infoPage"
           class="student-tab ${currentUri.contains('/student/checkin/') ? 'active' : ''}">住宿信息</a>
        <a href="${pageContext.request.contextPath}/student/move/list"
           class="student-tab ${currentUri.contains('/student/move/') ? 'active' : ''}">调宿申请</a>
        <a href="${pageContext.request.contextPath}/student/repair/list"
           class="student-tab ${currentUri.contains('/student/repair/') ? 'active' : ''}">报修服务</a>
        <a href="${pageContext.request.contextPath}/student/late-return/list"
           class="student-tab ${currentUri.contains('/student/late-return/') ? 'active' : ''}">晚归记录</a>
    </div>
</nav>
