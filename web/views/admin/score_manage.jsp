<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Comparator" %>
<%@ page import="com.example.eduadmin.model.entity.*" %>
<%@ page import="com.example.eduadmin.model.service.*" %>
<%@ page import="com.example.eduadmin.model.service.impl.*" %>
<%
    String path = request.getContextPath();
    ScoreService scoreService = new ScoreServiceImpl();
    ScheduleService scheduleService = new ScheduleServiceImpl();
    CourseService courseService = new CourseServiceImpl();
    StudentService studentService = new StudentServiceImpl();
    List allSchedules = scheduleService.findBySemester("2025-2026-1");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>成绩管理</title>
    <link rel="stylesheet" href="<%=path%>/static/css/common.css">
    <link rel="stylesheet" href="<%=path%>/static/css/admin.css">
    <script src="<%=path%>/static/js/common.js"></script>
</head>
<body>
    <jsp:include page="../common/header.jsp"/>
    <div class="admin-layout">
        <jsp:include page="../common/sidebar.jsp"/>
        <div class="main-content">
            <h2 style="margin-bottom:16px">成绩管理</h2>
            <% for (int i = 0; i < allSchedules.size(); i++) {
                CourseSchedule cs = (CourseSchedule) allSchedules.get(i);
                Course c = courseService.findById(cs.getCourseId());
                List scores = scoreService.findByScheduleId(cs.getScheduleId());
                Double avg = scoreService.getAverageByScheduleId(cs.getScheduleId());
                if (scores.isEmpty()) continue;
                final StudentService fStudentService = studentService;
                Collections.sort(scores, new Comparator() {
                    public int compare(Object o1, Object o2) {
                        Score sc1 = (Score) o1;
                        Score sc2 = (Score) o2;
                        Student s1 = fStudentService.findById(sc1.getStudentId());
                        Student s2 = fStudentService.findById(sc2.getStudentId());
                        String no1 = s1 != null ? s1.getStudentNo() : "";
                        String no2 = s2 != null ? s2.getStudentNo() : "";
                        return no1.compareTo(no2);
                    }
                });
            %>
            <div class="card">
                <div class="card-title"><%=c != null ? c.getCourseName() : ""%> - <%=cs.getSemester()%> | 平均分: <%=avg != null ? String.format("%.1f", avg) : "N/A"%> | 录入人数: <%=scores.size()%></div>
                <table>
                    <thead><tr><th>学号</th><th>姓名</th><th>平时分</th><th>考试分</th><th>最终分</th><th>绩点</th></tr></thead>
                    <tbody>
                        <% for (int si = 0; si < scores.size(); si++) {
                            Score s = (Score) scores.get(si);
                            Student stu = studentService.findById(s.getStudentId()); %>
                        <tr>
                            <td><%=stu != null ? stu.getStudentNo() : s.getStudentId()%></td>
                            <td><%=stu != null ? stu.getName() : ""%></td>
                            <td><%=s.getRegularScore() != null ? s.getRegularScore() : "-"%></td>
                            <td><%=s.getExamScore() != null ? s.getExamScore() : "-"%></td>
                            <td><%=s.getFinalScore() != null ? String.format("%.1f", s.getFinalScore()) : "-"%></td>
                            <td><%=s.getGpa() != null ? String.format("%.1f", s.getGpa()) : "-"%></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>
    </div>
    <jsp:include page="../common/footer.jsp"/>