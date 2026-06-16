<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.example.eduadmin.model.entity.*" %>
<%@ page import="com.example.eduadmin.model.service.*" %>
<%@ page import="com.example.eduadmin.model.service.impl.*" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Comparator" %>
<%@ page import="java.text.Collator" %>
<%@ page import="java.util.Locale" %>
<%
    String path = request.getContextPath();
    User user = (User) session.getAttribute("user");
    ScheduleService scheduleService = new ScheduleServiceImpl();
    CourseService courseService = new CourseServiceImpl();
    StudentService studentService = new StudentServiceImpl();
    EnrollmentService enrollService = new EnrollmentServiceImpl();
    ClassInfoService classInfoService = new ClassInfoServiceImpl();

    List allSchedules = scheduleService.findByTeacherId(user.getUserId());
    String selectedCourseId = request.getParameter("courseId");

    Map courseScheduleMap = new HashMap();
    for (int i = 0; i < allSchedules.size(); i++) {
        CourseSchedule cs = (CourseSchedule) allSchedules.get(i);
        Integer cid = cs.getCourseId();
        List list = (List) courseScheduleMap.get(cid);
        if (list == null) { list = new ArrayList(); courseScheduleMap.put(cid, list); }
        list.add(cs);
    }

    Map courseClassCountMap = new HashMap();
    java.util.Iterator ccmIt = courseScheduleMap.keySet().iterator();
    while (ccmIt.hasNext()) {
        Integer cid = (Integer) ccmIt.next();
        List csl = (List) courseScheduleMap.get(cid);
        java.util.Set classIds = new java.util.HashSet();
        for (int i = 0; i < csl.size(); i++) {
            CourseSchedule cs = (CourseSchedule) csl.get(i);
            List enrollments = enrollService.findByScheduleId(cs.getScheduleId());
            for (int j = 0; j < enrollments.size(); j++) {
                Enrollment e = (Enrollment) enrollments.get(j);
                if (!"approved".equals(e.getStatus())) continue;
                Student s = studentService.findById(e.getStudentId());
                if (s != null && s.getClassId() != null) classIds.add(s.getClassId());
            }
        }
        courseClassCountMap.put(cid, classIds.size());
    }

    List sortedCourseIds = new ArrayList(courseScheduleMap.keySet());
    final Map courseIdNameMap3 = new HashMap();
    java.util.Iterator tempIt = sortedCourseIds.iterator();
    while (tempIt.hasNext()) {
        Integer cid = (Integer) tempIt.next();
        Course c = courseService.findById(cid);
        courseIdNameMap3.put(cid, c != null ? c.getCourseName() : "");
    }
    final java.text.Collator collator = java.text.Collator.getInstance(java.util.Locale.CHINA);
    Collections.sort(sortedCourseIds, new Comparator() {
        public int compare(Object a, Object b) {
            String na = (String) courseIdNameMap3.get(a);
            String nb = (String) courseIdNameMap3.get(b);
            if (na == null) return 1;
            if (nb == null) return -1;
            return collator.compare(na, nb);
        }
    });
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>学生名单</title>
    <link rel="stylesheet" href="<%=path%>/static/css/common.css">
    <style>
        .class-group { margin-bottom: 24px; border: 1px solid #e8e8e8; border-radius: 8px; overflow: hidden; }
        .class-group-header { background: #fafafa; padding: 12px 16px; font-weight: bold; font-size: 14px; border-bottom: 1px solid #e8e8e8; display: flex; justify-content: space-between; align-items: center; }
        .class-group-header .student-count { font-weight: normal; color: #999; font-size: 13px; }
        .class-group table { width: 100%; }
        .class-group table th { background: #f5f5f5; }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp"/>
    <div class="admin-layout">
        <jsp:include page="../common/sidebar.jsp"/>
        <div class="main-content">
            <h2 style="margin-bottom:16px">学生名单</h2>
            <div class="card">
                <div class="form-group">
                    <label>选择课程</label>
                    <select onchange="if(this.value) location.href='?method=studentList&courseId='+this.value">
                        <option value="">-- 请选择课程 --</option>
                        <% for (int i = 0; i < sortedCourseIds.size(); i++) {
                               Integer cid = (Integer) sortedCourseIds.get(i);
                               Course c = courseService.findById(cid);
                               int classCount = courseClassCountMap.containsKey(cid) ? (Integer) courseClassCountMap.get(cid) : 0;
                        %>
                        <option value="<%=cid%>" <%=selectedCourseId != null && selectedCourseId.equals(String.valueOf(cid)) ? "selected" : ""%>>
                            <%=c != null ? c.getCourseName() : ""%> (<%=classCount%>个班)
                        </option>
                        <% } %>
                    </select>
                </div>
            </div>
            <% if (selectedCourseId != null && !selectedCourseId.isEmpty()) {
                int courseId = Integer.parseInt(selectedCourseId);
                Course course = courseService.findById(courseId);
                List courseSchedules = (List) courseScheduleMap.get(courseId);

                Map classStudentMap = new HashMap();
                if (courseSchedules != null) {
                    for (int i = 0; i < courseSchedules.size(); i++) {
                        CourseSchedule cs = (CourseSchedule) courseSchedules.get(i);
                        List enrollments = enrollService.findByScheduleId(cs.getScheduleId());
                        for (int j = 0; j < enrollments.size(); j++) {
                            Enrollment e = (Enrollment) enrollments.get(j);
                            if (!"approved".equals(e.getStatus())) continue;
                            Student s = studentService.findById(e.getStudentId());
                            if (s == null) continue;
                            int classId = s.getClassId() != null ? s.getClassId() : 0;
                            List classStudents = (List) classStudentMap.get(classId);
                            if (classStudents == null) { classStudents = new ArrayList(); classStudentMap.put(classId, classStudents); }
                            boolean found = false;
                            for (int k = 0; k < classStudents.size(); k++) {
                                Student existing = (Student) classStudents.get(k);
                                if (existing.getUserId().equals(s.getUserId())) { found = true; break; }
                            }
                            if (!found) classStudents.add(s);
                        }
                    }
                }

                int total = 0;
                java.util.Iterator countIt = classStudentMap.values().iterator();
                while (countIt.hasNext()) { total += ((List) countIt.next()).size(); }
            %>
            <div class="alert alert-success" style="margin-bottom:16px">
                <b>课程：</b><%=course != null ? course.getCourseName() : ""%>&nbsp;&nbsp;|&nbsp;&nbsp;
                <b>总人数：</b><%=total%>
            </div>
            <% java.util.Iterator classIt = classStudentMap.keySet().iterator();
               while (classIt.hasNext()) {
                   Integer classIdKey = (Integer) classIt.next();
                   List students = (List) classStudentMap.get(classIdKey);
                   ClassInfo ci = classIdKey.intValue() > 0 ? classInfoService.findById(classIdKey) : null;
            %>
            <div class="class-group">
                <div class="class-group-header">
                    <span><%=ci != null ? ci.getClassName() : "未分班"%></span>
                    <span class="student-count"><%=students.size()%> 人</span>
                </div>
                <table>
                    <thead><tr><th>学号</th><th>姓名</th><th>性别</th><th>专业</th><th>电话</th></tr></thead>
                    <tbody>
                        <% for (int i = 0; i < students.size(); i++) {
                            Student s = (Student) students.get(i);
                        %>
                        <tr>
                            <td><%=s.getStudentNo()%></td>
                            <td><%=s.getName()%></td>
                            <td><%=s.getGender()%></td>
                            <td><%=s.getMajor() != null ? s.getMajor() : ""%></td>
                            <td><%=s.getPhone() != null ? s.getPhone() : ""%></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
            <% if (classStudentMap.isEmpty()) { %>
            <div class="card" style="text-align:center;color:#999;padding:40px">暂无选课学生</div>
            <% } %>
            <% } %>
        </div>
    </div>
    <jsp:include page="../common/footer.jsp"/>