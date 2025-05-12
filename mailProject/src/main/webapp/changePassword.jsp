<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html>
<head>
    <title>修改密码</title>
    <style>
        .password-container {
            max-width: 400px;
            margin: 2rem auto;
            padding: 2rem;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .form-group {
            margin-bottom: 1rem;
        }

        input[type="password"] {
            width: 100%;
            padding: 0.8rem;
            border: 1px solid #ddd;
            border-radius: 4px;
        }

        .error-message {
            color: #e74c3c;
            margin-bottom: 1rem;
        }

        .submit-btn {
            background: #1a73e8;
            color: white;
            padding: 0.8rem 1.5rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div class="password-container">
        <h2>修改密码</h2>
        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>

        <form action="change-password" method="post">
            <div class="form-group">
                <input type="password"
                       name="oldPassword"
                       placeholder="请输入原密码"
                       required
                       pattern="[A-Za-z0-9]{10}"
                       title="密码必须为10位字母或数字">
            </div>

            <div class="form-group">
                <input type="password"
                       name="newPassword"
                       placeholder="请输入新密码（10位字母/数字）"
                       required
                       pattern="[A-Za-z0-9]{10}">
            </div>

            <div class="form-group">
                <input type="password"
                       name="confirmPassword"
                       placeholder="请再次输入新密码"
                       required
                       pattern="[A-Za-z0-9]{10}">
            </div>
            <div class="error-message" id="clientError"></div>
            <button type="submit" class="submit-btn">提交修改</button>
        </form>
    </div>
</body>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const form = document.querySelector('form');
    const newPasswordInput = document.querySelector('input[name="newPassword"]');
    const confirmPasswordInput = document.querySelector('input[name="confirmPassword"]');
    const errorDiv = document.querySelector('.error-message');

    // 实时检查密码一致性（输入时触发）
    confirmPasswordInput.addEventListener('input', function() {
        validatePasswordMatch();
    });

    // 提交前验证
    form.addEventListener('submit', function(event) {
        if (!validatePasswordMatch()) {
            event.preventDefault(); // 阻止表单提交
        }
    });

    // 验证函数
    function validatePasswordMatch() {
        const newPassword = newPasswordInput.value;
        const confirmPassword = confirmPasswordInput.value;

        if (newPassword !== confirmPassword) {
            errorDiv.textContent = '两次输入的新密码不一致';
            confirmPasswordInput.setCustomValidity('密码不一致'); // HTML5 表单验证
            return false;
        } else {
            errorDiv.textContent = '';
            confirmPasswordInput.setCustomValidity('');
            return true;
        }
    }
});
</script>

</html>