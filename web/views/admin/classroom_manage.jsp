<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.eduadmin.model.entity.*" %>
<%@ page import="com.example.eduadmin.model.service.*" %>
<%@ page import="com.example.eduadmin.model.service.impl.*" %>
<%
    String path = request.getContextPath();
    ClassroomService classroomService = new ClassroomServiceImpl();
    List classrooms = classroomService.findAll();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>教室管理</title>
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
                <h2>教室管理</h2>
                <button class="btn btn-primary" onclick="showModal('addModal')">添加教室</button>
            </div>
            <div class="card">
                <table>
                    <thead><tr><th>教室名</th><th>教学楼</th><th>容量</th><th>多媒体</th><th>操作</th></tr></thead>
                    <tbody>
                        <% for (int i = 0; i < classrooms.size(); i++) {
                               Classroom cr = (Classroom) classrooms.get(i);
                        %>
                        <tr>
                            <td><%=cr.getClassroomName()%></td>
                            <td><%=cr.getBuilding()%></td>
                            <td><%=cr.getCapacity()%></td>
                            <td><%=cr.getHasMultimedia() ? "有" : "无"%></td>
                            <td>
                                <button class="btn btn-danger btn-sm" onclick="if(confirm('确定删除？'))location.href='<%=path%>/admin?method=deleteClassroom&classroomId=<%=cr.getClassroomId()%>'">删除</button>
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
            <div class="modal-title">添加教室</div>
            <form action="<%=path%>/admin?method=addClassroom" method="post">
                <div class="form-group"><label>教室名</label><input type="text" name="classroomName" required></div>
                <div class="form-group"><label>教学楼</label><input type="text" name="building" required></div>
                <div class="form-group"><label>容量</label><input type="number" name="capacity" required></div>
                <div class="form-group"><label>多媒体</label><select name="hasMultimedia"><option value="true">有</option><option value="false">无</option></select></div>
                <div class="modal-footer">
                    <button type="button" class="btn" onclick="hideModal('addModal')">取消</button>
                    <button type="submit" class="btn btn-primary">确定</button>
                </div>
            </form>
        </div>
    </div>
    <jsp:include page="../common/footer.jsp"/>