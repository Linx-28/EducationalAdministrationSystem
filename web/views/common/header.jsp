<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
%>
<meta name="basePath" content="<%=path%>">
<link rel="stylesheet" href="<%=path%>/static/css/common.css">
<div class="navbar">
    <div class="logo">教务管理系统</div>
    <div class="nav-menu">
        <a href="<%=path%>/views/index.jsp">首页</a>
    </div>
    <div class="nav-right">
        <% if (session.getAttribute("user") != null) {
            String realName = (String) session.getAttribute("realName");
            if (realName == null || realName.isEmpty()) {
                realName = ((com.example.eduadmin.model.entity.User)session.getAttribute("user")).getUsername();
            }
        %>
            <span>欢迎, <%=realName%></span>
            <a href="<%=path%>/login?method=logout">退出</a>
        <% } else { %>
            <a href="<%=path%>/views/login.jsp">登录</a>
        <% } %>
    </div>
</div>
