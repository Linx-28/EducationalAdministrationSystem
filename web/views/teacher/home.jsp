<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String realName = (String) session.getAttribute("realName");
    if (realName == null || realName.isEmpty()) {
        com.example.eduadmin.model.entity.User user = (com.example.eduadmin.model.entity.User) session.getAttribute("user");
        realName = user != null ? user.getUsername() : "";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>教师主页</title>
    <link rel="stylesheet" href="<%=path%>/static/css/common.css">
    <link rel="stylesheet" href="<%=path%>/static/css/student.css">
</head>
<body>
    <jsp:include page="../common/header.jsp"/>
    <div class="admin-layout">
        <jsp:include page="../common/sidebar.jsp"/>
        <div class="main-content">
            <h2 style="margin-bottom:24px">欢迎, <%=realName%></h2>
            <div class="student-home">
                <a href="<%=path%>/teacher?method=scoreInput" class="home-card">
                    <div class="icon">&#9998;</div>
                    <h3>成绩录入</h3>
                    <p>录入授课班级学生成绩</p>
                </a>
                <a href="<%=path%>/teacher?method=viewScores" class="home-card">
                    <div class="icon">&#128202;</div>
                    <h3>成绩查看</h3>
                    <p>查看已录入的成绩</p>
                </a>
                <a href="<%=path%>/teacher?method=mySchedule" class="home-card">
                    <div class="icon">&#128197;</div>
                    <h3>我的课表</h3>
                    <p>查看授课安排</p>
                </a>
                <a href="<%=path%>/teacher?method=studentList" class="home-card">
                    <div class="icon">&#128101;</div>
                    <h3>学生名单</h3>
                    <p>查看授课班级学生</p>
                </a>
            </div>
        </div>
    </div>
    <jsp:include page="../common/footer.jsp"/>