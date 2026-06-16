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
    ScoreService scoreService = new ScoreServiceImpl();
    ClassInfoService classInfoService = new ClassInfoServiceImpl();

    List allSchedules = scheduleService.findByTeacherId(user.getUserId());
    String selectedCourseId = request.getParameter("courseId");
    String selectedClassId = request.getParameter("classId");

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
    final Map courseIdNameMap = new HashMap();
    java.util.Iterator tempIt = sortedCourseIds.iterator();
    while (tempIt.hasNext()) {
        Integer cid = (Integer) tempIt.next();
        Course c = courseService.findById(cid);
        courseIdNameMap.put(cid, c != null ? c.getCourseName() : "");
    }
    final java.text.Collator collator = java.text.Collator.getInstance(java.util.Locale.CHINA);
    Collections.sort(sortedCourseIds, new Comparator() {
        public int compare(Object a, Object b) {
            String na = (String) courseIdNameMap.get(a);
            String nb = (String) courseIdNameMap.get(b);
            if (na == null) return 1;
            if (nb == null) return -1;
            return collator.compare(na, nb);
        }
    });

    Map classStudentMap = new HashMap();
    Map classIdNameMap = new HashMap();
    if (selectedCourseId != null && !selectedCourseId.isEmpty()) {
        int courseId = Integer.parseInt(selectedCourseId);
        List courseSchedules = (List) courseScheduleMap.get(courseId);
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
                    if (!classIdNameMap.containsKey(classId) && classId > 0) {
                        ClassInfo ci = classInfoService.findById(classId);
                        if (ci != null) classIdNameMap.put(classId, ci.getClassName());
                    }
                }
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>成绩录入</title>
    <link rel="stylesheet" href="<%=path%>/static/css/common.css">
    <script src="<%=path%>/static/js/common.js"></script>
    <style>
        .class-group { margin-bottom: 24px; border: 1px solid #e8e8e8; border-radius: 8px; overflow: hidden; }
        .class-group-header { background: #fafafa; padding: 12px 16px; font-weight: bold; font-size: 14px; border-bottom: 1px solid #e8e8e8; display: flex; justify-content: space-between; align-items: center; }
        .class-group-header .student-count { font-weight: normal; color: #999; font-size: 13px; }
        .class-group table { width: 100%; }
        .class-group table th { background: #f5f5f5; }
        .filter-bar { display: flex; gap: 12px; align-items: flex-end; flex-wrap: wrap; }
        .filter-bar .form-group { margin-bottom: 0; min-width: 200px; }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp"/>
    <div class="admin-layout">
        <jsp:include page="../common/sidebar.jsp"/>
        <div class="main-content">
            <h2 style="margin-bottom:16px">成绩录入</h2>
            <div class="card">
                <div class="filter-bar">
                    <div class="form-group">
                        <label>选择课程</label>
                        <select id="courseSelect" onchange="location.href='?method=scoreInput&courseId='+this.value">
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
                    <% if (selectedCourseId != null && !selectedCourseId.isEmpty() && !classIdNameMap.isEmpty()) { %>
                    <div class="form-group">
                        <label>选择班级</label>
                        <select onchange="location.href='?method=scoreInput&courseId=<%=selectedCourseId%>&classId='+this.value">
                            <option value="">-- 全部班级 --</option>
                            <% java.util.Iterator classIt = classIdNameMap.keySet().iterator();
                               while (classIt.hasNext()) {
                                   Integer classIdKey = (Integer) classIt.next();
                                   String className = (String) classIdNameMap.get(classIdKey);
                            %>
                            <option value="<%=classIdKey%>" <%=selectedClassId != null && selectedClassId.equals(String.valueOf(classIdKey)) ? "selected" : ""%>>
                                <%=className%> (<%=((List) classStudentMap.get(classIdKey)).size()%>人)
                            </option>
                            <% } %>
                        </select>
                    </div>
                    <% } %>
                </div>
            </div>
            <% if (selectedCourseId != null && !selectedCourseId.isEmpty()) {
                int courseId = Integer.parseInt(selectedCourseId);
                Course course = courseService.findById(courseId);
            %>
            <div class="alert alert-success" style="margin-bottom:16px">
                <b>课程：</b><%=course != null ? course.getCourseName() : ""%>&nbsp;&nbsp;|&nbsp;&nbsp;
                <b>学分：</b><%=course != null ? course.getCredit() : ""%>
            </div>
            <%
                java.util.Iterator displayIt = classStudentMap.keySet().iterator();
                boolean hasDisplay = false;
                while (displayIt.hasNext()) {
                    Integer classIdKey = (Integer) displayIt.next();
                    if (selectedClassId != null && !selectedClassId.isEmpty() && !classIdKey.equals(Integer.parseInt(selectedClassId))) continue;
                    hasDisplay = true;
                    List students = (List) classStudentMap.get(classIdKey);
                    ClassInfo ci = classIdKey.intValue() > 0 ? classInfoService.findById(classIdKey) : null;
            %>
            <div class="class-group">
                <div class="class-group-header">
                    <span><%=ci != null ? ci.getClassName() : "未分班"%></span>
                    <span class="student-count"><%=students.size()%> 名学生</span>
                </div>
                <table>
                    <thead>
                        <tr><th>学号</th><th>姓名</th><th>平时分</th><th>考试分</th></tr>
                    </thead>
                    <tbody>
                        <% for (int i = 0; i < students.size(); i++) {
                            Student s = (Student) students.get(i);
                            Score existingScore = null;
                            List csList = (List) courseScheduleMap.get(courseId);
                            if (csList != null) {
                                for (int si = 0; si < csList.size(); si++) {
                                    CourseSchedule css = (CourseSchedule) csList.get(si);
                                    Score sc = scoreService.findByStudentAndSchedule(s.getUserId(), css.getScheduleId());
                                    if (sc != null) { existingScore = sc; break; }
                                }
                            }
                        %>
                        <tr class="score-row" data-student-id="<%=s.getUserId()%>">
                            <td><%=s.getStudentNo()%></td>
                            <td><%=s.getName()%></td>
                            <td><input type="number" class="regular-score" value="<%=existingScore != null && existingScore.getRegularScore() != null ? existingScore.getRegularScore() : ""%>" min="0" max="100" style="width:80px"></td>
                            <td><input type="number" class="exam-score" value="<%=existingScore != null && existingScore.getExamScore() != null ? existingScore.getExamScore() : ""%>" min="0" max="100" style="width:80px"></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
            <% if (!hasDisplay) { %>
            <div class="card" style="text-align:center;color:#999;padding:40px">暂无选课学生</div>
            <% } else { %>
            <div style="text-align:right;margin-top:16px">
                <button class="btn btn-primary" onclick="saveCourseScores(<%=selectedCourseId%>)">保存所有成绩</button>
            </div>
            <% } %>
            <% } %>
        </div>
    </div>
    <script>
        function saveCourseScores(courseId) {
            var rows = document.querySelectorAll('.score-row');
            var scores = [];
            rows.forEach(function(row) {
                var studentId = row.dataset.studentId;
                var regular = row.querySelector('.regular-score').value;
                var exam = row.querySelector('.exam-score').value;
                if (studentId && (regular || exam)) {
                    scores.push({studentId: studentId, scheduleId: courseId, regularScore: regular, examScore: exam});
                }
            });
            if (scores.length === 0) {
                showMessage('请输入成绩', 'error');
                return;
            }
            var basePath = document.querySelector('meta[name="basePath"]');
            var ctx = basePath ? basePath.content : '';
            post(ctx + '/score?method=batchSave', {scores: JSON.stringify(scores), scheduleId: courseId}, function(res) {
                if (res && res.success) {
                    showMessage(res.message || '成绩保存成功');
                } else {
                    showMessage((res && res.message) || '保存失败', 'error');
                }
            }, function(err) {
                showMessage('网络错误', 'error');
            });
        }
    </script>
    <jsp:include page="../common/footer.jsp"/>