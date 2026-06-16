<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%
    String path = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>500 - 服务器错误</title>
    <link rel="stylesheet" href="<%=path%>/static/css/common.css">
    <style>
        .error-page { text-align: center; padding: 100px 0; }
        .error-page h1 { font-size: 72px; color: #ff4d4f; }
        .error-page p { font-size: 18px; color: #999; margin: 16px 0 32px; }
    </style>
</head>
<body>
    <jsp:include page="common/header.jsp"/>
    <div class="container">
        <div class="error-page">
            <h1>500</h1>
            <p>服务器内部错误，请稍后再试</p>
            <a href="<%=path%>/views/index.jsp" class="btn btn-primary">返回首页</a>
        </div>
    </div>
</body>
</html>