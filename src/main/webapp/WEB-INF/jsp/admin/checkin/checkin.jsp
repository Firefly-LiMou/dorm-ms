<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>办理入住 - 高校公寓管理系统</title>
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
                        <h4 style="color: #333; margin-bottom: 8px;">办理入住</h4>
                        <p style="color: #666; margin: 0;">为学生分配床位，办理入住手续</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/checkin/list" class="btn btn-secondary">
                        <i class="fas fa-arrow-left mr-2"></i>返回列表
                    </a>
                </div>

                <!-- 步骤1：选择学生 -->
                <div class="form-container mb-4">
                    <h6 class="mb-3"><i class="fas fa-user mr-2"></i>第一步：选择学生</h6>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <div class="input-group">
                                <input type="text" class="form-control" id="studentNo" placeholder="请输入学号" maxlength="20">
                                <button type="button" class="btn btn-primary" onclick="searchStudent()">
                                    <i class="fas fa-search mr-1"></i>查询
                                </button>
                            </div>
                        </div>
                    </div>
                    <!-- 学生信息展示区 -->
                    <div id="studentInfo" style="display: none;" class="mt-3">
                        <div class="alert alert-success">
                            <div class="row">
                                <div class="col-md-3"><strong>姓名：</strong><span id="sName"></span></div>
                                <div class="col-md-3"><strong>学号：</strong><span id="sNo"></span></div>
                                <div class="col-md-3"><strong>年级：</strong><span id="sGrade"></span></div>
                                <div class="col-md-3"><strong>专业：</strong><span id="sMajor"></span></div>
                            </div>
                        </div>
                        <input type="hidden" id="studentId">
                    </div>
                    <!-- 错误提示 -->
                    <div id="studentError" style="display: none;" class="mt-3">
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-circle mr-2"></i><span id="studentErrorMsg"></span>
                        </div>
                    </div>
                </div>

                <!-- 步骤2：选择床位 -->
                <div class="form-container mb-4" id="bedSection" style="display: none;">
                    <h6 class="mb-3"><i class="fas fa-bed mr-2"></i>第二步：选择床位</h6>
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label for="buildingId" class="form-label">楼栋</label>
                            <select class="form-control" id="buildingId">
                                <option value="">请选择楼栋</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label for="roomId" class="form-label">房间</label>
                            <select class="form-control" id="roomId" disabled>
                                <option value="">请先选择楼栋</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label for="bedId" class="form-label">床位</label>
                            <select class="form-control" id="bedId" disabled>
                                <option value="">请先选择房间</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- 步骤3：确认提交 -->
                <div class="form-container mb-4" id="submitSection" style="display: none;">
                    <h6 class="mb-3"><i class="fas fa-check-circle mr-2"></i>第三步：确认提交</h6>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="remark">备注</label>
                                <input type="text" class="form-control" id="remark" placeholder="可选填备注信息" maxlength="100">
                            </div>
                        </div>
                    </div>
                    <div class="mt-3">
                        <button type="button" class="btn btn-primary" id="btnSubmit" onclick="submitForm()">
                            <i class="fas fa-save mr-2"></i>确认办理入住
                        </button>
                    </div>
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
    <!-- 公共JS -->
    <script src="${pageContext.request.contextPath}/static/js/common.js"></script>
    <!-- 导航栏JS -->
    <script>window.needChangePasswordFlag = '${sessionScope.needChangePassword}';</script>
    <script src="${pageContext.request.contextPath}/static/js/header.js"></script>

    <script>
        // 选中的学生ID
        var selectedStudentId = null;

        $(function() {
            // 加载楼栋列表
            loadBuildingList();

            // 楼栋选择变化事件
            $('#buildingId').on('change', function() {
                var buildingId = $(this).val();
                if (buildingId) {
                    loadRoomList(buildingId);
                } else {
                    $('#roomId').html('<option value="">请先选择楼栋</option>').prop('disabled', true);
                    $('#bedId').html('<option value="">请先选择房间</option>').prop('disabled', true);
                }
            });

            // 房间选择变化事件
            $('#roomId').on('change', function() {
                var roomId = $(this).val();
                if (roomId) {
                    loadFreeBeds(roomId);
                } else {
                    $('#bedId').html('<option value="">请先选择房间</option>').prop('disabled', true);
                }
            });

            // 学号输入框回车事件
            $('#studentNo').on('keypress', function(e) {
                if (e.which === 13) {
                    e.preventDefault();
                    searchStudent();
                }
            });
        });

        /**
         * 查询学生
         */
        function searchStudent() {
            var studentNo = $('#studentNo').val().trim();
            if (!studentNo) {
                showStudentError('请输入学号');
                return;
            }

            hideStudentInfo();
            hideStudentError();

            $.ajaxRequest('/admin/user/page', 'GET', {
                username: studentNo,
                roleType: 3,
                pageNum: 1,
                pageSize: 1
            }, function(result) {
                if (result.data && result.data.list && result.data.list.length > 0) {
                    var student = result.data.list[0];
                    // 检查学号是否完全匹配
                    if (student.username === studentNo) {
                        showStudentInfo(student);
                    } else {
                        showStudentError('未找到学号为 ' + studentNo + ' 的学生');
                    }
                } else {
                    showStudentError('未找到学号为 ' + studentNo + ' 的学生');
                }
            }, function() {
                showStudentError('查询失败，请重试');
            });
        }

        /**
         * 显示学生信息
         * @param {object} student - 学生信息
         */
        function showStudentInfo(student) {
            selectedStudentId = student.userId;
            $('#studentId').val(student.userId);
            $('#sName').text(student.realName || '-');
            $('#sNo').text(student.username || '-');
            $('#sGrade').text(student.grade || '-');
            $('#sMajor').text(student.major || '-');
            $('#studentInfo').show();
            $('#bedSection').show();
            $('#submitSection').show();
        }

        /**
         * 隐藏学生信息
         */
        function hideStudentInfo() {
            selectedStudentId = null;
            $('#studentId').val('');
            $('#studentInfo').hide();
            $('#bedSection').hide();
            $('#submitSection').hide();
        }

        /**
         * 显示学生错误
         * @param {string} msg - 错误信息
         */
        function showStudentError(msg) {
            $('#studentErrorMsg').text(msg);
            $('#studentError').show();
            hideStudentInfo();
        }

        /**
         * 隐藏学生错误
         */
        function hideStudentError() {
            $('#studentError').hide();
        }

        /**
         * 加载楼栋列表
         */
        function loadBuildingList() {
            $.ajaxRequest('/common/building/list', 'GET', null, function(result) {
                if (result.data) {
                    var $select = $('#buildingId');
                    result.data.forEach(function(building) {
                        $select.append('<option value="' + building.buildingId + '">' + building.buildingName + '</option>');
                    });
                }
            });
        }

        /**
         * 加载房间列表
         * @param {number} buildingId - 楼栋ID
         */
        function loadRoomList(buildingId) {
            var $select = $('#roomId');
            $select.html('<option value="">请选择房间</option>').prop('disabled', true);
            $('#bedId').html('<option value="">请先选择房间</option>').prop('disabled', true);

            $.ajaxRequest('/common/room/building/' + buildingId, 'GET', null, function(result) {
                if (result.data) {
                    result.data.forEach(function(room) {
                        $select.append('<option value="' + room.roomId + '">' + room.roomNo + ' (' + room.roomTypeText + ')</option>');
                    });
                    $select.prop('disabled', false);
                }
            });
        }

        /**
         * 加载空闲床位
         * @param {number} roomId - 房间ID
         */
        function loadFreeBeds(roomId) {
            var $select = $('#bedId');
            $select.html('<option value="">请选择床位</option>').prop('disabled', true);

            $.ajaxRequest('/common/bed/free/' + roomId, 'GET', null, function(result) {
                if (result.data) {
                    if (result.data.length === 0) {
                        $select.html('<option value="">该房间无空闲床位</option>');
                    } else {
                        result.data.forEach(function(bed) {
                            $select.append('<option value="' + bed.bedId + '">' + bed.bedNo + '</option>');
                        });
                        $select.prop('disabled', false);
                    }
                }
            });
        }

        /**
         * 提交表单
         */
        function submitForm() {
            if (!selectedStudentId) {
                $.toast('warning', '请先查询并选择学生');
                return;
            }

            var bedId = $('#bedId').val();
            if (!bedId) {
                $.toast('warning', '请选择床位');
                return;
            }

            var formData = {
                studentId: selectedStudentId,
                bedId: parseInt(bedId),
                remark: $('#remark').val().trim() || null
            };

            $('#btnSubmit').prop('disabled', true).text('办理中...');

            $.ajaxRequest('/admin/checkin/checkin', 'POST', formData, function(result) {
                $.toast('success', '入住办理成功');
                setTimeout(function() {
                    window.location.href = $.buildUrl('/admin/checkin/list');
                }, 1000);
            }, function(result) {
                $.toast('error', result.msg || '办理失败');
                $('#btnSubmit').prop('disabled', false).html('<i class="fas fa-save mr-2"></i>确认办理入住');
            });
        }
    </script>
</body>
</html>
