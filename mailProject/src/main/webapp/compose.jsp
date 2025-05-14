<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="informationSystem.pojo.User" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page isELIgnored="false" %>
<%
    response.setCharacterEncoding("UTF-8");
    request.setCharacterEncoding("UTF-8");

    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp?error=请先登录系统");
        return;
    }

    User user = (User) session.getAttribute("user");

%>
<!DOCTYPE html>
<html>
<head>
    <title>写邮件 - 简易风电子邮箱</title>
    <style>
        :root {
            --primary-blue: #168BFA;
            --gray-bg: #F5F6F8;
            --border-color: #E0E2E5;
            --error-red: #ff4444;
        }

        body {
            font-family: "Microsoft YaHei", sans-serif;
            background: var(--gray-bg);
            margin: 0;
            padding: 20px;
        }

        .compose-container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            padding: 24px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 500;
        }

        input[type="text"],
        textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid var(--border-color);
            border-radius: 4px;
            font-size: 14px;
        }

        textarea {
            height: 300px;
            resize: vertical;
        }

       .file-card {
           display: flex;
           align-items: center;
           padding: 8px;
           background: #f8f9fa;
           border-radius: 4px;
           margin: 4px 0;
           width: 100%; 
           box-sizing: border-box;
       }

       .file-name {
           flex: 1;
           margin: 0 12px;
           color: black;
           overflow: hidden;
           cursor: pointer;
           text-overflow: ellipsis;
           white-space: nowrap; 
           min-width: 200px; 
       }

        .file-size {
            color: #666;
            font-size: 0.9em;
        }

        .remove-file {
            color: var(--error-red);
            cursor: pointer;
            margin-left: 8px;
        }

        .submit-btn {
            background: var(--primary-blue);
            color: white;
            padding: 10px 30px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            float: right;
            transition: background 0.2s;
        }

        .submit-btn:hover {
            background: #127AD8;
        }

        .error-message {
            color: var(--error-red);
            margin-bottom: 15px;
            padding: 10px;
            background: #ffecec;
            border-radius: 4px;
        }

        .error-hint {
            color: var(--error-red);
            font-size: 0.9em;
            margin-top: 5px;
            display: none;
        }

        .file-input button {
            padding: 8px 16px;
            background: #f0f2f5;
            border: 1px dashed var(--border-color);
            border-radius: 4px;
            cursor: pointer;
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
    </style>
</head>
<body>
    <div class="compose-container">
        <h1 style="margin-bottom:24px;">写信</h1>

        <c:if test="${not empty error}">
            <div class="error-message">ERROR: ${error}</div>
        </c:if>

        <form action="compose" method="post" enctype="multipart/form-data">
            <%-- 添加隐藏字段 --%>
            <input type="hidden" name="action" value="send" id="actionField">
            <c:if test="${not empty draft}">
            	<input type="hidden" name="draftId" value="${draft.id}">
            </c:if>
            <%-- 收件人输入 --%>
            <div class="form-group">
                <label>收件人：</label>
                <input type="text"
                       name="receiver"
                       required
                       placeholder="请输入收件人邮箱（输入1-10位字母/数字）"
                       pattern="^[a-zA-Z0-9]{1,10}$"
                       title="用户名必须为1-10位字母或数字"
                       id="receiverInput">
                <div class="error-hint" id="receiverError"></div>
            </div>

            <%-- 邮件主题 --%>
            <div class="form-group">
                <label>主题：</label>
                <input type="text"
                       name="subject"
                       required
                       maxlength="100"
                       placeholder="请输入邮件主题">
            </div>

            <%-- 邮件内容 --%>
            <div class="form-group">
                <label>内容：</label>
                <textarea name="content"
                          required
                          placeholder="编写邮件内容..."></textarea>
            </div>

            <%-- 附件上传 --%>
            <div class="form-group">
                <label>附件：</label>
                <div class="file-input">
                    <button type="button" onclick="document.getElementById('fileInput').click()">
                         添加附件（最多5个，每个≤10MB）
                    </button>
                    <input type="file"
                           name="attachments"
                           multiple
                           id="fileInput"
                           style="display:none;">
                </div>
                <div id="fileList"></div>
            </div>

            <%-- 操作按钮 --%>
            <div style="display: flex; justify-content: flex-end; gap: 10px; padding-top: 20px;">
                <button type="button"
                        class="submit-btn"
                        onclick="saveDraft()"
                        style="background:#666;">
                    保存草稿
                </button>
                <button type="submit" class="submit-btn">发送邮件</button>
            </div>
        </form>
    </div>

<script>
    // 全局变量用于跟踪已选择的文件
    let selectedFiles = [];

    // 用户名实时验证（1-10位字母数字）
    const receiverInput = document.getElementById('receiverInput');
    const receiverError = document.getElementById('receiverError');

    receiverInput.addEventListener('input', () => {
        const value = receiverInput.value.trim();
        const isValid = /^[a-zA-Z0-9]{1,10}$/.test(value);

        receiverError.textContent = isValid ? "" : "必须为1-10位字母/数字";
        receiverError.style.display = isValid ? "none" : "block";
    });

    // 文件上传处理
    document.getElementById('fileInput').addEventListener('change', function(e) {
        const newFiles = Array.from(this.files);
        console.log("New files selected:", newFiles);

        // 合并新文件到已选文件列表
        const mergedFiles = [...selectedFiles, ...newFiles];

        // 去重（根据文件名+大小+类型）
        const uniqueFiles = [];
        const seen = new Set();
        for (const file of mergedFiles) {
            const key = file.name + file.size + file.type;
            if (!seen.has(key)) {
                seen.add(key);
                uniqueFiles.push(file);
            }
        }

        // 检查文件数量
        if (uniqueFiles.length > 5) {
            alert('最多选择5个文件');
            selectedFiles = uniqueFiles.slice(0, 5); 
        } else {
            selectedFiles = uniqueFiles;
        }

        // 过滤大小超限文件
        selectedFiles = selectedFiles.filter(file => {
            if (file.size > 10 * 1024 * 1024) {
                alert(`文件 ${file.name} 超过10MB限制`);
                return false;
            }
            return true;
        });

        // 更新文件输入框
        const dt = new DataTransfer();
        selectedFiles.forEach(file => dt.items.add(file));
        this.files = dt.files;

        console.log("Merged selectedFiles:", selectedFiles);
        // 渲染文件列表
        renderFileList();
    });

    // 渲染文件列表到页面
    function renderFileList() {
        const fileList = document.getElementById('fileList');
        fileList.innerHTML = ''; // 清空旧内容

        selectedFiles.forEach((file, index) => {
            const sizeInMB = (file.size / 1024 / 1024).toFixed(2).toString();
            console.log("sizeInMB: ", sizeInMB);
            // 创建文件卡片
            const cardElement = document.createElement('div');
            cardElement.classList.add('file-card');

            // 文件名
            const fileNameElement = document.createElement('div');
            fileNameElement.classList.add('file-name');
            fileNameElement.textContent = file.name;
            cardElement.appendChild(fileNameElement);

            // 文件大小
            const fileSizeElement = document.createElement('div');
            fileSizeElement.classList.add('file-size');
            fileSizeElement.textContent = (sizeInMB + ' MB');
            cardElement.appendChild(fileSizeElement);

            // 删除按钮
            const removeButton = document.createElement('div');
            removeButton.classList.add('remove-file');
            removeButton.textContent = '✖';
            removeButton.onclick = () => removeFile(index);
            cardElement.appendChild(removeButton);

            // 追加到文件列表
            fileList.appendChild(cardElement);
        });
    }

    // 删除指定文件
    function removeFile(index) {
        selectedFiles.splice(index, 1); // 移除文件

        // 更新文件输入框
        const input = document.getElementById('fileInput');
        const dt = new DataTransfer();
        selectedFiles.forEach(file => dt.items.add(file));
        input.files = dt.files;

        renderFileList(); // 重新渲染
    }

    // 保存草稿
    function saveDraft() {
        document.getElementById('actionField').value = 'draft';
        document.querySelector('form').submit();
    }

    document.querySelector('form').addEventListener('submit', function(e) {
        if (!/^[a-zA-Z0-9]{1,10}$/.test(receiverInput.value.trim())) {
            e.preventDefault();
            receiverError.style.display = 'block';
            receiverInput.focus();
            return;
        }

        for(let file of selectedFiles) {
            if(file.size > 10 * 1024 * 1024) {
                e.preventDefault();
                alert('存在超过10MB限制的文件');
                return;
            }
        }
    });
    // 页面加载时填充草稿数据
    window.addEventListener('DOMContentLoaded', () => {
        <c:if test="${not empty draft}">
            // 填充表单字段
            // 安全填充接收人（允许receiver为空）
            document.querySelector('[name="receiver"]').value =
                '${not empty draft.receiverUsername ? fn:escapeXml(draft.receiverUsername) : ""}';

            // 安全填充主题（允许subject为空）
            document.querySelector('[name="subject"]').value =
                '${not empty draft.subject ? fn:escapeXml(draft.subject) : ""}';

            // 安全填充内容
            document.querySelector('[name="content"]').value =
                '${not empty draft.content ? fn:escapeXml(draft.content) : ""}';
        </c:if>
    });

</script>
</body>
</html>


