<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="informationSystem.pojo.Email" %>
<%@ page import="informationSystem.pojo.User" %>
<%@ page import="informationSystem.service.UserService" %>
<%@ page import="informationSystem.service.EmailService" %>
<%@ page import="java.util.HashMap" %>
<%@ page isELIgnored="false" %>
<%
    response.setCharacterEncoding("UTF-8");
    request.setCharacterEncoding("UTF-8");

    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp?error=请先登录系统");
        return;
    }

%>
<!DOCTYPE html>
<html>
<head>
    <title>邮件详情 - ${email.subject}</title>
    <style>
        /* 基础样式 */
        :root {
            --primary-color: #1a73e8;
            --text-dark: #2d3748;
            --text-light: #718096;
        }

        body {
            font-family: 'Segoe UI', system-ui, sans-serif;
            margin: 2rem;
            background: #f7fafc;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            padding: 2rem;
        }

        /* 用户信息区域 */
        .user-section {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 2rem;
            border-bottom: 1px solid #e2e8f0;
            padding-bottom: 1.5rem;
            margin-bottom: 2rem;
        }

        .avatar {
            width: 64px;
            height: 64px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #e2e8f0;
        }

        .user-info {
            display: flex;
            gap: 1rem;
            align-items: center;
        }

        .user-meta {
            line-height: 1.5;
        }

        .username {
            font-weight: 600;
            color: var(--text-dark);
        }

        .user-role {
            color: var(--text-light);
            font-size: 0.9em;
        }

        /* 邮件内容区域 */
        .content-section {
            margin: 2rem 0;
        }

        .email-subject {
            font-size: 1.8rem;
            margin-bottom: 1.5rem;
            color: var(--text-dark);
        }

        .email-content {
            white-space: pre-wrap;
            line-height: 1.8;
            padding: 1.5rem;
            background: #f8fafc;
            border-radius: 8px;
            font-size: 1.1rem;
        }

        /* 附件区域 */
        .attachments-section {
            border-top: 1px solid #e2e8f0;
            padding-top: 2rem;
        }

        .attachment-list {
            list-style: none;
            padding: 0;
        }

        .attachment-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem;
            margin: 0.5rem 0;
            background: #f8fafc;
            border-radius: 6px;
            transition: background 0.2s;
        }

        .attachment-item:hover {
            background: #edf2f7;
        }

        .file-name {
            color: var(--primary-color);
            text-decoration: none;
            flex-grow: 1;
        }

        file-base {
            font-weight: 500;
            color: #333;
        }

        .file-ext {
            color: #666;
            font-size: 0.9em;
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .user-section {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <%-- 发件人/收件人信息 --%>
<%--        <c:if test="${specialAction eq 'inbox'}">   --%>
        <div class="user-section">
                    <%-- 发件人 --%>
                    <div class="user-info">
                        <img src="ravatar?receiverUsername=${email.senderUsername}"
                             class="avatar"
                             alt="发件人头像"
                             onerror="this.src='/images/default-avatar.jpeg'">
                        <div class="user-meta">
                            <div class="username">${email.senderUsername}</div>
                            <div class="user-role">发件人</div>
                        </div>
                    </div>

                    <%-- 收件人 --%>
                    <div class="user-info">
<%--                        <img src="avatar"        --%>
                        <img src="ravatar?receiverUsername=${email.receiverUsername}"
                             class="avatar"
                             alt="收件人头像"
                             onerror="this.src='/images/default-avatar.png'">
                        <div class="user-meta">
<%--                            <div class="username">${user.username}</div>    --%>
                            <div class="username">${email.receiverUsername}</div>
                            <div class="user-role">收件人</div>
                        </div>
                    </div>
                </div>
<%--        </c:if>    --%>

        <%-- 邮件元信息 --%>
        <div class="meta-section">
            <div class="email-subject">${fn:escapeXml(email.subject)}</div>
            <div class="send-time">
                <fmt:formatDate value="${email.sendTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
            </div>
        </div>

        <%-- 邮件正文 --%>
        <div class="content-section">
            <pre class="email-content">${fn:escapeXml(email.content)}</pre>
        </div>

        <%-- 附件列表 --%>
        <c:if test="${not empty email.attachments}">
            <div class="attachments-section">
                <h3>附件（${fn:length(email.attachments)}个）</h3>
                <ul class="attachment-list">
                    <c:forEach items="${email.attachments}" var="att">
                        <li class="attachment-item">
                            <a href="download?attachmentId=${att.id}"
                               class="file-name"
                               download="${att.fileName}">
                                <%-- 组合文件名和扩展名 --%>
                                <span class="file-base">${att.fileName}</span>
                            <%--
                                <c:if test="${not empty mimeToExt[att.fileType]}">
                                    <span class="file-ext">.${mimeToExt[att.fileType]}</span>
                                </c:if>
                            --%>
                            </a>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </c:if>
    </div>
</body>

</html>

<%
    request.getSession().removeAttribute("specialAction");
%>
