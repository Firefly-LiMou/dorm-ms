<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>高校公寓管理系统</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/vendor/bootstrap/css/bootstrap.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, rgb(196, 69, 58) 0%, rgb(176, 55, 46) 50%, rgb(156, 45, 38) 100%);
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
            color: rgb(255, 255, 255);
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
            background: rgb(255, 255, 255);
            color: rgb(196, 69, 58);
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
            color: rgb(156, 45, 38);
        }

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
                <div class="icon"><svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg></div>
                <div class="label">三角色权限</div>
            </div>
            <div class="feature-dot">
                <div class="icon"><svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"/><rect x="8" y="2" width="8" height="4" rx="1" ry="1"/></svg></div>
                <div class="label">入住调宿</div>
            </div>
            <div class="feature-dot">
                <div class="icon"><svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"/></svg></div>
                <div class="label">报修运维</div>
            </div>
            <div class="feature-dot">
                <div class="icon"><svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg></div>
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
            进入系统 <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" style="vertical-align: middle; margin-left: 8px;"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/></svg>
        </a>

        <div class="footer-info">
            <span>企业级开发应用课程设计</span>
            <span>|</span>
            <span>2026</span>
        </div>
    </div>
</body>
</html>
