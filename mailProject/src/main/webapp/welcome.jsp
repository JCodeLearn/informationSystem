<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="informationSystem.pojo.User" %>
<%@ page isELIgnored="false" %>
<%
    // 强制设置响应编码（必须在获取任何输出流之前设置）
    response.setCharacterEncoding("UTF-8");
    request.setCharacterEncoding("UTF-8");

    // 会话验证
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp?error=请先登录系统");
        return; // 必须终止后续执行
    }

    // 类型安全转换
    //User user = (User) session.getAttribute("user");
    User user = (User) request.getSession().getAttribute("user");
    String username = user.getUsername();
%>
<!DOCTYPE html>
<html>
<head>
    <title>欢迎使用 - 简易风电子邮箱</title>
    <style>
        /* 基础样式 */
        :root {
            --primary-color: #1a73e8;
            --sidebar-width: 240px;
            --header-height: 80px;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f7fa;
        }

        /* 头部区域 */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            height: var(--header-height);
            padding: 0 2rem;
            background: white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .logo-section {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .logo {
            height: 40px;
        }

        .compose-link {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
        }

        /* 用户信息 */
        .user-profile {
            display: flex;
            align-items: center;
            gap: 1rem;
            cursor: pointer;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
        }

        /* 主体布局 */
        .main-container {
            display: grid;
            grid-template-columns: var(--sidebar-width) 1fr;
            min-height: calc(100vh - var(--header-height));
        }

        /* 左侧导航 */
        .sidebar {
            background: white;
            padding: 1.5rem;
            border-right: 1px solid #e0e0e0;
        }

        .nav-menu {
            list-style: none;
        }

        .nav-item {
            padding: 1rem;
            margin: 0.5rem 0;
            border-radius: 6px;
            cursor: pointer;
            transition: background 0.2s;
        }

        .nav-item:hover {
            background: #f5f7fa;
        }

        .nav-item.active {
            background: var(--primary-color);
            color: white;
        }

        /* 右侧内容区 */
        .content-area {
            padding: 2rem;
            background: #f8f9fa;
        }

        .content-pane {
            background: white;
            border-radius: 8px;
            padding: 2rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            min-height: 80vh;
        }

         .compose-box {
            background: #f5f5f5;
            border: 1px solid #ddd;
            border-radius: 6px;
            padding: 8px 16px;
            transition: all 0.2s;
            margin-left: 20px; /* 与logo保持间距 */
         }

         .compose-box:hover {
            background: #e0e0e0;
            border-color: #ccc;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
         }

         .compose-link {
            color: #666;
            text-decoration: none;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
         }

         .picture-box {
            height: 100%;
            width: 20%;
         }

         .picture-box img {
            height: 100%;
            width: 100%;
         }
    </style>
</head>
<body>
    <div class="header">
        <%-- 左侧Logo和写信链接 --%>
        <div class="logo-section">
            <img src="images/logo.jpeg" alt="邮箱Logo" class="logo">
            <div class="compose-box">
                        <div class="picture-box">
                            <img src="images/email_box.jpeg">
                        </div>
                        <a href="compose.jsp" class="compose-link">写信</a>
            </div>
        </div>

        <%-- 右侧用户信息 --%>
        <div class="user-profile" onclick="location.href='avatar-upload.jsp'">
            <img src="avatar"
                 alt="用户头像"
                 class="user-avatar"
                 onerror="this.src='images/default-avatar.jpeg">
            <span>${user.username}</span>
        </div>
    </div>

    <div class="main-container">
        <%-- 左侧导航菜单 --%>
        <nav class="sidebar">
            <ul class="nav-menu">
                <li class="nav-item active" data-target="inbox">
                    <div class="picture-box">
                        <img src="images/inbox.jpeg">
                    </div>
                    收件箱
                </li>
               <li class="nav-item" data-target="draft">
                                   <div class="picture-box">
                                       <img src="images/history.jpeg" alt="草稿箱图标">
                                   </div>
                                   草稿箱
               </li>
                <li class="nav-item" data-target="sent">
                    <div class="picture-box">
                        <img src="images/beenDistributed.jpeg">
                    </div>
                    已发送
                </li>
                <li class="nav-item" data-target="contacts">
                    <div class="picture-box">
                        <img src="images/relatio.jpeg">
                    </div>
                    通讯录
                </li>
                <li class="nav-item" data-target="trash">
                    <div class="picture-box">
                        <img src="images/rubbish.jpeg">
                    </div>
                    垃圾箱
                </li>
            </ul>
        </nav>

        <%-- 右侧动态内容区 --%>
        <main class="content-area">
            <div class="content-pane" id="contentPane">
                <%-- 默认显示收件箱内容 --%>
                <h2>收件箱</h2>
                <div class="email-list">
                    <%-- 邮件列表动态内容 --%>
                    <c:forEach items="${emails}" var="email">
                        <div class="email-item">
                            <div class="sender">${email.sender}</div>
                            <div class="subject">${email.subject}</div>
                            <div class="preview">${email.preview}...</div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </main>
    </div>

    <script>
        // 导航切换功能
        document.querySelectorAll('.nav-item').forEach(item => {
            item.addEventListener('click', function() {
                // 移除所有激活状态
                document.querySelectorAll('.nav-item').forEach(nav =>
                    nav.classList.remove('active'));

                // 添加当前激活状态
                this.classList.add('active');

                // 获取目标内容
                const target = this.dataset.target;
                loadContent(target);
            });
        });

        // 动态加载内容
        function loadContent(target) {
                const contentPane = document.getElementById('contentPane');

                // 显示加载状态
                contentPane.innerHTML = '<div class="loading">加载中...</div>';

                // 使用Fetch API获取内容
                fetch('/mail?action=' + target)
                    .then(response => response.text())
                    .then(html => {
                        contentPane.innerHTML = html;
                    })
                    .catch(error => {
                        contentPane.innerHTML = `<div class="error">内容加载失败</div>`;
                    });
        }

 setInterval(checkNewMails, 30000);

         function checkNewMails() {
             fetch('/mail?action=checkNew') // 发送检查请求
                 .then(response => response.json()) // 解析JSON响应
                 .then(data => {
                     if(data.hasNew) { // 根据响应结果判断
                         showNewMailAlert(); // 显示通知
                         loadContent('inbox'); // 刷新收件箱列表
                     }
                 });
         }

         function showNewMailAlert() {
             const alertDiv = document.createElement('div');
             alertDiv.style = "position:fixed; top:20px; right:20px; background:#4CAF50; color:white; padding:15px;";
             alertDiv.textContent = "请查收新邮件！";
             document.body.appendChild(alertDiv);
             setTimeout(() => alertDiv.remove(), 5000); // 5秒后自动消失
         }

    </script>
</body>
</html>