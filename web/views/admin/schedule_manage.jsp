<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Comparator" %>
<%@ page import="java.text.Collator" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.example.eduadmin.model.entity.*" %>
<%@ page import="com.example.eduadmin.model.service.*" %>
<%@ page import="com.example.eduadmin.model.service.impl.*" %>
<%!
    private static final String[][] PINYIN_BOUNDS = {
        {"A", "阿"}, {"B", "八"}, {"C", "嚓"}, {"D", "哒"}, {"E", "鹅"},
        {"F", "发"}, {"G", "嘎"}, {"H", "哈"}, {"J", "击"}, {"K", "咖"},
        {"L", "拉"}, {"M", "妈"}, {"N", "那"}, {"O", "哦"}, {"P", "趴"},
        {"Q", "七"}, {"R", "然"}, {"S", "撒"}, {"T", "他"}, {"W", "哇"},
        {"X", "西"}, {"Y", "压"}, {"Z", "扎"}
    };

    public static char getPinyinInitial(String name) {
        if (name == null || name.isEmpty()) return '#';
        char first = name.charAt(0);
        if (first >= 'A' && first <= 'Z') return first;
        if (first >= 'a' && first <= 'z') return Character.toUpperCase(first);
        if (first >= '0' && first <= '9') return '#';
        Collator collator = Collator.getInstance(Locale.CHINA);
        for (int i = PINYIN_BOUNDS.length - 1; i >= 0; i--) {
            if (collator.compare(String.valueOf(first), PINYIN_BOUNDS[i][1]) >= 0) {
                return PINYIN_BOUNDS[i][0].charAt(0);
            }
        }
        return '#';
    }

    public static String formatTimeSlot(String slot) {
        if (slot == null || !slot.contains("-")) return slot;
        String[] parts = slot.split("-");
        String[] dayNames = {"", "周一", "周二", "周三", "周四", "周五"};
        String[] periodNames = {"", "1-2节", "3-4节", "5-6节", "7-8节", "9-10节"};
        try {
            int day = Integer.parseInt(parts[0]);
            int period = Integer.parseInt(parts[1]);
            if (day >= 1 && day <= 5 && period >= 1 && period <= 5) {
                return dayNames[day] + periodNames[period];
            }
        } catch (NumberFormatException e) {}
        return slot;
    }
