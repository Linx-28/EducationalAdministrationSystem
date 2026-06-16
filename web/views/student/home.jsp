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
    <title>学生主页</title>
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
                <a href="<%=path%>/student?method=enroll" class="home-card">
                    <div class="icon">&#128218;</div>
                    <h3>在线选课</h3>
                    <p>浏览可选课程，提交选课申请</p>
                </a>
                <a href="<%=path%>/student?method=mySchedule" class="home-card">
                    <div class="icon">&#128197;</div>
                    <h3>我的课表</h3>
                    <p>查看本学期课程安排</p>
                </a>
                <a href="<%=path%>/student?method=myScores" class="home-card">
                    <div class="icon">&#128202;</div>
                    <h3>成绩查询</h3>
                    <p>查看各科成绩和绩点</p>
                </a>
                <a href="<%=path%>/student?method=profile" class="home-card">
                    <div class="icon">&#128100;</div>
                    <h3>个人信息</h3>
                    <p>查看和修改个人信息</p>
                </a>
            </div>
        </div>
    </div>
    <jsp:include page="../common/footer.jsp"/>