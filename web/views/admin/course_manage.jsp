<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Comparator" %>
<%@ page import="java.text.Collator" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.example.eduadmin.model.entity.*" %>
<%@ page import="com.example.eduadmin.model.service.*" %>
<%@ page import="com.example.eduadmin.model.service.impl.*" %>
<%
    String path = request.getContextPath();
    CourseService courseService = new CourseServiceImpl();
    List courses = courseService.findAll();
    final java.text.Collator collator = java.text.Collator.getInstance(java.util.Locale.CHINA);
    final Map courseNameMap = new HashMap();
    for (int i = 0; i < courses.size(); i++) {
        Course c = (Course) courses.get(i);
        courseNameMap.put(c.getCourseId(), c.getCourseName());
    }
    Collections.sort(courses, new Comparator() {
        public int compare(Object o1, Object o2) {
            Course a = (Course) o1;
            Course b = (Course) o2;
            String na = (String) courseNameMap.get(a.getCourseId());
            String nb = (String) courseNameMap.get(b.getCourseId());
            return collator.compare(na != null ? na : "", nb != null ? nb : "");
        }
    });
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>课程管理</title>
    <link rel="stylesheet" href="<%=path%>/static/css/common.css">
    <link rel="stylesheet" href="<%=path%>/static/css/admin.css">
    <script src="<%=path%>/static/js/common.js"></script>
</head>
<body>
    <jsp:include page="../common/header.jsp"/>
    <div class="admin-layout">
        <jsp:include page="../common/sidebar.jsp"/>
        <div class="main-content">
            <div class="page-header">
                <h2>课程管理</h2>
                <button class="btn btn-primary" onclick="showModal('addModal')">添加课程</button>
            </div>
            <div class="card">
                <table>
                    <thead><tr><th>课程名称</th><th>学分</th><th>学时</th><th>类型</th><th>描述</th><th>操作</th></tr></thead>
                    <tbody>
                        <% for (int i = 0; i < courses.size(); i++) {
                               Course c = (Course) courses.get(i);
                        %>
                        <tr>
                            <td><%=c.getCourseName()%></td>
                            <td><%=c.getCredit()%></td>
                            <td><%=c.getHours()%></td>
                            <td><%=c.getType()%></td>
                            <td><%=c.getDescription() != null ? c.getDescription() : ""%></td>
                            <td>
                                <button class="btn btn-danger btn-sm" onclick="if(confirm('确定删除？'))location.href='<%=path%>/admin?method=deleteCourse&courseId=<%=c.getCourseId()%>'">删除</button>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div id="addModal" class="modal-overlay" style="display:none" onclick="if(event.target===this)hideModal('addModal')">
        <div class="modal">
            <div class="modal-title">添加课程</div>
            <form action="<%=path%>/admin?method=addCourse" method="post">
                <div class="form-group"><label>课程名称</label><input type="text" name="courseName" required></div>
                <div class="form-group"><label>学分</label><input type="number" name="credit" step="0.5" required></div>
                <div class="form-group"><label>学时</label><input type="number" name="hours" required></div>
                <div class="form-group"><label>类型</label><select name="type"><option value="必修">必修</option><option value="选修">选修</option></select></div>
                <div class="form-group"><label>描述</label><textarea name="description" rows="3"></textarea></div>
                <div class="modal-footer">
                    <button type="button" class="btn" onclick="hideModal('addModal')">取消</button>
                    <button type="submit" class="btn btn-primary">确定</button>
                </div>
            </form>
        </div>
    </div>
    <jsp:include page="../common/footer.jsp"/>