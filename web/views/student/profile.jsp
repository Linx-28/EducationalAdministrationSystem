<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    com.example.eduadmin.model.entity.User user = (com.example.eduadmin.model.entity.User) session.getAttribute("user");
    com.example.eduadmin.model.service.StudentService studentService = new com.example.eduadmin.model.service.impl.StudentServiceImpl();
    com.example.eduadmin.model.entity.Student student = studentService.findById(user.getUserId());
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>个人信息</title>
    <link rel="stylesheet" href="<%=path%>/static/css/common.css">
    <script src="<%=path%>/static/js/common.js"></script>
</head>
<body>
    <jsp:include page="../common/header.jsp"/>
    <div class="admin-layout">
        <jsp:include page="../common/sidebar.jsp"/>
        <div class="main-content">
            <h2 style="margin-bottom:16px">个人信息</h2>
            <div class="card" style="max-width:600px">
                <% if (student != null) { %>
                <form id="profileForm" action="<%=path%>/student?method=updateProfile" method="post">
                    <div class="form-group"><label>学号</label><input type="text" value="<%=student.getStudentNo()%>" readonly></div>
                    <div class="form-group"><label>姓名</label><input type="text" name="name" value="<%=student.getName()%>"></div>
                    <div class="form-group"><label>性别</label>
                        <select name="gender"><option value="男" <%=student.getGender() != null && student.getGender().equals("男") ? "selected" : ""%>>男</option><option value="女" <%=student.getGender() != null && student.getGender().equals("女") ? "selected" : ""%>>女</option></select>
                    </div>
                    <div class="form-group"><label>专业</label><input type="text" name="major" value="<%=student.getMajor() != null ? student.getMajor() : ""%>"></div>
                    <div class="form-group"><label>入学年份</label><input type="number" name="enrollYear" value="<%=student.getEnrollYear() != null ? student.getEnrollYear() : ""%>"></div>
                    <div class="form-group"><label>电话</label><input type="text" name="phone" value="<%=student.getPhone() != null ? student.getPhone() : ""%>"></div>
                    <div class="form-group"><label>邮箱</label><input type="text" name="email" value="<%=student.getEmail() != null ? student.getEmail() : ""%>"></div>
                    <button type="submit" class="btn btn-primary">保存修改</button>
                </form>
                <% } else { %>
                <p>暂无学生信息</p>
                <% } %>
            </div>
        </div>
    </div>
    <jsp:include page="../common/footer.jsp"/>