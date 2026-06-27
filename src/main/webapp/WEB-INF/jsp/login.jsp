<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>高校公寓管理系统 - 登录</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/login.css">
</head>
<body>
<div class="login-container">
    <h2>高校公寓管理系统</h2>
    <form id="loginForm">
        <div class="form-group">
            <label for="username">用户名</label>
            <input type="text" id="username" name="username" placeholder="请输入用户名" required>
        </div>
        <div class="form-group">
            <label for="password">密码</label>
            <input type="password" id="password" name="password" placeholder="请输入密码" required>
        </div>
        <div class="form-group">
            <button type="submit">登录</button>
        </div>
        <div id="errorMsg" class="error-msg"></div>
    </form>
</div>

<script src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/common.js"></script>
<script>
    $(function () {
        // 角色跳转路径映射
        var rolePathMap = {
            1: '/admin/index',
            2: '/dorm/index',
            3: '/student/index'
        };

        $('#loginForm').submit(function (e) {
            e.preventDefault();
            var username = $('#username').val().trim();
            var password = $('#password').val().trim();

            if (!username || !password) {
                $('#errorMsg').text('用户名和密码不能为空');
                return;
            }

            $.ajaxRequest('/login', 'POST', {username: username, password: password}, function (result) {
                // 登录成功，根据角色跳转到对应首页
                var roleType = result.data.roleType;
                var targetUrl = rolePathMap[roleType] || '/login';
                window.location.href = $.buildUrl(targetUrl);
            }, function (result) {
                // 登录失败，显示错误信息
                $('#errorMsg').text(result.msg || '登录失败');
            });
        });
    });
</script>
</body>
</html>
