<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>编辑房间 - 高校公寓管理系统</title>
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
                        <h4 style="color: #333; margin-bottom: 8px;">编辑房间</h4>
                        <p style="color: #666; margin: 0;">修改房间信息</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/room/list" class="btn btn-secondary">
                        <i class="fas fa-arrow-left mr-2"></i>返回列表
                    </a>
                </div>

                <!-- 表单 -->
                <div class="form-container">
                    <form id="roomForm" novalidate>
                        <input type="hidden" id="roomId" name="roomId">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="roomNo">房间编号 <span class="required">*</span></label>
                                    <input type="text" class="form-control" id="roomNo" name="roomNo" placeholder="如：101" maxlength="20">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="buildingId">所属楼栋 <span class="required">*</span></label>
                                    <select class="form-control" id="buildingId" name="buildingId">
                                        <option value="">请选择楼栋</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label for="floorNum">所在楼层 <span class="required">*</span></label>
                                    <input type="number" class="form-control" id="floorNum" name="floorNum" placeholder="请选择楼栋后输入" min="1" disabled>
                                    <small class="form-text text-muted" id="floorHint">请先选择楼栋</small>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label for="bedTotal">额定床位数 <span class="required">*</span></label>
                                    <input type="number" class="form-control" id="bedTotal" name="bedTotal" placeholder="请输入床位数" min="1" max="20">
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label for="roomType">房间类型 <span class="required">*</span></label>
                                    <select class="form-control" id="roomType" name="roomType">
                                        <option value="">请选择房间类型</option>
                                        <option value="1">四人间</option>
                                        <option value="2">六人间</option>
                                        <option value="3">八人间</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="remark">备注</label>
                                    <input type="text" class="form-control" id="remark" name="remark" placeholder="如：朝阳房间" maxlength="100">
                                </div>
                            </div>
                        </div>

                        <div class="form-group mt-4">
                            <button type="submit" class="btn btn-primary" id="btnSubmit">
                                <i class="fas fa-save mr-2"></i>保存
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/room/list" class="btn btn-secondary ml-2">
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
        // 当前楼栋的楼层总数
        var currentFloorCount = 0;

        $(function() {
            // 从URL获取roomId
            var urlParams = new URLSearchParams(window.location.search);
            var roomId = urlParams.get('roomId');

            if (!roomId) {
                $.toast('error', '缺少房间ID参数');
                setTimeout(function() {
                    window.location.href = $.buildUrl('/admin/room/list');
                }, 1000);
                return;
            }

            // 加载楼栋列表，然后加载房间数据
            loadBuildingList(function() {
                loadRoomData(roomId);
            });

            // 楼栋选择变化事件
            $('#buildingId').on('change', function() {
                var buildingId = $(this).val();
                if (buildingId) {
                    loadBuildingInfo(buildingId);
                } else {
                    currentFloorCount = 0;
                    $('#floorNum').prop('disabled', true).attr('max', '').val('');
                    $('#floorHint').text('请先选择楼栋');
                }
            });

            // 表单验证
            $('#roomForm').validate({
                rules: {
                    roomNo: {
                        required: true,
                        maxlength: 20
                    },
                    buildingId: {
                        required: true
                    },
                    floorNum: {
                        required: true,
                        min: 1,
                        digits: true
                    },
                    bedTotal: {
                        required: true,
                        min: 1,
                        max: 20,
                        digits: true
                    },
                    roomType: {
                        required: true
                    }
                },
                messages: {
                    roomNo: {
                        required: '请输入房间编号',
                        maxlength: '房间编号长度不能超过20个字符'
                    },
                    buildingId: {
                        required: '请选择所属楼栋'
                    },
                    floorNum: {
                        required: '请输入所在楼层',
                        min: '楼层至少为1',
                        digits: '楼层必须为整数'
                    },
                    bedTotal: {
                        required: '请输入额定床位数',
                        min: '床位数至少为1',
                        max: '床位数不能超过20',
                        digits: '床位数必须为整数'
                    },
                    roomType: {
                        required: '请选择房间类型'
                    }
                },
                submitHandler: function(form) {
                    submitForm();
                }
            });
        });

        /**
         * 加载楼栋列表
         * @param {function} callback - 回调函数
         */
        function loadBuildingList(callback) {
            $.ajaxRequest('/admin/building/page', 'GET', {pageSize: 100}, function(result) {
                if (result.data && result.data.list) {
                    var $select = $('#buildingId');
                    result.data.list.forEach(function(building) {
                        $select.append('<option value="' + building.buildingId + '">' + building.buildingName + '</option>');
                    });
                }
                if (typeof callback === 'function') {
                    callback();
                }
            });
        }

        /**
         * 加载楼栋信息（获取楼层总数）
         * @param {number} buildingId - 楼栋ID
         */
        function loadBuildingInfo(buildingId) {
            $.ajaxRequest('/admin/building/' + buildingId, 'GET', null, function(result) {
                if (result.data) {
                    currentFloorCount = result.data.floorCount;
                    $('#floorNum').prop('disabled', false).attr('max', currentFloorCount);
                    $('#floorHint').text('最大楼层：' + currentFloorCount);

                    // 更新验证规则
                    var validator = $('#roomForm').validate();
                    validator.settings.rules.floorNum.max = currentFloorCount;
                    validator.settings.messages.floorNum.max = '楼层不能超过' + currentFloorCount;
                }
            });
        }

        /**
         * 加载房间数据
         * @param {number} roomId - 房间ID
         */
        function loadRoomData(roomId) {
            $.ajaxRequest('/admin/room/' + roomId, 'GET', null, function(result) {
                if (result.data) {
                    var room = result.data;
                    $('#roomId').val(room.roomId);
                    $('#roomNo').val(room.roomNo);
                    $('#buildingId').val(room.buildingId);
                    $('#bedTotal').val(room.bedTotal);
                    $('#roomType').val(room.roomType);
                    $('#remark').val(room.remark || '');

                    // 加载楼栋信息后设置楼层
                    if (room.buildingId) {
                        loadBuildingInfo(room.buildingId, function() {
                            $('#floorNum').val(room.floorNum);
                        });
                    }
                }
            }, function() {
                $.toast('error', '加载房间数据失败');
                setTimeout(function() {
                    window.location.href = $.buildUrl('/admin/room/list');
                }, 1000);
            });
        }

        /**
         * 提交表单
         */
        function submitForm() {
            var formData = {
                roomId: parseInt($('#roomId').val()),
                roomNo: $('#roomNo').val().trim(),
                buildingId: parseInt($('#buildingId').val()),
                floorNum: parseInt($('#floorNum').val()),
                bedTotal: parseInt($('#bedTotal').val()),
                roomType: parseInt($('#roomType').val()),
                remark: $('#remark').val().trim() || null
            };

            $('#btnSubmit').prop('disabled', true).text('保存中...');

            $.ajaxRequest('/admin/room/update', 'POST', formData, function(result) {
                $.toast('success', '房间信息更新成功');
                setTimeout(function() {
                    window.location.href = $.buildUrl('/admin/room/list');
                }, 1000);
            }, function(result) {
                $.toast('error', result.msg || '更新失败');
                $('#btnSubmit').prop('disabled', false).html('<i class="fas fa-save mr-2"></i>保存');
            });
        }
    </script>
</body>
</html>
