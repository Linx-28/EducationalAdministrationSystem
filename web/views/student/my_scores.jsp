<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.eduadmin.model.entity.*" %>
<%@ page import="com.example.eduadmin.model.service.*" %>
<%@ page import="com.example.eduadmin.model.service.impl.*" %>
<%@ page import="com.example.eduadmin.util.GradeCalculator" %>
<%
    String path = request.getContextPath();
    User user = (User) session.getAttribute("user");
    ScoreService scoreService = new ScoreServiceImpl();
    ScheduleService scheduleService = new ScheduleServiceImpl();
    CourseService courseService = new CourseServiceImpl();
    List scores = scoreService.findByStudentId(user.getUserId());
    double totalCredits = 0;
    double totalPoints = 0;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>成绩查询</title>
    <link rel="stylesheet" href="<%=path%>/static/css/common.css">
    <link rel="stylesheet" href="<%=path%>/static/css/student.css">
</head>
<body>
    <jsp:include page="../common/header.jsp"/>
    <div class="admin-layout">
        <jsp:include page="../common/sidebar.jsp"/>
        <div class="main-content">
            <h2 style="margin-bottom:16px">成绩查询</h2>
            <div class="alert alert-success" style="margin-bottom:16px">
                <b>成绩计算规则：</b>最终分 = 平时分 × 30% + 考试分 × 70%&nbsp;&nbsp;|&nbsp;&nbsp;GPA = 各科绩点按学分加权平均
            </div>
            <div class="card">
                <div class="gpa-display">
                    GPA: 
                    <% for (int i = 0; i < scores.size(); i++) {
                        Score s = (Score) scores.get(i);
                        CourseSchedule cs = scheduleService.findById(s.getScheduleId());
                        if (cs != null) {
                            Course c = courseService.findById(cs.getCourseId());
                            if (c != null) { totalCredits += c.getCredit(); totalPoints += s.getGpa() * c.getCredit(); }
                        }
                    } %>
                    <%=totalCredits > 0 ? String.format("%.2f", totalPoints / totalCredits) : "0.00"%>
                </div>
            </div>
            <div class="card">
                <table class="score-table">
                    <thead>
                        <tr><th>课程名称</th><th>平时分</th><th>考试分</th><th>最终分</th><th>绩点</th></tr>
                    </thead>
                    <tbody>
                        <% for (int i = 0; i < scores.size(); i++) {
                            Score s = (Score) scores.get(i);
                            CourseSchedule cs = scheduleService.findById(s.getScheduleId());
                            Course c = cs != null ? courseService.findById(cs.getCourseId()) : null;
                        %>
                        <tr>
                            <td><%=c != null ? c.getCourseName() : ""%></td>
                            <td><%=s.getRegularScore() != null ? s.getRegularScore() : "-"%></td>
                            <td><%=s.getExamScore() != null ? s.getExamScore() : "-"%></td>
                            <td><%=s.getFinalScore() != null ? String.format("%.1f", s.getFinalScore()) : "-"%></td>
                            <td><%=s.getGpa() != null ? String.format("%.1f", s.getGpa()) : "-"%></td>
                        </tr>
                        <% } %>
                        <% if (scores.isEmpty()) { %>
                        <tr><td colspan="5" style="text-align:center;color:#999">暂无成绩记录</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <jsp:include page="../common/footer.jsp"/>