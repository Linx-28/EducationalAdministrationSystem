<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.eduadmin.model.entity.*" %>
<%@ page import="com.example.eduadmin.model.service.*" %>
<%@ page import="com.example.eduadmin.model.service.impl.*" %>
<%
    String path = request.getContextPath();
    SemesterService semesterService = new SemesterServiceImpl();
    List semesters = semesterService.findAll();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>学期设置</title>
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
                <h2>学期设置</h2>
                <button class="btn btn-primary" onclick="showModal('addModal')">添加学期</button>
            </div>
            <div class="card">
                <table>
                    <thead><tr><th>学期名称</th><th>开始日期</th><th>结束日期</th><th>操作</th></tr></thead>
                    <tbody>
                        <% for (int i = 0; i < semesters.size(); i++) {
                               Semester s = (Semester) semesters.get(i);
                        %>
                        <tr>
                            <td><%=s.getSemesterName()%></td>
                            <td><%=s.getStartDate()%></td>
                            <td><%=s.getEndDate()%></td>
                            <td>
                                <button class="btn btn-danger btn-sm" onclick="if(confirm('确定删除？'))location.href='<%=path%>/admin?method=deleteSemester&semesterId=<%=s.getSemesterId()%>'">删除</button>
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
            <div class="modal-title">添加学期</div>
            <form action="<%=path%>/admin?method=addSemester" method="post">
                <div class="form-group"><label>学期名称</label><input type="text" name="semesterName" placeholder="如: 2025-2026-1" required></div>
                <div class="form-group"><label>开始日期</label><input type="date" name="startDate" required></div>
                <div class="form-group"><label>结束日期</label><input type="date" name="endDate" required></div>
                <div class="modal-footer">
                    <button type="button" class="btn" onclick="hideModal('addModal')">取消</button>
                    <button type="submit" class="btn btn-primary">确定</button>
                </div>
            </form>
        </div>
    </div>
    <jsp:include page="../common/footer.jsp"/>