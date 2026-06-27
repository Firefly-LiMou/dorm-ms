<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>编辑楼栋 - 高校公寓管理系统</title>
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
                        <h4 style="color: #333; margin-bottom: 8px;">编辑楼栋</h4>
                        <p style="color: #666; margin: 0;">修改楼栋信息</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/building/list" class="btn btn-secondary">
                        <i class="fas fa-arrow-left mr-2"></i>返回列表
                    </a>
                </div>

                <!-- 表单 -->
                <div class="form-container">
                    <form id="buildingForm" novalidate>
                        <input type="hidden" id="buildingId" name="buildingId">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="buildingNo">楼栋编号 <span class="required">*</span></label>
                                    <input type="text" class="form-control" id="buildingNo" name="buildingNo" placeholder="如：1号楼" maxlength="20">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="buildingName">楼栋名称 <span class="required">*</span></label>
                                    <input type="text" class="form-control" id="buildingName" name="buildingName" placeholder="如：东区1号学生公寓" maxlength="50">
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="floorCount">楼层总数 <span class="required">*</span></label>
                                    <input type="number" class="form-control" id="floorCount" name="floorCount" placeholder="请输入楼层总数" min="1" max="99">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="area">所属区域</label>
                                    <input type="text" class="form-control" id="area" name="area" placeholder="如：东区" maxlength="20">
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="managerId">负责宿管</label>
                                    <select class="form-control" id="managerId" name="managerId">
                                        <option value="">请选择宿管</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="remark">备注</label>
                                    <input type="text" class="form-control" id="remark" name="remark" placeholder="如：男生公寓" maxlength="100">
                                </div>
                            </div>
                        </div>

                        <div class="form-group mt-4">
                            <button type="submit" class="btn btn-primary" id="btnSubmit">
                                <i class="fas fa-save mr-2"></i>保存
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/building/list" class="btn btn-secondary ml-2">
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
            // 从URL获取buildingId
            var urlParams = new URLSearchParams(window.location.search);
            var buildingId = urlParams.get('buildingId');

            if (!buildingId) {
                $.toast('error', '缺少楼栋ID参数');
                setTimeout(function() {
                    window.location.href = $.buildUrl('/admin/building/list');
                }, 1000);
                return;
            }

            // 加载宿管列表，然后加载楼栋数据
            loadManagerList(function() {
                loadBuildingData(buildingId);
            });

            // 表单验证
            $('#buildingForm').validate({
                rules: {
                    buildingNo: {
                        required: true,
                        maxlength: 20
                    },
                    buildingName: {
                        required: true,
                        maxlength: 50
                    },
                    floorCount: {
                        required: true,
                        min: 1,
                        max: 99,
                        digits: true
                    }
                },
                messages: {
                    buildingNo: {
                        required: '请输入楼栋编号',
                        maxlength: '楼栋编号长度不能超过20个字符'
                    },
                    buildingName: {
                        required: '请输入楼栋名称',
                        maxlength: '楼栋名称长度不能超过50个字符'
                    },
                    floorCount: {
                        required: '请输入楼层总数',
                        min: '楼层总数至少为1',
                        max: '楼层总数不能超过99',
                        digits: '楼层总数必须为整数'
                    }
                },
                submitHandler: function(form) {
                    submitForm();
                }
            });
        });

        /**
         * 加载宿管列表
         * @param {function} callback - 回调函数
         */
        function loadManagerList(callback) {
            $.ajaxRequest('/admin/user/list/2', 'GET', null, function(result) {
                if (result.data) {
                    var $select = $('#managerId');
                    result.data.forEach(function(user) {
                        $select.append('<option value="' + user.userId + '">' + user.realName + ' (' + user.username + ')</option>');
                    });
                }
                if (typeof callback === 'function') {
                    callback();
                }
            });
        }

        /**
         * 加载楼栋数据
         * @param {number} buildingId - 楼栋ID
         */
        function loadBuildingData(buildingId) {
            $.ajaxRequest('/admin/building/' + buildingId, 'GET', null, function(result) {
                if (result.data) {
                    var building = result.data;
                    $('#buildingId').val(building.buildingId);
                    $('#buildingNo').val(building.buildingNo);
                    $('#buildingName').val(building.buildingName);
                    $('#floorCount').val(building.floorCount);
                    $('#area').val(building.area || '');
                    $('#managerId').val(building.managerId || '');
                    $('#remark').val(building.remark || '');
                }
            }, function() {
                $.toast('error', '加载楼栋数据失败');
                setTimeout(function() {
                    window.location.href = $.buildUrl('/admin/building/list');
                }, 1000);
            });
        }

        /**
         * 提交表单
         */
        function submitForm() {
            var formData = {
                buildingId: parseInt($('#buildingId').val()),
                buildingNo: $('#buildingNo').val().trim(),
                buildingName: $('#buildingName').val().trim(),
                floorCount: parseInt($('#floorCount').val()),
                area: $('#area').val().trim() || null,
                managerId: $('#managerId').val() ? parseInt($('#managerId').val()) : null,
                remark: $('#remark').val().trim() || null
            };

            $('#btnSubmit').prop('disabled', true).text('保存中...');

            $.ajaxRequest('/admin/building/update', 'POST', formData, function(result) {
                $.toast('success', '楼栋信息更新成功');
                setTimeout(function() {
                    window.location.href = $.buildUrl('/admin/building/list');
                }, 1000);
            }, function(result) {
                $.toast('error', result.msg || '更新失败');
                $('#btnSubmit').prop('disabled', false).html('<i class="fas fa-save mr-2"></i>保存');
            });
        }
    </script>
</body>
</html>
