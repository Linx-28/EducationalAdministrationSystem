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
    <title>教务管理系统</title>
    <link rel="stylesheet" href="<%=path%>/static/css/common.css">
    <style>
        .welcome { text-align: center; padding: 100px 0; }
        .welcome h1 { font-size: 36px; color: #1890ff; margin-bottom: 16px; }
        .welcome p { font-size: 18px; color: #666; margin-bottom: 32px; }
        .welcome .btn { font-size: 16px; padding: 10px 32px; margin: 0 8px; }
    </style>
</head>
<body>
    <jsp:include page="common/header.jsp"/>
    <div class="container">
        <div class="welcome">
            <h1>欢迎使用教务管理系统</h1>
            <p> Educational Administration System</p>
            <a href="<%=path%>/views/login.jsp" class="btn btn-primary">立即登录</a>
        </div>
    </div>
    <jsp:include page="common/footer.jsp"/>



