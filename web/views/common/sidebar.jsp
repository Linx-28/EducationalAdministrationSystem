<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String method = request.getParameter("method") != null ? request.getParameter("method") : "";
    com.example.eduadmin.model.entity.User user = (com.example.eduadmin.model.entity.User) session.getAttribute("user");
    String role = user != null ? user.getRole() : "";
%>
<div class="sidebar">
    <% if ("student".equals(role)) { %>
        <a href="<%=path%>/student?method=home" class="<%=method.equals("home")?"active":""%>">我的主页</a>
        <a href="<%=path%>/student?method=enroll" class="<%=method.equals("enroll")?"active":""%>">选课</a>
        <a href="<%=path%>/student?method=mySchedule" class="<%=method.equals("mySchedule")?"active":""%>">我的课表</a>
        <a href="<%=path%>/student?method=myScores" class="<%=method.equals("myScores")?"active":""%>">成绩查询</a>
        <a href="<%=path%>/student?method=profile" class="<%=method.equals("profile")?"active":""%>">个人信息</a>
    <% } else if ("teacher".equals(role)) { %>
        <a href="<%=path%>/teacher?method=home" class="<%=method.equals("home")?"active":""%>">我的主页</a>
        <a href="<%=path%>/teacher?method=scoreInput" class="<%=method.equals("scoreInput")?"active":""%>">成绩录入</a>
        <a href="<%=path%>/teacher?method=viewScores" class="<%=method.equals("viewScores")?"active":""%>">成绩查看</a>
        <a href="<%=path%>/teacher?method=mySchedule" class="<%=method.equals("mySchedule")?"active":""%>">我的课表</a>
        <a href="<%=path%>/teacher?method=studentList" class="<%=method.equals("studentList")?"active":""%>">学生名单</a>
    <% } else if ("admin".equals(role)) { %>
        <a href="<%=path%>/admin?method=dashboard" class="<%=method.equals("dashboard")?"active":""%>">仪表盘</a>
        <a href="<%=path%>/admin?method=studentManage" class="<%=method.equals("studentManage")?"active":""%>">学生管理</a>
        <a href="<%=path%>/admin?method=teacherManage" class="<%=method.equals("teacherManage")?"active":""%>">教师管理</a>
        <a href="<%=path%>/admin?method=courseManage" class="<%=method.equals("courseManage")?"active":""%>">课程管理</a>
        <a href="<%=path%>/admin?method=scheduleManage" class="<%=method.equals("scheduleManage")?"active":""%>">排课管理</a>
        <a href="<%=path%>/admin?method=enrollmentApprove" class="<%=method.equals("enrollmentApprove")?"active":""%>">选课审核</a>
        <a href="<%=path%>/admin?method=scoreManage" class="<%=method.equals("scoreManage")?"active":""%>">成绩管理</a>
        <a href="<%=path%>/admin?method=classroomManage" class="<%=method.equals("classroomManage")?"active":""%>">教室管理</a>
        <a href="<%=path%>/admin?method=semesterManage" class="<%=method.equals("semesterManage")?"active":""%>">学期设置</a>
    <% } %>
</div>