%>
<%
    String path = request.getContextPath();
    ScheduleService scheduleService = new ScheduleServiceImpl();
    CourseService courseService = new CourseServiceImpl();
    TeacherService teacherService = new TeacherServiceImpl();
    ClassroomService classroomService = new ClassroomServiceImpl();
    List schedules = scheduleService.findBySemester("2025-2026-1");
    List courses = courseService.findAll();
    List teachers = teacherService.findAll();
    List classrooms = classroomService.findAll();

    final java.text.Collator collator = java.text.Collator.getInstance(java.util.Locale.CHINA);
    Collections.sort(courses, new Comparator() {
        public int compare(Object o1, Object o2) {
            Course a = (Course) o1;
            Course b = (Course) o2;
            return collator.compare(a.getCourseName(), b.getCourseName());
        }
    });
    final Map courseNameMap = new HashMap();
    for (int i = 0; i < courses.size(); i++) {
        Course c = (Course) courses.get(i);
        courseNameMap.put(c.getCourseId(), c.getCourseName());
    }

    Collections.sort(schedules, new Comparator() {
        public int compare(Object o1, Object o2) {
            CourseSchedule a = (CourseSchedule) o1;
            CourseSchedule b = (CourseSchedule) o2;
            String na = (String) courseNameMap.get(a.getCourseId());
            String nb = (String) courseNameMap.get(b.getCourseId());
            if (na == null) na = "";
            if (nb == null) nb = "";
            int cmp = collator.compare(na, nb);
            if (cmp != 0) return cmp;
            String ta = a.getTimeSlot() != null ? a.getTimeSlot() : "";
            String tb = b.getTimeSlot() != null ? b.getTimeSlot() : "";
            return ta.compareTo(tb);
        }
    });

    String editId = request.getParameter("editId");
    CourseSchedule editSchedule = null;
    if (editId != null && !editId.isEmpty()) {
        editSchedule = scheduleService.findById(Integer.parseInt(editId));
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>排课管理</title>
    <link rel="stylesheet" href="<%=path%>/static/css/common.css">
    <link rel="stylesheet" href="<%=path%>/static/css/admin.css">
    <script src="<%=path%>/static/js/common.js"></script>
    <style>
        .time-grid { display: grid; grid-template-columns: repeat(5, 1fr); gap: 6px; margin-top: 8px; }
        .time-grid .day-header { background: #fafafa; font-weight: bold; font-size: 13px; padding: 6px; text-align: center; border-bottom: 2px solid #1890ff; }
        .time-grid .period-cell { cursor: pointer; padding: 6px 4px; border: 1px solid #d9d9d9; border-radius: 4px; text-align: center; font-size: 12px; transition: all .2s; min-height: 42px; display: flex; flex-direction: column; align-items: center; justify-content: center; }
        .time-grid .period-cell:hover:not(.disabled):not(.occupied) { border-color: #40a9ff; background: #e6f7ff; }
        .time-grid .period-cell.selected { background: #1890ff; color: #fff; border-color: #1890ff; }
        .time-grid .period-cell.occupied { background: #f0f0f0; color: #999; border-color: #d9d9d9; cursor: not-allowed; }
        .time-grid .period-cell.occupied .slot-course { font-weight: bold; color: #ff4d4f; font-size: 11px; line-height: 1.2; }
        .time-grid .period-cell.occupied .slot-label { font-size: 10px; color: #bbb; }
        .time-grid .period-cell.occupied-editing { background: #e6fffb; color: #13c2c2; border-color: #87e8de; cursor: not-allowed; }
        .time-grid .period-cell.occupied-editing .slot-course { font-weight: bold; color: #08979c; font-size: 11px; line-height: 1.2; }
        .time-grid .period-cell.occupied-editing .slot-label { font-size: 10px; color: #87e8de; }
        .time-desc { font-size: 12px; color: #666; margin-top: 4px; }
        .legend { display: flex; gap: 16px; margin-top: 8px; font-size: 12px; color: #666; flex-wrap: wrap; }
        .legend span { display: inline-flex; align-items: center; gap: 4px; }
        .legend .dot { width: 12px; height: 12px; border-radius: 2px; display: inline-block; }
        .search-bar { display: flex; gap: 12px; margin-bottom: 16px; align-items: center; }
        .search-bar input { padding: 8px 12px; border: 1px solid #d9d9d9; border-radius: 4px; font-size: 14px; width: 280px; outline: none; transition: border-color .3s; }
        .search-bar input:focus { border-color: #40a9ff; }
        .search-bar .search-hint { font-size: 12px; color: #999; }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp"/>
    <div class="admin-layout">
        <jsp:include page="../common/sidebar.jsp"/>
        <div class="main-content">
            <div class="page-header">
                <h2>排课管理</h2>
                <button class="btn btn-primary" onclick="showModal('addModal')">添加排课</button>
            </div>
            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error" style="margin-bottom:16px"><%=request.getAttribute("error")%></div>
            <% } %>
            <div class="card">
                <div class="search-bar">
                    <input type="text" id="searchInput" placeholder="输入课程、教师、教室等关键词搜索" oninput="searchSchedule()">
                    <span class="search-hint">共 <%=schedules.size()%> 条排课记录</span>
                </div>
                <table>
                    <thead><tr><th>课程</th><th>授课教师</th><th>学期</th><th>教室</th><th>上课时间</th><th>容量</th><th>已选</th><th>操作</th></tr></thead>
                    <tbody id="scheduleBody">
                        <% for (int i = 0; i < schedules.size(); i++) {
                            CourseSchedule cs = (CourseSchedule) schedules.get(i);
                            Course c = courseService.findById(cs.getCourseId());
                            Teacher t = teacherService.findById(cs.getTeacherId());
                            String cName = c != null ? c.getCourseName() : "";
                            char initial = getPinyinInitial(cName);
                            String formattedSlot = formatTimeSlot(cs.getTimeSlot());
                        %>
                        <tr data-search="<%=cName.toLowerCase()%> <%=t != null ? t.getName().toLowerCase() : ""%> <%=cs.getClassroom().toLowerCase()%> <%=cs.getSemester().toLowerCase()%> <%=formattedSlot.toLowerCase()%>">
                            <td><%=cName%></td>
                            <td><%=t != null ? t.getName() : ""%></td>
                            <td><%=cs.getSemester()%></td>
                            <td><%=cs.getClassroom()%></td>
                            <td><%=formattedSlot%></td>
                            <td><%=cs.getCapacity()%></td>
                            <td><%=cs.getEnrolledCount() != null ? cs.getEnrolledCount() : 0%></td>
                            <td>
                                <button class="btn btn-sm" onclick="location.href='<%=path%>/admin?method=scheduleManage&editId=<%=cs.getScheduleId()%>'">修改</button>
                                <button class="btn btn-danger btn-sm" onclick="if(confirm('确定删除？'))location.href='<%=path%>/admin?method=deleteSchedule&scheduleId=<%=cs.getScheduleId()%>'">删除</button>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <% String modalTitle = editSchedule != null ? "修改排课" : "添加排课"; %>
    <% String formAction = editSchedule != null ? path + "/admin?method=updateSchedule" : path + "/admin?method=addSchedule"; %>
    <%
        List editGroupSlots = null;
        Integer editCourseId = null, editTeacherId = null;
        String editSemester = null, editClassroom = null;
        Integer editCapacity = null;
        if (editSchedule != null) {
            editCourseId = editSchedule.getCourseId();
            editTeacherId = editSchedule.getTeacherId();
            editSemester = editSchedule.getSemester();
            editClassroom = editSchedule.getClassroom();
            editCapacity = editSchedule.getCapacity();
            editGroupSlots = scheduleService.findByGroup(editCourseId, editTeacherId, editSemester, editClassroom);
        }
    %>
    <div id="addModal" class="modal-overlay" style="display:<%=editSchedule != null ? "flex" : "none"%>" onclick="if(event.target===this)hideModal('addModal')">
        <div class="modal" style="width:620px">
            <div class="modal-title"><%=modalTitle%></div>
            <form action="<%=formAction%>" method="post" id="scheduleForm">
                <div class="form-group"><label>课程</label>
                    <select name="courseId" id="courseSelect" required onchange="updateTimeGrid()">
                        <option value="">-- 请选择 --</option>
                        <% for (int i = 0; i < courses.size(); i++) {
                            Course c = (Course) courses.get(i);
                        %>
                        <option value="<%=c.getCourseId()%>" <%=editCourseId != null && editCourseId.equals(c.getCourseId()) ? "selected" : ""%>><%=c.getCourseName()%> (<%=c.getCredit()%>学分)</option>
                        <% } %>
                    </select>
                </div>
                <div class="form-group"><label>授课教师</label>
                    <select name="teacherId" id="teacherSelect" required onchange="updateTimeGrid()">
                        <option value="">-- 请选择 --</option>
                        <% for (int i = 0; i < teachers.size(); i++) {
                            Teacher t = (Teacher) teachers.get(i);
                        %>
                        <option value="<%=t.getUserId()%>" <%=editTeacherId != null && editTeacherId.equals(t.getUserId()) ? "selected" : ""%>><%=t.getName()%> - <%=t.getTitle() != null ? t.getTitle() : ""%></option>
                        <% } %>
                    </select>
                </div>
                <div class="form-group"><label>学期</label>
                    <select name="semester" id="semesterSelect" required onchange="updateTimeGrid()">
                        <option value="2025-2026-1" <%=editSemester != null && "2025-2026-1".equals(editSemester) ? "selected" : ""%>>2025-2026 第一学期</option>
                        <option value="2025-2026-2" <%=editSemester != null && "2025-2026-2".equals(editSemester) ? "selected" : ""%>>2025-2026 第二学期</option>
                    </select>
                </div>
                <div class="form-group"><label>教室</label>
                    <select name="classroom" id="classroomSelect" required onchange="updateCapacity(); updateTimeGrid();">
                        <option value="">-- 请选择教室 --</option>
                        <% for (int i = 0; i < classrooms.size(); i++) {
                            Classroom cr = (Classroom) classrooms.get(i);
                        %>
                        <option value="<%=cr.getClassroomName()%>" data-capacity="<%=cr.getCapacity()%>" <%=editClassroom != null && cr.getClassroomName().equals(editClassroom) ? "selected" : ""%>>
                            <%=cr.getBuilding()%> <%=cr.getClassroomName()%> (容量<%=cr.getCapacity()%><%=cr.getHasMultimedia() ? ", 有多媒体" : ""%>)
                        </option>
                        <% } %>
                    </select>
                </div>
                <div class="form-group"><label>上课时间（点击选择，可多选）</label>
                    <div class="time-grid" id="timeGrid">
                        <div class="day-header">周一</div>
                        <div class="day-header">周二</div>
                        <div class="day-header">周三</div>
                        <div class="day-header">周四</div>
                        <div class="day-header">周五</div>
                        <div class="period-cell" data-slot="1-1" onclick="toggleTime('1-1', this)">1-2节</div>
                        <div class="period-cell" data-slot="2-1" onclick="toggleTime('2-1', this)">1-2节</div>
                        <div class="period-cell" data-slot="3-1" onclick="toggleTime('3-1', this)">1-2节</div>
                        <div class="period-cell" data-slot="4-1" onclick="toggleTime('4-1', this)">1-2节</div>
                        <div class="period-cell" data-slot="5-1" onclick="toggleTime('5-1', this)">1-2节</div>
                        <div class="period-cell" data-slot="1-2" onclick="toggleTime('1-2', this)">3-4节</div>
                        <div class="period-cell" data-slot="2-2" onclick="toggleTime('2-2', this)">3-4节</div>
                        <div class="period-cell" data-slot="3-2" onclick="toggleTime('3-2', this)">3-4节</div>
                        <div class="period-cell" data-slot="4-2" onclick="toggleTime('4-2', this)">3-4节</div>
                        <div class="period-cell" data-slot="5-2" onclick="toggleTime('5-2', this)">3-4节</div>
                        <div class="period-cell" data-slot="1-3" onclick="toggleTime('1-3', this)">5-6节</div>
                        <div class="period-cell" data-slot="2-3" onclick="toggleTime('2-3', this)">5-6节</div>
                        <div class="period-cell" data-slot="3-3" onclick="toggleTime('3-3', this)">5-6节</div>
                        <div class="period-cell" data-slot="4-3" onclick="toggleTime('4-3', this)">5-6节</div>
                        <div class="period-cell" data-slot="5-3" onclick="toggleTime('5-3', this)">5-6节</div>
                        <div class="period-cell" data-slot="1-4" onclick="toggleTime('1-4', this)">7-8节</div>
                        <div class="period-cell" data-slot="2-4" onclick="toggleTime('2-4', this)">7-8节</div>
                        <div class="period-cell" data-slot="3-4" onclick="toggleTime('3-4', this)">7-8节</div>
                        <div class="period-cell" data-slot="4-4" onclick="toggleTime('4-4', this)">7-8节</div>
                        <div class="period-cell" data-slot="5-4" onclick="toggleTime('5-4', this)">7-8节</div>
                        <div class="period-cell" data-slot="1-5" onclick="toggleTime('1-5', this)">9-10节</div>
                        <div class="period-cell" data-slot="2-5" onclick="toggleTime('2-5', this)">9-10节</div>
                        <div class="period-cell" data-slot="3-5" onclick="toggleTime('3-5', this)">9-10节</div>
                        <div class="period-cell" data-slot="4-5" onclick="toggleTime('4-5', this)">9-10节</div>
                        <div class="period-cell" data-slot="5-5" onclick="toggleTime('5-5', this)">9-10节</div>
                    </div>
                    <input type="hidden" name="timeSlots" id="timeSlotsInput" value="<% if (editGroupSlots != null) { for (int si = 0; si < editGroupSlots.size(); si++) { CourseSchedule ecs = (CourseSchedule) editGroupSlots.get(si); %><%=si > 0 ? "," : ""%><%=ecs.getTimeSlot()%><% } } %>">
                    <div class="time-desc" id="timeDesc"><% if (editGroupSlots != null && !editGroupSlots.isEmpty()) { for (int si = 0; si < editGroupSlots.size(); si++) { CourseSchedule ecs = (CourseSchedule) editGroupSlots.get(si); %><%=si > 0 ? " | " : ""%><%=formatTimeSlot(ecs.getTimeSlot())%><% } } else { %>请选择上课时间（可多选）<% } %></div>
                    <div class="legend">
                        <span><span class="dot" style="background:#f0f0f0;border:1px solid #d9d9d9"></span>已被其他课程占用</span>
                        <span><span class="dot" style="background:#e6fffb;border:1px solid #87e8de"></span>当前编辑课程（可重新选择）</span>
                        <span><span class="dot" style="background:#1890ff"></span>已选择</span>
                    </div>
                </div>
                <div class="form-group"><label>容量</label><input type="number" name="capacity" id="capacityInput" min="1" max="500" required value="<%=editCapacity != null ? editCapacity : ""%>"></div>
                <div class="modal-footer">
                    <button type="button" class="btn" onclick="hideModal('addModal');location.href='<%=path%>/admin?method=scheduleManage'">取消</button>
                    <button type="submit" class="btn btn-primary">确定</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        var allSchedules = [
            <% for (int i = 0; i < schedules.size(); i++) {
                CourseSchedule cs = (CourseSchedule) schedules.get(i);
                Course sc = courseService.findById(cs.getCourseId());
                String scName = sc != null ? sc.getCourseName() : "";
            %>
            {scheduleId:<%=cs.getScheduleId()%>, courseId:<%=cs.getCourseId()%>, courseName:'<%=scName.replace("'", "\\'")%>', teacherId:<%=cs.getTeacherId()%>, semester:'<%=cs.getSemester()%>', timeSlot:'<%=cs.getTimeSlot()%>'},
            <% } %>
        ];

        var editingScheduleIds = [];
        <% if (editGroupSlots != null && !editGroupSlots.isEmpty()) { %>
        <% for (int i = 0; i < editGroupSlots.size(); i++) {
            CourseSchedule ecs = (CourseSchedule) editGroupSlots.get(i);
        %>
        editingScheduleIds.push(<%=ecs.getScheduleId()%>);
        <% } %>
        <% } %>

        var dayMap = {'1':'周一','2':'周二','3':'周三','4':'周四','5':'周五'};
        var periodMap = {'1':'1-2节','2':'3-4节','3':'5-6节','4':'7-8节','5':'9-10节'};

        function toggleTime(slot, el) {
            if (el.classList.contains('occupied') && !el.classList.contains('occupied-editing')) return;
            var input = document.getElementById('timeSlotsInput');
            var slots = input.value ? input.value.split(',') : [];
            var idx = slots.indexOf(slot);
            if (idx >= 0) {
                slots.splice(idx, 1);
                el.classList.remove('selected');
            } else {
                slots.push(slot);
                el.classList.add('selected');
            }
            input.value = slots.join(',');
            updateTimeDesc();
        }

        function updateTimeDesc() {
            var slots = document.getElementById('timeSlotsInput').value;
            var desc = document.getElementById('timeDesc');
            if (!slots) { desc.textContent = '请选择上课时间（可多选）'; return; }
            var parts = slots.split(',');
            var texts = [];
            for (var i = 0; i < parts.length; i++) {
                var p = parts[i].split('-');
                texts.push(dayMap[p[0]] + periodMap[p[1]]);
            }
            desc.textContent = texts.join(' | ');
        }

        function updateCapacity() {
            var sel = document.getElementById('classroomSelect');
            var opt = sel.options[sel.selectedIndex];
            if (opt && opt.dataset.capacity) {
                document.getElementById('capacityInput').value = opt.dataset.capacity;
            }
        }

        function updateTimeGrid() {
            var semester = document.getElementById('semesterSelect').value;
            var input = document.getElementById('timeSlotsInput');
            var selectedSlots = input.value ? input.value.split(',') : [];
            var cells = document.querySelectorAll('.period-cell');

            cells.forEach(function(cell) {
                cell.classList.remove('occupied', 'occupied-editing', 'selected');
                cell.innerHTML = '';
                cell.title = '';
                var slot = cell.dataset.slot;
                var dayPeriod = slot.split('-');
                cell.innerHTML = periodMap[dayPeriod[1]];
            });

            var slotMap = {};
            allSchedules.forEach(function(s) {
                if (s.semester !== semester) return;
                if (editingScheduleIds.indexOf(s.scheduleId) >= 0) return;
                slotMap[s.timeSlot] = s;
            });

            cells.forEach(function(cell) {
                var slot = cell.dataset.slot;
                var schedule = slotMap[slot];
                if (schedule) {
                    cell.classList.add('occupied');
                    cell.innerHTML = '<span class="slot-course">' + schedule.courseName + '</span><span class="slot-label">' + periodMap[slot.split('-')[1]] + '</span>';
                    cell.title = '已安排：' + schedule.courseName;
                    var idx = selectedSlots.indexOf(slot);
                    if (idx >= 0) {
                        selectedSlots.splice(idx, 1);
                        cell.classList.remove('selected');
                    }
                }
            });

            <% if (editGroupSlots != null && !editGroupSlots.isEmpty()) { %>
            var editingSlots = {};
            allSchedules.forEach(function(s) {
                if (editingScheduleIds.indexOf(s.scheduleId) >= 0) {
                    editingSlots[s.timeSlot] = s;
                }
            });
            cells.forEach(function(cell) {
                var slot = cell.dataset.slot;
                if (editingSlots[slot]) {
                    cell.classList.add('occupied-editing');
                    cell.classList.remove('occupied');
                    cell.innerHTML = '<span class="slot-course">' + editingSlots[slot].courseName + '</span><span class="slot-label">当前课程（可重选）</span>';
                    cell.title = '当前课程：' + editingSlots[slot].courseName + '（可重新选择）';
                }
            });
            <% } %>

            if (input.value !== selectedSlots.join(',')) {
                input.value = selectedSlots.join(',');
                updateTimeDesc();
            }
        }

        function searchSchedule() {
            var keyword = document.getElementById('searchInput').value.trim().toLowerCase();
            var rows = document.querySelectorAll('#scheduleBody tr');
            rows.forEach(function(row) {
                if (!keyword || row.dataset.search.indexOf(keyword) >= 0) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }

        document.getElementById('scheduleForm').addEventListener('submit', function(e) {
            var slots = document.getElementById('timeSlotsInput').value;
            if (!slots) {
                e.preventDefault();
                alert('请至少选择一个上课时间');
                return;
            }
        });

        window.onload = function() {
            <% if (editGroupSlots != null && !editGroupSlots.isEmpty()) { %>
            var slots = document.getElementById('timeSlotsInput').value.split(',');
            slots.forEach(function(slot) {
                if (!slot) return;
                var cell = document.querySelector('[data-slot="' + slot + '"]');
                if (cell) cell.classList.add('selected');
            });
            <% } %>
            updateTimeGrid();
        };
    </script>
    <jsp:include page="../common/footer.jsp"/>