<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>编辑用户 - 高校公寓管理系统</title>
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
                        <h4 style="color: #333; margin-bottom: 8px;">编辑用户</h4>
                        <p style="color: #666; margin: 0;">修改用户信息</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/user/list" class="btn btn-secondary">
                        <i class="fas fa-arrow-left mr-2"></i>返回列表
                    </a>
                </div>

                <!-- 表单 -->
                <div class="form-container">
                    <form id="userForm" novalidate>
                        <input type="hidden" id="userId" name="userId">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="username">用户名</label>
                                    <input type="text" class="form-control" id="username" name="username" readonly>
                                    <small class="form-text text-muted">用户名不可修改</small>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="realName">真实姓名 <span class="required">*</span></label>
                                    <input type="text" class="form-control" id="realName" name="realName" placeholder="请输入真实姓名" maxlength="20">
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="roleType">角色类型 <span class="required">*</span></label>
                                    <select class="form-control" id="roleType" name="roleType">
                                        <option value="">请选择角色</option>
                                        <option value="1">管理员</option>
                                        <option value="2">宿管</option>
                                        <option value="3">学生</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="gender">性别</label>
                                    <select class="form-control" id="gender" name="gender">
                                        <option value="">请选择性别</option>
                                        <option value="1">男</option>
                                        <option value="2">女</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="phone">联系电话</label>
                                    <input type="text" class="form-control" id="phone" name="phone" placeholder="请输入联系电话" maxlength="11">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="status">账号状态</label>
                                    <select class="form-control" id="status" name="status">
                                        <option value="1">正常</option>
                                        <option value="0">禁用</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <!-- 学生专属字段 -->
                        <div id="studentFields" style="display: none;">
                            <hr>
                            <h6 class="mb-3"><i class="fas fa-graduation-cap mr-2"></i>学生信息</h6>
                            <div class="row">
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label for="grade">年级</label>
                                        <input type="text" class="form-control" id="grade" name="grade" placeholder="如：2024级">
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label for="major">专业</label>
                                        <input type="text" class="form-control" id="major" name="major" placeholder="请输入专业">
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label for="className">班级</label>
                                        <input type="text" class="form-control" id="className" name="className" placeholder="请输入班级">
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="form-group mt-4">
                            <button type="submit" class="btn btn-primary" id="btnSubmit">
                                <i class="fas fa-save mr-2"></i>保存
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/user/list" class="btn btn-secondary ml-2">
                                <i class="fas fa-times mr-2"></i>取消
                            </a>
                        </div>
                    </form>
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
    <!-- jQuery Validation -->
    <script src="${pageContext.request.contextPath}/static/js/jquery.validate.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/messages_zh.js"></script>
    <!-- 公共JS -->
    <script src="${pageContext.request.contextPath}/static/js/common.js"></script>
    <!-- 导航栏JS -->
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
                        pattern: /^1[3-9]\d{9}$/
                    }
                },
                messages: {
                    realName: {
                        required: '请输入真实姓名',
                        maxlength: '真实姓名长度不能超过20个字符'
                    },
                    roleType: {
                        required: '请选择角色类型'
                    },
                    phone: {
                        pattern: '请输入正确的手机号码'
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
            $.ajaxRequest('/admin/user/' + userId, 'GET', null, function(result) {
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
                $('#btnSubmit').prop('disabled', false).html('<i class="fas fa-save mr-2"></i>保存');
            });
        }
    </script>
</body>
</html>
