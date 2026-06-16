<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.eduadmin.model.service.*" %>
<%@ page import="com.example.eduadmin.model.service.impl.*" %>
<%
    String path = request.getContextPath();
    StudentService studentService = new StudentServiceImpl();
    TeacherService teacherService = new TeacherServiceImpl();
    CourseService courseService = new CourseServiceImpl();
    EnrollmentService enrollService = new EnrollmentServiceImpl();
    int studentCount = studentService.count();
    int teacherCount = teacherService.findAll().size();
    int courseCount = courseService.findAll().size();
    int pendingCount = enrollService.findByStatus("pending").size();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>管理后台 - 仪表盘</title>
    <link rel="stylesheet" href="<%=path%>/static/css/common.css">
    <link rel="stylesheet" href="<%=path%>/static/css/admin.css">
</head>
<body>
    <jsp:include page="../common/header.jsp"/>
    <div class="admin-layout">
        <jsp:include page="../common/sidebar.jsp"/>
        <div class="main-content">
            <h2 style="margin-bottom:24px">仪表盘</h2>
            <div class="dashboard-stats">
                <div class="dashboard-card"><div class="title">学生总数</div><div class="value blue"><%=studentCount%></div></div>
                <div class="dashboard-card"><div class="title">教师总数</div><div class="value green"><%=teacherCount%></div></div>
                <div class="dashboard-card"><div class="title">课程总数</div><div class="value orange"><%=courseCount%></div></div>
                <div class="dashboard-card"><div class="title">待审核选课</div><div class="value red"><%=pendingCount%></div></div>
            </div>
            <div class="card">
                <div class="card-title">快捷操作</div>
                <a href="<%=path%>/admin?method=studentManage" class="btn btn-primary" style="margin:4px">学生管理</a>
                <a href="<%=path%>/admin?method=teacherManage" class="btn btn-primary" style="margin:4px">教师管理</a>
                <a href="<%=path%>/admin?method=courseManage" class="btn btn-primary" style="margin:4px">课程管理</a>
                <a href="<%=path%>/admin?method=scheduleManage" class="btn btn-primary" style="margin:4px">排课管理</a>
                <a href="<%=path%>/admin?method=enrollmentApprove" class="btn btn-primary" style="margin:4px">选课审核</a>
                <a href="<%=path%>/admin?method=scoreManage" class="btn btn-primary" style="margin:4px">成绩管理</a>
            </div>
        </div>
    </div>
    <jsp:include page="../common/footer.jsp"/>