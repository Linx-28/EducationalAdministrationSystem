<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.eduadmin.model.entity.*" %>
<%@ page import="com.example.eduadmin.model.service.*" %>
<%@ page import="com.example.eduadmin.model.service.impl.*" %>
<%
    String path = request.getContextPath();
    StudentService studentService = new StudentServiceImpl();
    ClassInfoService classInfoService = new ClassInfoServiceImpl();
    List students = studentService.findAll(1, 100);
    List classList = classInfoService.findAll();
    int totalStudents = studentService.count();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>学生管理</title>
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
                <h2>学生管理</h2>
                <button class="btn btn-primary" onclick="showModal('addModal')">添加学生</button>
            </div>
            <div class="card">
                <table>
                    <thead><tr><th>学号</th><th>姓名</th><th>性别</th><th>班级</th><th>专业</th><th>入学年份</th><th>电话</th><th>操作</th></tr></thead>
                    <tbody>
                        <% for (int i = 0; i < students.size(); i++) {
                            Student s = (Student) students.get(i);
                            ClassInfo ci = s.getClassId() != null ? classInfoService.findById(s.getClassId()) : null;
                        %>
                        <tr>
                            <td><%=s.getStudentNo()%></td>
                            <td><%=s.getName()%></td>
                            <td><%=s.getGender()%></td>
                            <td><%=ci != null ? ci.getClassName() : "未分班"%></td>
                            <td><%=s.getMajor() != null ? s.getMajor() : ""%></td>
                            <td><%=s.getEnrollYear() != null ? s.getEnrollYear() : ""%></td>
                            <td><%=s.getPhone() != null ? s.getPhone() : ""%></td>
                            <td>
                                <button class="btn btn-danger btn-sm" onclick="if(confirm('确定删除？'))location.href='<%=path%>/admin?method=deleteStudent&userId=<%=s.getUserId()%>'">删除</button>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <div style="margin-top:8px;color:#999;font-size:13px">共 <%=totalStudents%> 条记录</div>
            </div>
        </div>
    </div>
    <div id="addModal" class="modal-overlay" style="display:none" onclick="if(event.target===this)hideModal('addModal')">
        <div class="modal">
            <div class="modal-title">添加学生</div>
            <form action="<%=path%>/admin?method=addStudent" method="post">
                <div class="form-group"><label>学号</label><input type="text" name="studentNo" required></div>
                <div class="form-group"><label>姓名</label><input type="text" name="name" required></div>
                <div class="form-group"><label>用户名</label><input type="text" name="username" required></div>
                <div class="form-group"><label>密码</label><input type="password" name="password" required></div>
                <div class="form-group"><label>性别</label><select name="gender"><option value="男">男</option><option value="女">女</option></select></div>
                <div class="form-group"><label>班级</label>
                    <select name="classId"><option value="">-- 请选择班级 --</option>
                    <% for (int i = 0; i < classList.size(); i++) {
                           ClassInfo ci = (ClassInfo) classList.get(i);
                    %>
                    <option value="<%=ci.getClassId()%>"><%=ci.getClassName()%> (<%=ci.getMajor()%>)</option>
                    <% } %>
                    </select>
                </div>
                <div class="form-group"><label>专业</label><input type="text" name="major"></div>
                <div class="form-group"><label>入学年份</label><input type="number" name="enrollYear"></div>
                <div class="form-group"><label>电话</label><input type="text" name="phone"></div>
                <div class="form-group"><label>邮箱</label><input type="text" name="email"></div>
                <div class="modal-footer">
                    <button type="button" class="btn" onclick="hideModal('addModal')">取消</button>
                    <button type="submit" class="btn btn-primary">确定</button>
                </div>
            </form>
        </div>
    </div>
    <jsp:include page="../common/footer.jsp"/>