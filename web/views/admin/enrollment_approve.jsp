<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.eduadmin.model.entity.*" %>
<%@ page import="com.example.eduadmin.model.service.*" %>
<%@ page import="com.example.eduadmin.model.service.impl.*" %>
<%
    String path = request.getContextPath();
    EnrollmentService enrollService = new EnrollmentServiceImpl();
    StudentService studentService = new StudentServiceImpl();
    ScheduleService scheduleService = new ScheduleServiceImpl();
    CourseService courseService = new CourseServiceImpl();
    List pendingList = enrollService.findByStatus("pending");
    List approvedList = enrollService.findByStatus("approved");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>选课审核</title>
    <link rel="stylesheet" href="<%=path%>/static/css/common.css">
    <link rel="stylesheet" href="<%=path%>/static/css/admin.css">
    <script src="<%=path%>/static/js/common.js"></script>
</head>
<body>
    <jsp:include page="../common/header.jsp"/>
    <div class="admin-layout">
        <jsp:include page="../common/sidebar.jsp"/>
        <div class="main-content">
            <h2 style="margin-bottom:16px">选课审核</h2>
            <div class="card">
                <div class="card-title">待审核 (<%=pendingList.size()%>)</div>
                <table>
                    <thead><tr><th>学号</th><th>姓名</th><th>课程</th><th>申请时间</th><th>操作</th></tr></thead>
                    <tbody>
                        <% for (int i = 0; i < pendingList.size(); i++) {
                            Enrollment e = (Enrollment) pendingList.get(i);
                            Student s = studentService.findById(e.getStudentId());
                            CourseSchedule cs = scheduleService.findById(e.getScheduleId());
                            Course c = cs != null ? courseService.findById(cs.getCourseId()) : null;
                        %>
                        <tr>
                            <td><%=s != null ? s.getStudentNo() : e.getStudentId()%></td>
                            <td><%=s != null ? s.getName() : ""%></td>
                            <td><%=c != null ? c.getCourseName() : ""%></td>
                            <td><%=e.getEnrollDate()%></td>
                            <td>
                                <button class="btn btn-success btn-sm" onclick="location.href='<%=path%>/admin?method=approveEnrollment&enrollmentId=<%=e.getEnrollmentId()%>'">通过</button>
                                <button class="btn btn-danger btn-sm" onclick="location.href='<%=path%>/admin?method=rejectEnrollment&enrollmentId=<%=e.getEnrollmentId()%>'">拒绝</button>
                            </td>
                        </tr>
                        <% } %>
                        <% if (pendingList.isEmpty()) { %>
                        <tr><td colspan="5" style="text-align:center;color:#999">暂无待审核记录</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <div class="card">
                <div class="card-title">已通过 (<%=approvedList.size()%>)</div>
                <table>
                    <thead><tr><th>学号</th><th>姓名</th><th>课程</th><th>申请时间</th></tr></thead>
                    <tbody>
                        <% for (int i = 0; i < approvedList.size(); i++) {
                            Enrollment e = (Enrollment) approvedList.get(i);
                            Student s = studentService.findById(e.getStudentId());
                            CourseSchedule cs = scheduleService.findById(e.getScheduleId());
                            Course c = cs != null ? courseService.findById(cs.getCourseId()) : null;
                        %>
                        <tr>
                            <td><%=s != null ? s.getStudentNo() : e.getStudentId()%></td>
                            <td><%=s != null ? s.getName() : ""%></td>
                            <td><%=c != null ? c.getCourseName() : ""%></td>
                            <td><%=e.getEnrollDate()%></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <jsp:include page="../common/footer.jsp"/>