/**
 * 高校公寓管理系统 - 公共JS工具函数
 * 版本：v1.0
 * 说明：封装公共工具函数，提供统一的AJAX请求、错误处理、提示消息等功能
 */

(function($) {
    'use strict';

    /**
     * 获取项目路径
     * @returns {string} 项目路径
     */
    $.getContextPath = function() {
        return window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1));
    };

    /**
     * 构建完整URL
     * @param {string} path - 相对路径
     * @returns {string} 完整URL
     */
    $.buildUrl = function(path) {
        if (path.startsWith('http://') || path.startsWith('https://')) {
            return path;
        }
        return $.getContextPath() + (path.startsWith('/') ? path : '/' + path);
    };

    /**
     * 统一AJAX请求封装
     * @param {string} url - 请求路径
     * @param {string} method - 请求方法（GET/POST）
     * @param {object} data - 请求数据
     * @param {function} successCallback - 成功回调
     * @param {function} errorCallback - 错误回调（可选）
     */
    $.ajaxRequest = function(url, method, data, successCallback, errorCallback) {
        var ajaxOptions = {
            url: $.buildUrl(url),
            type: method,
            dataType: 'json',
            timeout: 30000,
            success: function(result) {
                if (result.code === 200) {
                    if (typeof successCallback === 'function') {
                        successCallback(result);
                    }
                } else if (result.code === 401) {
                    // 未登录，跳转登录页
                    $.toast('warning', '未登录或登录已过期，请重新登录');
                    setTimeout(function() {
                        window.location.href = $.buildUrl('/login');
                    }, 1500);
                    if (typeof errorCallback === 'function') {
                        errorCallback(result);
                    }
                } else if (result.code === 403) {
                    // 无权限
                    $.toast('error', '无权限访问');
                    if (typeof errorCallback === 'function') {
                        errorCallback(result);
                    }
                } else {
                    // 其他错误（400/404/409/500等）
                    if (typeof errorCallback === 'function') {
                        errorCallback(result);
                    } else {
                        $.toast('error', result.msg || '操作失败');
                    }
                }
            },
            error: function(xhr, status, error) {
                $.handleError(xhr, status, error);
                if (typeof errorCallback === 'function') {
                    errorCallback({ code: xhr.status, msg: error });
                }
            }
        };

        // POST请求设置contentType
        if (method.toUpperCase() === 'POST') {
            ajaxOptions.contentType = 'application/json';
            if (data && typeof data === 'object') {
                ajaxOptions.data = JSON.stringify(data);
            }
        } else {
            ajaxOptions.data = data;
        }

        $.ajax(ajaxOptions);
    };

    /**
     * 统一错误处理
     * @param {object} xhr - XMLHttpRequest对象
     * @param {string} status - 状态
     * @param {string} error - 错误信息
     */
    $.handleError = function(xhr, status, error) {
        var message = '请求失败，请稍后重试';

        if (xhr.status === 0) {
            message = '网络连接失败，请检查网络';
        } else if (xhr.status === 401) {
            message = '未登录或登录已过期';
            setTimeout(function() {
                window.location.href = $.buildUrl('/login');
            }, 1500);
        } else if (xhr.status === 403) {
            message = '无权限访问';
        } else if (xhr.status === 404) {
            message = '请求的资源不存在';
        } else if (xhr.status === 408) {
            message = '请求超时，请稍后重试';
        } else if (xhr.status === 500) {
            message = '服务器内部错误，请稍后重试';
        } else if (status === 'timeout') {
            message = '请求超时，请稍后重试';
        } else if (status === 'parsererror') {
            message = '数据解析错误';
        }

        $.toast('error', message);
    };

    /**
     * 提示消息
     * @param {string} type - 消息类型（success/warning/error/info）
     * @param {string} message - 消息内容
     * @param {number} duration - 显示时长（毫秒），默认3000
     */
    $.toast = function(type, message, duration) {
        duration = duration || 3000;

        // 移除已存在的toast
        $('.custom-toast').remove();

        // 创建toast元素
        var iconMap = {
            success: 'fas fa-check-circle',
            warning: 'fas fa-exclamation-circle',
            error: 'fas fa-times-circle',
            info: 'fas fa-info-circle'
        };

        var colorMap = {
            success: '#28a745',
            warning: '#ffc107',
            error: '#dc3545',
            info: '#17a2b8'
        };

        var toastHtml = '<div class="custom-toast" style="' +
            'position: fixed;' +
            'top: 20px;' +
            'left: 50%;' +
            'transform: translateX(-50%);' +
            'z-index: 9999;' +
            'padding: 12px 24px;' +
            'border-radius: 4px;' +
            'background-color: ' + colorMap[type] + ';' +
            'color: #fff;' +
            'font-size: 14px;' +
            'box-shadow: 0 4px 12px rgba(0,0,0,0.15);' +
            'display: flex;' +
            'align-items: center;' +
            'gap: 8px;' +
            'animation: toastSlideIn 0.3s ease;' +
            '">' +
            '<i class="' + iconMap[type] + '"></i>' +
            '<span>' + message + '</span>' +
            '</div>';

        // 添加到页面
        $('body').append(toastHtml);

        // 自动消失
        setTimeout(function() {
            $('.custom-toast').fadeOut(300, function() {
                $(this).remove();
            });
        }, duration);
    };

    /**
     * 确认对话框
     * @param {string} message - 提示消息
     * @param {function} onConfirm - 确认回调
     * @param {function} onCancel - 取消回调（可选）
     * @param {string} title - 标题（可选）
     */
    $.confirm = function(message, onConfirm, onCancel, title) {
        title = title || '确认操作';

        // 移除已存在的confirm
        $('.custom-confirm').remove();

        var confirmHtml = '<div class="custom-confirm" style="' +
            'position: fixed;' +
            'top: 0;' +
            'left: 0;' +
            'right: 0;' +
            'bottom: 0;' +
            'background-color: rgba(0,0,0,0.5);' +
            'z-index: 9999;' +
            'display: flex;' +
            'align-items: center;' +
            'justify-content: center;' +
            '">' +
            '<div style="' +
            'background-color: #fff;' +
            'border-radius: 8px;' +
            'padding: 24px;' +
            'max-width: 400px;' +
            'width: 90%;' +
            'box-shadow: 0 4px 20px rgba(0,0,0,0.2);' +
            '">' +
            '<h4 style="margin: 0 0 16px 0; font-size: 18px; color: #333;">' + title + '</h4>' +
            '<p style="margin: 0 0 24px 0; font-size: 14px; color: #666; line-height: 1.5;">' + message + '</p>' +
            '<div style="display: flex; justify-content: flex-end; gap: 10px;">' +
            '<button class="btn btn-secondary btn-cancel" style="min-width: 80px;">取消</button>' +
            '<button class="btn btn-primary btn-confirm" style="min-width: 80px;">确认</button>' +
            '</div>' +
            '</div>' +
            '</div>';

        // 添加到页面
        $('body').append(confirmHtml);

        // 绑定事件
        $('.custom-confirm .btn-confirm').on('click', function() {
            $('.custom-confirm').remove();
            if (typeof onConfirm === 'function') {
                onConfirm();
            }
        });

        $('.custom-confirm .btn-cancel').on('click', function() {
            $('.custom-confirm').remove();
            if (typeof onCancel === 'function') {
                onCancel();
            }
        });

        // 点击背景关闭
        $('.custom-confirm').on('click', function(e) {
            if ($(e.target).hasClass('custom-confirm')) {
                $('.custom-confirm').remove();
                if (typeof onCancel === 'function') {
                    onCancel();
                }
            }
        });
    };

    /**
     * 跳转页面
     * @param {string} url - 目标URL
     */
    $.navigate = function(url) {
        window.location.href = $.buildUrl(url);
    };

    /**
     * 分页参数构建
     * @param {number} pageNum - 页码
     * @param {number} pageSize - 每页条数
     * @returns {object} 分页参数对象
     */
    $.buildPageParams = function(pageNum, pageSize) {
        return {
            pageNum: pageNum || 1,
            pageSize: pageSize || 10
        };
    };

    /**
     * 表单序列化为JSON
     * @returns {object} 表单数据对象
     */
    $.fn.serializeJSON = function() {
        var obj = {};
        var arr = this.serializeArray();
        $.each(arr, function() {
            if (obj[this.name] !== undefined) {
                if (!obj[this.name].push) {
                    obj[this.name] = [obj[this.name]];
                }
                obj[this.name].push(this.value || '');
            } else {
                obj[this.name] = this.value || '';
            }
        });
        return obj;
    };

    /**
     * 日期格式化
     * @param {Date|string|number} date - 日期对象、日期字符串或时间戳
     * @param {string} format - 格式化模式（默认：yyyy-MM-dd HH:mm:ss）
     * @returns {string} 格式化后的日期字符串
     */
    $.formatDate = function(date, format) {
        format = format || 'yyyy-MM-dd HH:mm:ss';

        if (!date) {
            return '';
        }

        if (typeof date === 'string') {
            date = new Date(date);
        } else if (typeof date === 'number') {
            date = new Date(date);
        }

        if (!(date instanceof Date) || isNaN(date.getTime())) {
            return '';
        }

        var o = {
            'M+': date.getMonth() + 1,
            'd+': date.getDate(),
            'H+': date.getHours(),
            'h+': date.getHours() % 12 || 12,
            'm+': date.getMinutes(),
            's+': date.getSeconds(),
            'q+': Math.floor((date.getMonth() + 3) / 3),
            'S': date.getMilliseconds()
        };

        if (/(y+)/.test(format)) {
            format = format.replace(RegExp.$1, (date.getFullYear() + '').substr(4 - RegExp.$1.length));
        }

        for (var k in o) {
            if (new RegExp('(' + k + ')').test(format)) {
                format = format.replace(RegExp.$1, (RegExp.$1.length === 1) ? (o[k]) : (('00' + o[k]).substr(('' + o[k]).length)));
            }
        }

        return format;
    };

    /**
     * 初始化页面公共功能
     */
    $(document).ready(function() {
        // 移动端侧边栏切换
        $('.navbar-toggler').on('click', function() {
            $('.sidebar').toggleClass('show');
        });

        // 点击内容区域关闭侧边栏（移动端）
        $('.content-body').on('click', function() {
            if ($(window).width() <= 768) {
                $('.sidebar').removeClass('show');
            }
        });

        // 高亮当前页面菜单，使用前缀匹配支持非列表页面
        var currentPath = window.location.pathname;
        $('.sidebar-menu .menu-link').each(function() {
            var href = $(this).attr('href');
            if (!href || href === 'javascript:void(0)' || href === '#') return;
            // 提取模块前缀（去掉末段页面名），如 /admin/building/list → /admin/building/
            var prefix = href.replace(/\/[^\/]+$/, '/');
            if (currentPath.indexOf(prefix) !== -1) {
                $(this).addClass('active');
            }
        });

        // 退出登录
        $('.btn-logout').on('click', function(e) {
            e.preventDefault();
            $.confirm('确定要退出登录吗？', function() {
                $.ajaxRequest('/logout', 'POST', null, function() {
                    $.toast('success', '退出成功');
                    setTimeout(function() {
                        window.location.href = $.buildUrl('/login');
                    }, 1000);
                });
            });
        });

        // 全局AJAX错误处理
        $(document).ajaxError(function(event, xhr, settings, thrownError) {
            if (xhr.status === 401 && settings.url.indexOf('/login') === -1) {
                $.toast('warning', '未登录或登录已过期，请重新登录');
                setTimeout(function() {
                    window.location.href = $.buildUrl('/login');
                }, 1500);
            }
        });
    });

    // 添加toast动画样式
    var style = document.createElement('style');
    style.textContent = '@keyframes toastSlideIn { from { transform: translateX(-50%) translateY(-100%); opacity: 0; } to { transform: translateX(-50%) translateY(0); opacity: 1; } }';
    document.head.appendChild(style);

})(jQuery);
