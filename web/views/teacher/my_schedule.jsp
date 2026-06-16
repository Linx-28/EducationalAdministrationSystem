<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="com.example.eduadmin.model.entity.*" %>
<%@ page import="com.example.eduadmin.model.service.*" %>
<%@ page import="com.example.eduadmin.model.service.impl.*" %>
<%
    String path = request.getContextPath();
    User user = (User) session.getAttribute("user");
    ScheduleService scheduleService = new ScheduleServiceImpl();
    CourseService courseService = new CourseServiceImpl();
    StudentService studentService = new StudentServiceImpl();
    EnrollmentService enrollService = new EnrollmentServiceImpl();
    ClassInfoService classInfoService = new ClassInfoServiceImpl();
    List schedules = scheduleService.findByTeacherId(user.getUserId());

    String[] dayNames = {"周一", "周二", "周三", "周四", "周五"};
    String[] periodTimes = {"08:00-09:40", "10:00-11:40", "14:00-15:40", "16:00-17:40", "19:00-20:40"};
    String[] periodNames = {"1-2节", "3-4节", "5-6节", "7-8节", "9-10节"};

    String[][] scheduleGrid = new String[5][5];
    String[][] courseClassroom = new String[5][5];
    String[][] courseClasses = new String[5][5];
    for (int i = 0; i < schedules.size(); i++) {
        CourseSchedule cs = (CourseSchedule) schedules.get(i);
        String slot = cs.getTimeSlot();
        if (slot != null && slot.indexOf("-") >= 0) {
            String[] parts = slot.split("-");
            int day = Integer.parseInt(parts[0]) - 1;
            int period = Integer.parseInt(parts[1]) - 1;
            if (day >= 0 && day < 5 && period >= 0 && period < 5) {
                Course c = courseService.findById(cs.getCourseId());
                scheduleGrid[day][period] = c != null ? c.getCourseName() : "";
                courseClassroom[day][period] = cs.getClassroom() != null ? cs.getClassroom() : "";

                List enrollments = enrollService.findByScheduleId(cs.getScheduleId());
                Set classNames = new HashSet();
                for (int j = 0; j < enrollments.size(); j++) {
                    Enrollment e = (Enrollment) enrollments.get(j);
                    if (!"approved".equals(e.getStatus())) continue;
                    Student s = studentService.findById(e.getStudentId());
                    if (s != null && s.getClassId() != null) {
                        ClassInfo ci = classInfoService.findById(s.getClassId());
                        if (ci != null) classNames.add(ci.getClassName());
                    }
                }
                if (!classNames.isEmpty()) {
                    courseClasses[day][period] = classNames.toString().replace("[", "").replace("]", "");
                }
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>我的课表</title>
    <link rel="stylesheet" href="<%=path%>/static/css/common.css">
    <style>
        .schedule-wrapper { overflow-x: auto; }
        .schedule-table { width: 100%; border-collapse: collapse; table-layout: fixed; min-width: 700px; }
        .schedule-table th { background: #1890ff; color: #fff; font-size: 14px; padding: 14px 8px; text-align: center; border: 1px solid #096dd9; height: 40px; }
        .schedule-table td { border: 1px solid #e8e8e8; text-align: center; vertical-align: middle; height: 100px; padding: 4px; }
        .schedule-table tr:nth-child(even) td { background: #fafafa; }
        .schedule-table td:hover { background: #e6f7ff; }
        .time-col { background: #f0f5ff !important; font-weight: bold; width: 110px; min-width: 110px; }
        .time-col .period-name { font-size: 15px; font-weight: bold; color: #2f54eb; }
        .time-col .period-time { font-size: 11px; color: #8c8c8c; margin-top: 6px; }
        .course-cell { background: linear-gradient(135deg, #e6f7ff 0%, #bae7ff 100%); border-radius: 6px; padding: 8px 4px; height: 100%; display: flex; flex-direction: column; justify-content: center; align-items: center; box-shadow: 0 1px 2px rgba(0,0,0,0.06); transition: all .2s; }
        .course-cell:hover { box-shadow: 0 2px 8px rgba(24,144,255,0.3); transform: translateY(-1px); }
        .course-cell .course-name { font-weight: bold; color: #1890ff; font-size: 13px; margin-bottom: 4px; line-height: 1.3; }
        .course-cell .course-classroom { font-size: 12px; color: #595959; margin-bottom: 2px; }
        .course-cell .course-classes { font-size: 11px; color: #fa541c; font-weight: 500; }
        .card { padding: 16px; overflow: hidden; }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp"/>
    <div class="admin-layout">
        <jsp:include page="../common/sidebar.jsp"/>
        <div class="main-content">
            <h2 style="margin-bottom:16px">我的课表</h2>
            <div class="card">
                <div class="schedule-wrapper">
                <table class="schedule-table">
                    <colgroup>
                        <col style="width:110px">
                        <col style="width:18%">
                        <col style="width:18%">
                        <col style="width:18%">
                        <col style="width:18%">
                        <col style="width:18%">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>时间</th>
                            <% for (int i = 0; i < 5; i++) { %>
                            <th><%=dayNames[i]%></th>
                            <% } %>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (int p = 0; p < 5; p++) { %>
                        <tr>
                            <td class="time-col">
                                <div class="period-name"><%=periodNames[p]%></div>
                                <div class="period-time"><%=periodTimes[p]%></div>
                            </td>
                            <% for (int d = 0; d < 5; d++) { %>
                            <td>
                                <% if (scheduleGrid[d][p] != null && !scheduleGrid[d][p].isEmpty()) { %>
                                <div class="course-cell">
                                    <div class="course-name"><%=scheduleGrid[d][p]%></div>
                                    <div class="course-classroom"><%=courseClassroom[d][p]%></div>
                                    <% if (courseClasses[d][p] != null) { %>
                                    <div class="course-classes"><%=courseClasses[d][p]%></div>
                                    <% } %>
                                </div>
                                <% } %>
                            </td>
                            <% } %>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="../common/footer.jsp"/>