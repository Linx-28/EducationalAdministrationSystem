<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Comparator" %>
<%@ page import="com.example.eduadmin.model.entity.*" %>
<%@ page import="com.example.eduadmin.model.service.*" %>
<%@ page import="com.example.eduadmin.model.service.impl.*" %>
<%
    String path = request.getContextPath();
    TeacherService teacherService = new TeacherServiceImpl();
    List teachers = teacherService.findAll();
    Collections.sort(teachers, new Comparator() {
        public int compare(Object o1, Object o2) {
            Teacher a = (Teacher) o1;
            Teacher b = (Teacher) o2;
            return a.getTeacherNo().compareTo(b.getTeacherNo());
        }
    });
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>教师管理</title>
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
                <h2>教师管理</h2>
                <button class="btn btn-primary" onclick="showModal('addModal')">添加教师</button>
            </div>
            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error" style="margin-bottom:16px"><%=request.getAttribute("error")%></div>
            <% } %>
            <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success" style="margin-bottom:16px"><%=request.getAttribute("success")%></div>
            <% } %>
            <div class="card">
                <table>
                    <thead><tr><th>工号</th><th>姓名</th><th>性别</th><th>职称</th><th>院系</th><th>操作</th></tr></thead>
                    <tbody>
                        <% for (int i = 0; i < teachers.size(); i++) {
                               Teacher t = (Teacher) teachers.get(i);
                        %>
                        <tr>
                            <td><%=t.getTeacherNo()%></td>
                            <td><%=t.getName()%></td>
                            <td><%=t.getGender()%></td>
                            <td><%=t.getTitle() != null ? t.getTitle() : ""%></td>
                            <td><%=t.getDepartment() != null ? t.getDepartment() : ""%></td>
                            <td>
                                <button class="btn btn-danger btn-sm" onclick="if(confirm('确定删除？'))location.href='<%=path%>/admin?method=deleteTeacher&userId=<%=t.getUserId()%>'">删除</button>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <div style="margin-top:8px;color:#999;font-size:13px">共 <%=teachers.size()%> 条记录</div>
            </div>
        </div>
    </div>
    <div id="addModal" class="modal-overlay" style="display:none" onclick="if(event.target===this)hideModal('addModal')">
        <div class="modal">
            <div class="modal-title">添加教师</div>
            <form action="<%=path%>/admin?method=addTeacher" method="post" onsubmit="return validateTeacherForm()">
                <div class="form-group"><label>工号</label><input type="text" name="teacherNo" id="teacherNo" required></div>
                <div class="form-group"><label>姓名</label><input type="text" name="name" id="teacherName" required></div>
                <div class="form-group"><label>密码</label><input type="password" name="password" id="teacherPwd" required autocomplete="new-password"></div>
                <div class="form-group"><label>性别</label><select name="gender" id="teacherGender" required><option value="">-- 请选择 --</option><option value="男">男</option><option value="女">女</option></select></div>
                <div class="form-group"><label>职称</label><input type="text" name="title" id="teacherTitle" required></div>
                <div class="form-group"><label>院系</label><input type="text" name="department" id="teacherDept" required></div>
                <div class="modal-footer">
                    <button type="button" class="btn" onclick="hideModal('addModal')">取消</button>
                    <button type="submit" class="btn btn-primary">确定</button>
                </div>
            </form>
        </div>
    </div>
    <script>
        function validateTeacherForm() {
            var teacherNo = document.getElementById('teacherNo').value.trim();
            var name = document.getElementById('teacherName').value.trim();
            var pwd = document.getElementById('teacherPwd').value.trim();
            var gender = document.getElementById('teacherGender').value;
            var title = document.getElementById('teacherTitle').value.trim();
            var dept = document.getElementById('teacherDept').value.trim();
            if (!teacherNo) { alert('请输入工号'); return false; }
            if (!name) { alert('请输入姓名'); return false; }
            if (!pwd) { alert('请输入密码'); return false; }
            if (!gender) { alert('请选择性别'); return false; }
            if (!title) { alert('请输入职称'); return false; }
            if (!dept) { alert('请输入院系'); return false; }
            return true;
        }
    </script>
    <jsp:include page="../common/footer.jsp"/>