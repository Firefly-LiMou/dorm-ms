<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>编辑用户 - 高校公寓管理系统</title>
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
                        <h1>编辑用户</h1>
                        <p class="page-meta">修改用户信息</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/user/list" class="btn btn-secondary">
                        返回列表
                    </a>
                </div>

                <div class="form-container">
                    <form id="userForm" novalidate>
                        <input type="hidden" id="userId" name="userId">
                        <div class="form-grid">
                            <div class="form-field">
                                <label>用户名</label>
                                <input type="text" class="form-control" id="username" name="username" readonly>
                                <span class="form-hint">用户名不可修改</span>
                            </div>
                            <div class="form-field">
                                <label>真实姓名 <span class="required">*</span></label>
                                <input type="text" class="form-control" id="realName" name="realName" placeholder="请输入真实姓名" maxlength="20">
                            </div>
                            <div class="form-field">
                                <label>角色类型 <span class="required">*</span></label>
                                <select class="form-control" id="roleType" name="roleType">
                                    <option value="">请选择角色</option>
                                    <option value="1">管理员</option>
                                    <option value="2">宿管</option>
                                    <option value="3">学生</option>
                                </select>
                            </div>
                            <div class="form-field">
                                <label>性别</label>
                                <select class="form-control" id="gender" name="gender">
                                    <option value="">请选择性别</option>
                                    <option value="1">男</option>
                                    <option value="2">女</option>
                                </select>
                            </div>
                            <div class="form-field">
                                <label>联系电话</label>
                                <input type="text" class="form-control" id="phone" name="phone" placeholder="请输入联系电话" maxlength="11">
                            </div>
                            <div class="form-field">
                                <label>账号状态</label>
                                <select class="form-control" id="status" name="status">
                                    <option value="1">正常</option>
                                    <option value="0">禁用</option>
                                </select>
                            </div>
                        </div>

                        <!-- 学生专属字段 -->
                        <div id="studentFields" style="display: none; margin-top: var(--gap-md);">
                            <div style="border-top: 1px solid var(--border); padding-top: var(--gap-md); margin-bottom: var(--gap-md);">
                                <span style="font-family: var(--font-mono); font-size: var(--fs-sm); letter-spacing: 0.04em; text-transform: uppercase; color: var(--muted);">学生信息</span>
                            </div>
                            <div class="form-grid">
                                <div class="form-field">
                                    <label>年级</label>
                                    <input type="text" class="form-control" id="grade" name="grade" placeholder="如：2024">
                                </div>
                                <div class="form-field">
                                    <label>专业</label>
                                    <input type="text" class="form-control" id="major" name="major" placeholder="请输入专业">
                                </div>
                                <div class="form-field full">
                                    <label>班级</label>
                                    <input type="text" class="form-control" id="className" name="className" placeholder="请输入班级">
                                </div>
                            </div>
                        </div>

                        <div style="margin-top: var(--gap-lg); display: flex; gap: var(--gap-sm);">
                            <button type="submit" class="btn btn-primary" id="btnSubmit">保存</button>
                            <a href="${pageContext.request.contextPath}/admin/user/list" class="btn btn-secondary">取消</a>
                        </div>
                    </form>
                </div>
            </div>

            <%@ include file="/WEB-INF/jsp/common/footer.jsp" %>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/jquery.validate.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/messages_zh.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/common.js"></script>
    <script>window.needChangePasswordFlag = '${sessionScope.needChangePassword}';</script>
    <script src="${pageContext.request.contextPath}/static/js/header.js"></script>

    <script>
        $(function() {
            // 从URL获取userId
            var urlParams = new URLSearchParams(window.location.search);
            var userId = urlParams.get('userId');

            if (!userId) {
                $.toast('error', '缺少用户ID参数');
                setTimeout(function() {
                    window.location.href = $.buildUrl('/admin/user/list');
                }, 1000);
                return;
            }

            // 加载用户数据
            loadUserData(userId);

            // 角色类型变化时显示/隐藏学生字段
            $('#roleType').on('change', function() {
                if ($(this).val() === '3') {
                    $('#studentFields').show();
                } else {
                    $('#studentFields').hide();
                }
            });

            // 自定义手机号验证方法（允许为空，有值时验证格式）
            $.validator.addMethod('phonePattern', function(value, element) {
                return this.optional(element) || /^1[3-9]\d{9}$/.test(value);
            }, '请输入正确的手机号码');

            // 表单验证
            $('#userForm').validate({
                rules: {
                    realName: {
                        required: true,
                        maxlength: 20
                    },
                    roleType: {
                        required: true
                    },
                    phone: {
                        phonePattern: true
                    }
                },
                messages: {
                    realName: {
                        required: '请输入真实姓名',
                        maxlength: '真实姓名长度不能超过20个字符'
                    },
                    roleType: {
                        required: '请选择角色类型'
                    }
                },
                submitHandler: function(form) {
                    submitForm();
                }
            });
        });

        /**
         * 加载用户数据
         * @param {number} userId - 用户ID
         */
        function loadUserData(userId) {
            $.ajaxRequest('/admin/user/detail/' + userId, 'GET', null, function(result) {
                if (result.data) {
                    var user = result.data;
                    $('#userId').val(user.userId);
                    $('#username').val(user.username);
                    $('#realName').val(user.realName);
                    $('#roleType').val(user.roleType);
                    $('#gender').val(user.gender || '');
                    $('#phone').val(user.phone || '');
                    $('#status').val(user.status);
                    $('#grade').val(user.grade || '');
                    $('#major').val(user.major || '');
                    $('#className').val(user.className || '');

                    // 显示学生字段
                    if (user.roleType === 3) {
                        $('#studentFields').show();
                    }
                }
            }, function() {
                $.toast('error', '加载用户数据失败');
                setTimeout(function() {
                    window.location.href = $.buildUrl('/admin/user/list');
                }, 1000);
            });
        }

        /**
         * 提交表单
         */
        function submitForm() {
            var formData = {
                userId: parseInt($('#userId').val()),
                username: $('#username').val().trim(),
                realName: $('#realName').val().trim(),
                roleType: parseInt($('#roleType').val()),
                gender: $('#gender').val() ? parseInt($('#gender').val()) : null,
                phone: $('#phone').val().trim() || null,
                status: parseInt($('#status').val()),
                grade: $('#grade').val().trim() || null,
                major: $('#major').val().trim() || null,
                className: $('#className').val().trim() || null
            };

            // 禁用提交按钮
            $('#btnSubmit').prop('disabled', true).text('保存中...');

            $.ajaxRequest('/admin/user/update', 'POST', formData, function(result) {
                $.toast('success', '用户信息更新成功');
                setTimeout(function() {
                    window.location.href = $.buildUrl('/admin/user/list');
                }, 1000);
            }, function(result) {
                $.toast('error', result.msg || '更新失败');
                $('#btnSubmit').prop('disabled', false).text('保存');
            });
        }
    </script>
</body>
</html>
