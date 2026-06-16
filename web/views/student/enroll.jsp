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
    TeacherService teacherService = new TeacherServiceImpl();
    EnrollmentService enrollService = new EnrollmentServiceImpl();
    List schedules = scheduleService.findBySemester("2025-2026-1");
    List myEnrolls = enrollService.findByStudentId(user.getUserId());

    Map timeSlotCourseMap = new HashMap();
    Set myCourseIds = new HashSet();
    for (int i = 0; i < myEnrolls.size(); i++) {
        Enrollment e = (Enrollment) myEnrolls.get(i);
        if ("approved".equals(e.getStatus())) {
            CourseSchedule cs = scheduleService.findById(e.getScheduleId());
            if (cs != null) {
                Course c = courseService.findById(cs.getCourseId());
                timeSlotCourseMap.put(cs.getTimeSlot(), c != null ? c.getCourseName() : "未知课程");
                myCourseIds.add(cs.getCourseId());
            }
        }
    }

    Map courseScheduleMap = new HashMap();
    for (int i = 0; i < schedules.size(); i++) {
        CourseSchedule cs = (CourseSchedule) schedules.get(i);
        Integer cid = cs.getCourseId();
        List list = (List) courseScheduleMap.get(cid);
        if (list == null) { list = new ArrayList(); courseScheduleMap.put(cid, list); }
        list.add(cs);
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>选课</title>
    <link rel="stylesheet" href="<%=path%>/static/css/common.css">
    <link rel="stylesheet" href="<%=path%>/static/css/student.css">
    <script src="<%=path%>/static/js/common.js"></script>
    <script src="<%=path%>/static/js/enrollment.js"></script>
    <style>
        .conflict-tag { display: inline-block; padding: 1px 6px; border-radius: 3px; font-size: 11px; margin-left: 4px; }
        .conflict-tag.time-conflict { background: #fff2f0; color: #ff4d4f; border: 1px solid #ffccc7; }
        tr.conflict-row { background: #fffbe6; }
        .time-slots { display: flex; flex-wrap: wrap; gap: 4px; }
        .time-slot-tag { display: inline-block; padding: 2px 8px; border-radius: 3px; font-size: 12px; background: #e6f7ff; color: #1890ff; border: 1px solid #91d5ff; }
        .time-slot-tag.conflict { background: #fff2f0; color: #ff4d4f; border-color: #ffccc7; }
        .time-slot-tag.enrolled { background: #f6ffed; color: #52c41a; border-color: #b7eb8f; }
        .conflict-detail { font-size: 11px; color: #ff4d4f; margin-top: 2px; }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp"/>
    <div class="admin-layout">
        <jsp:include page="../common/sidebar.jsp"/>
        <div class="main-content">
            <h2 style="margin-bottom:16px">在线选课</h2>
            <div class="alert alert-success" style="margin-bottom:16px">
                <b>选课规则：</b>选课即选中该课程所有时间段&nbsp;&nbsp;|&nbsp;&nbsp;不可与已选课程时间冲突&nbsp;&nbsp;|&nbsp;&nbsp;课程满员后不可选
            </div>
            <div class="card">
                <div class="card-title">可选课程</div>
                <table>
                    <thead>
                        <tr><th>课程名称</th><th>授课教师</th><th>上课时间及教室</th><th>容量</th><th>已选</th><th>操作</th></tr>
                    </thead>
                    <tbody>
                        <% java.util.Iterator courseIt = courseScheduleMap.keySet().iterator();
                           while (courseIt.hasNext()) {
                               Integer cid = (Integer) courseIt.next();
                               List csl = (List) courseScheduleMap.get(cid);
                               Course c = courseService.findById(cid);
                               boolean allEnrolled = myCourseIds.contains(cid);
                               boolean hasConflict = false;
                               boolean hasFull = false;
                               List conflictCourses = new ArrayList();
                               for (int i = 0; i < csl.size(); i++) {
                                   CourseSchedule cs = (CourseSchedule) csl.get(i);
                                   if (!allEnrolled && timeSlotCourseMap.containsKey(cs.getTimeSlot())) {
                                       hasConflict = true;
                                       String conflictName = (String) timeSlotCourseMap.get(cs.getTimeSlot());
                                       if (!conflictCourses.contains(conflictName)) conflictCourses.add(conflictName);
                                   }
                                   if (cs.getEnrolledCount() != null && cs.getEnrolledCount() >= cs.getCapacity()) hasFull = true;
                               }
                               Teacher t = teacherService.findById(((CourseSchedule) csl.get(0)).getTeacherId());
                               int capacity = ((CourseSchedule) csl.get(0)).getCapacity();
                               int totalEnrolled = enrollService.countUniqueStudentsByCourseId(cid);
                        %>
                        <tr class="<%=hasConflict && !allEnrolled ? "conflict-row" : ""%>">
                            <td><%=c != null ? c.getCourseName() : ""%></td>
                            <td><%=t != null ? t.getName() : ""%></td>
                            <td>
                                <div class="time-slots">
                                <% for (int i = 0; i < csl.size(); i++) {
                                    CourseSchedule cs = (CourseSchedule) csl.get(i);
                                    boolean slotConflict = !allEnrolled && timeSlotCourseMap.containsKey(cs.getTimeSlot());
                                    boolean slotEnrolled = allEnrolled;
                                %>
                                    <span class="time-slot-tag <%=slotConflict ? "conflict" : slotEnrolled ? "enrolled" : ""%>" title="<%=slotConflict ? "与《" + timeSlotCourseMap.get(cs.getTimeSlot()) + "》冲突" : ""%>"><%=cs.getTimeSlot()%> <%=cs.getClassroom()%></span>
                                <% } %>
                                </div>
                                <% if (hasConflict && !allEnrolled) { %>
                                <div class="conflict-detail">与已选课程冲突：<%=conflictCourses.toString().replace("[", "《").replace("]", "》").replace(", ", "》《")%></div>
                                <% } %>
                            </td>
                            <td><%=capacity%></td>
                            <td><%=totalEnrolled%></td>
                            <td>
                                <% if (allEnrolled) { %>
                                    <span style="color:#52c41a">已选</span>
                                <% } else if (hasConflict) { %>
                                    <span style="color:#ff4d4f">冲突</span>
                                <% } else if (hasFull) { %>
                                    <span style="color:#ff4d4f">已满</span>
                                <% } else { %>
                                    <button class="btn btn-primary btn-sm" onclick="enrollCourse(<%=cid%>)">选课</button>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <div class="card">
                <div class="card-title">已选课程</div>
                <table>
                    <thead>
                        <tr><th>课程名称</th><th>授课教师</th><th>上课时间及教室</th><th>操作</th></tr>
                    </thead>
                    <tbody>
                        <% Map enrolledCourseMap = new HashMap();
                           for (int i = 0; i < myEnrolls.size(); i++) {
                               Enrollment e = (Enrollment) myEnrolls.get(i);
                               CourseSchedule cs = scheduleService.findById(e.getScheduleId());
                               if (cs != null) {
                                   Integer cid = cs.getCourseId();
                                   List eList = (List) enrolledCourseMap.get(cid);
                                   if (eList == null) { eList = new ArrayList(); enrolledCourseMap.put(cid, eList); }
                                   eList.add(cs);
                               }
                           }
                           java.util.Iterator enrolledIt = enrolledCourseMap.keySet().iterator();
                           while (enrolledIt.hasNext()) {
                               Integer cid = (Integer) enrolledIt.next();
                               List eList = (List) enrolledCourseMap.get(cid);
                               Course c = courseService.findById(cid);
                               Teacher t = teacherService.findById(((CourseSchedule) eList.get(0)).getTeacherId());
                        %>
                        <tr>
                            <td><%=c != null ? c.getCourseName() : ""%></td>
                            <td><%=t != null ? t.getName() : ""%></td>
                            <td>
                                <div class="time-slots">
                                <% for (int i = 0; i < eList.size(); i++) {
                                    CourseSchedule cs = (CourseSchedule) eList.get(i);
                                %>
                                    <span class="time-slot-tag enrolled"><%=cs.getTimeSlot()%> <%=cs.getClassroom()%></span>
                                <% } %>
                                </div>
                            </td>
                            <td>
                                <button class="btn btn-danger btn-sm" onclick="cancelEnrollCourse(<%=cid%>)">退选</button>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <script>
        function enrollCourse(courseId) {
            if (!confirm('确定选修该课程？选课后将包含该课程所有时间段。')) return;
            var basePath = document.querySelector('meta[name="basePath"]');
            var ctx = basePath ? basePath.content : '';
            post(ctx + '/enrollment?method=enrollCourse&courseId=' + courseId, null, function(res) {
                if (res && res.success) {
                    showMessage('选课成功');
                    setTimeout(function() { location.reload(); }, 1000);
                } else {
                    showMessage((res && res.message) || '选课失败', 'error');
                }
            }, function(err) {
                showMessage('网络错误', 'error');
            });
        }
    </script>
    <jsp:include page="../common/footer.jsp"/>