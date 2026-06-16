<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>404 - 页面未找到</title>
    <link rel="stylesheet" href="<%=path%>/static/css/common.css">
    <style>
        .error-page { text-align: center; padding: 100px 0; }
        .error-page h1 { font-size: 72px; color: #1890ff; }
        .error-page p { font-size: 18px; color: #999; margin: 16px 0 32px; }
    </style>
</head>
<body>
    <jsp:include page="common/header.jsp"/>
    <div class="container">
        <div class="error-page">
            <h1>404</h1>
            <p>抱歉，您访问的页面不存在</p>
            <a href="<%=path%>/views/index.jsp" class="btn btn-primary">返回首页</a>
        </div>
    </div>
</body>
</html>