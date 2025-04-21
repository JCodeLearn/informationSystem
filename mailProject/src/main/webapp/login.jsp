<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>简易风电子邮箱</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f0f2f5;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .login-box {
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            width: 320px;
        }
        h1 {
            color: #1a73e8;
            text-align: center;
            margin-bottom: 1.5rem;
        }
        .input-group {
            margin-bottom: 1.5rem;
        }
        input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            box-sizing: border-box;
            font-size: 14px;
        }
        input:focus {
            border-color: #1a73e8;
            box-shadow: 0 0 0 2px rgba(26,115,232,0.2);
        }
        button {
            width: 100%;
            padding: 12px;
            background: #1a73e8;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            transition: background 0.3s;
        }
        button:hover {
            background: #1557b0;
        }
    </style>
</head>
<body>
    <div class="login-box">
        <h1>简易风电子邮箱</h1>

        <%-- 错误提示 --%>
        <% if(request.getAttribute("error") != null) { %>
            <div style="color: red; margin-bottom: 1rem;">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <form action="login" method="post" onsubmit="return validateForm()">
            <div class="input-group">
                <input type="text" name="username"
                       placeholder="请输入账号（1-10位字母/数字）"
                       pattern="^[a-zA-Z0-9]{1,10}$"
                       required>
            </div>

            <div class="input-group">
                <input type="password" name="password"
                       placeholder="请输入密码（10位字母/数字）"
                       pattern="^[a-zA-Z0-9]{10}$"
                       required>
            </div>

            <button type="submit">登录 / 注册</button>
        </form>
    </div>

    <script>
        function validateForm() {
            const username = document.getElementsByName("username")[0].value;
            const password = document.getElementsByName("password")[0].value;

            if (!/^[a-zA-Z0-9]{1,10}$/.test(username)) {
                alert("账号格式错误！请输入1-10位字母或数字");
                return false;
            }

            if (!/^[a-zA-Z0-9]{10}$/.test(password)) {
                alert("密码格式错误！必须为10位字母或数字");
                return false;
            }

            return true;
        }
    </script>
</body>
</html>