<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>高校公寓管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/fontawesome/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #1a73e8 0%, #0d47a1 50%, #01579b 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }
        body::before {
            content: '';
            position: fixed;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle at 30% 70%, rgba(255,255,255,0.06) 0%, transparent 50%),
                        radial-gradient(circle at 70% 30%, rgba(255,255,255,0.04) 0%, transparent 50%);
            animation: bgShift 20s ease-in-out infinite;
        }
        @keyframes bgShift {
            0%, 100% { transform: translate(0, 0); }
            50% { transform: translate(-2%, -1%); }
        }

        .showcase {
            position: relative;
            text-align: center;
            color: #fff;
            padding: 40px;
            max-width: 680px;
        }

        .showcase-icon {
            width: 80px;
            height: 80px;
            margin: 0 auto 24px;
            background: rgba(255,255,255,0.15);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 36px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.2);
        }

        .showcase h1 {
            font-size: 36px;
            font-weight: 700;
            margin-bottom: 8px;
            letter-spacing: 2px;
        }
        .showcase .subtitle {
            font-size: 14px;
            color: rgba(255,255,255,0.6);
            margin-bottom: 32px;
            letter-spacing: 3px;
            text-transform: uppercase;
        }

        .tech-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            justify-content: center;
            margin-bottom: 36px;
        }
        .tech-tag {
            padding: 6px 18px;
            background: rgba(255,255,255,0.1);
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 20px;
            font-size: 13px;
            color: rgba(255,255,255,0.85);
            backdrop-filter: blur(5px);
            transition: all 0.3s;
        }
        .tech-tag:hover {
            background: rgba(255,255,255,0.2);
            border-color: rgba(255,255,255,0.4);
        }

        .btn-enter {
            display: inline-block;
            padding: 14px 48px;
            background: #fff;
            color: #1a73e8;
            font-size: 16px;
            font-weight: 600;
            border-radius: 30px;
            text-decoration: none;
            transition: all 0.3s;
            box-shadow: 0 4px 20px rgba(0,0,0,0.2);
            letter-spacing: 1px;
        }
        .btn-enter:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 30px rgba(0,0,0,0.3);
            color: #0d47a1;
        }
        .btn-enter i { margin-left: 8px; }

        .footer-info {
            margin-top: 48px;
            font-size: 12px;
            color: rgba(255,255,255,0.4);
            letter-spacing: 1px;
        }
        .footer-info span { margin: 0 12px; }

        .feature-dots {
            display: flex;
            gap: 32px;
            justify-content: center;
            margin-bottom: 36px;
        }
        .feature-dot {
            text-align: center;
        }
        .feature-dot .icon {
            font-size: 24px;
            margin-bottom: 6px;
            opacity: 0.8;
        }
        .feature-dot .label {
            font-size: 11px;
            color: rgba(255,255,255,0.5);
        }
    </style>
</head>
<body>
    <div class="showcase">
        <div class="showcase-icon">&#127968;</div>
        <h1>高校公寓管理系统</h1>
        <p class="subtitle">Dormitory Management System</p>

        <div class="feature-dots">
            <div class="feature-dot">
                <div class="icon"><i class="fas fa-user-shield"></i></div>
                <div class="label">三角色权限</div>
            </div>
            <div class="feature-dot">
                <div class="icon"><i class="fas fa-clipboard-list"></i></div>
                <div class="label">入住调宿</div>
            </div>
            <div class="feature-dot">
                <div class="icon"><i class="fas fa-wrench"></i></div>
                <div class="label">报修运维</div>
            </div>
            <div class="feature-dot">
                <div class="icon"><i class="fas fa-chart-bar"></i></div>
                <div class="label">数据看板</div>
            </div>
        </div>

        <div class="tech-tags">
            <span class="tech-tag">Spring MVC 5.3</span>
            <span class="tech-tag">MyBatis 3.5</span>
            <span class="tech-tag">Spring AOP</span>
            <span class="tech-tag">MySQL 8.0</span>
            <span class="tech-tag">Bootstrap 5</span>
            <span class="tech-tag">jQuery</span>
        </div>

        <a href="${pageContext.request.contextPath}/login" class="btn-enter">
            进入系统 <i class="fas fa-arrow-right"></i>
        </a>

        <div class="footer-info">
            <span>企业级开发应用课程设计</span>
            <span>|</span>
            <span>2026</span>
        </div>
    </div>
</body>
</html>
