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
<script>
    $(function () {
        $('#loginForm').submit(function (e) {
            e.preventDefault();
            var username = $('#username').val();
            var password = $('#password').val();

            if (!username || !password) {
                $('#errorMsg').text('用户名和密码不能为空');
                return;
            }

            $.ajax({
                url: '${pageContext.request.contextPath}/login',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({username: username, password: password}),
                success: function (result) {
                    if (result.code === 200) {
                        // 判断是否需要强制修改密码
                        checkNeedChangePassword(result.data);
                    } else {
                        $('#errorMsg').text(result.msg);
                    }
                },
                error: function () {
                    $('#errorMsg').text('登录失败，请稍后重试');
                }
            });
        });

        function checkNeedChangePassword(user) {
            $.ajax({
                url: '${pageContext.request.contextPath}/needChangePassword',
                type: 'GET',
                success: function (result) {
                    if (result.code === 200 && result.data) {
                        alert('首次登录请修改密码');
                        // 跳转到修改密码页面（根据角色跳转不同页面）
                        if (user.roleType === 1) {
                            window.location.href = '${pageContext.request.contextPath}/admin/user/list';
                        } else if (user.roleType === 2) {
                            window.location.href = '${pageContext.request.contextPath}/dorm/building/list';
                        } else {
                            window.location.href = '${pageContext.request.contextPath}/student/user/info';
                        }
                    } else {
                        // 跳转到首页（根据角色跳转不同页面）
                        if (user.roleType === 1) {
                            window.location.href = '${pageContext.request.contextPath}/admin/user/list';
                        } else if (user.roleType === 2) {
                            window.location.href = '${pageContext.request.contextPath}/dorm/building/list';
                        } else {
                            window.location.href = '${pageContext.request.contextPath}/student/user/info';
                        }
                    }
                }
            });
        }
    });
</script>
</body>
</html>
