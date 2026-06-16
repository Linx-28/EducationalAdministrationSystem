<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    if (session.getAttribute("user") != null) {
        response.sendRedirect(path + "/home");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>登录 - 教务管理系统</title>
    <link rel="stylesheet" href="<%=path%>/static/css/common.css">
    <style>
        .login-wrapper { display: flex; justify-content: center; align-items: center; min-height: 80vh; }
        .login-box { width: 400px; background: #fff; border-radius: 8px; box-shadow: 0 2px 12px rgba(0,0,0,.1); padding: 40px; }
        .login-box h2 { text-align: center; margin-bottom: 32px; color: #333; font-size: 24px; }
        .login-box .form-group { margin-bottom: 20px; }
        .login-box .form-group input { padding: 10px 12px; font-size: 15px; }
        .login-box .btn-primary { width: 100%; padding: 10px; font-size: 16px; margin-top: 8px; }
        .role-select { display: flex; gap: 12px; justify-content: center; margin-bottom: 20px; }
        .role-select label { cursor: pointer; padding: 8px 20px; border: 1px solid #d9d9d9; border-radius: 4px; font-size: 14px; transition: all .3s; }
        .role-select input[type=radio] { display: none; }
        .role-select input[type=radio]:checked + label { background: #1890ff; color: #fff; border-color: #1890ff; }
        .error-msg { color: #ff4d4f; text-align: center; margin-bottom: 16px; font-size: 14px; }
    </style>
</head>
<body>
    <jsp:include page="common/header.jsp"/>
    <div class="container">
        <div class="login-wrapper">
            <div class="login-box">
                <h2>教务管理系统</h2>
                <% if (request.getAttribute("error") != null) { %>
                    <div class="error-msg"><%=request.getAttribute("error")%></div>
                <% } %>
                <form id="loginForm" action="<%=path%>/login?method=login" method="post" autocomplete="off">
                    <div class="role-select">
                        <input type="radio" name="role" value="student" id="roleStudent" checked onchange="updateLabel()">
                        <label for="roleStudent">学生</label>
                        <input type="radio" name="role" value="teacher" id="roleTeacher" onchange="updateLabel()">
                        <label for="roleTeacher">教师</label>
                        <input type="radio" name="role" value="admin" id="roleAdmin" onchange="updateLabel()">
                        <label for="roleAdmin">管理员</label>
                    </div>
                    <div class="form-group">
                        <label id="accountLabel">学号</label>
                        <input type="text" name="username" id="username" placeholder="请输入学号" autocomplete="off" required>
                    </div>
                    <div class="form-group">
                        <label>密码</label>
                        <input type="password" name="password" id="password" placeholder="请输入密码" autocomplete="new-password" required>
                    </div>
                    <button type="submit" class="btn btn-primary">登 录</button>
                </form>
                <script>
                    function updateLabel() {
                        var label = document.getElementById('accountLabel');
                        var input = document.getElementById('username');
                        var role = document.querySelector('input[name="role"]:checked').value;
                        if (role === 'student') {
                            label.textContent = '学号';
                            input.placeholder = '请输入学号';
                        } else if (role === 'teacher') {
                            label.textContent = '工号';
                            input.placeholder = '请输入工号';
                        } else {
                            label.textContent = '用户名';
                            input.placeholder = '请输入用户名';
                        }
                        input.value = '';
                    }
                </script>
            </div>
        </div>
    </div>
    <jsp:include page="common/footer.jsp"/>