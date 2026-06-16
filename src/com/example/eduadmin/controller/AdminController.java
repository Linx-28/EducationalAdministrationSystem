package com.example.eduadmin.controller;

import com.example.eduadmin.model.entity.*;
import com.example.eduadmin.model.service.*;
import com.example.eduadmin.model.service.impl.*;
import com.example.eduadmin.util.WebUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;
import java.util.List;

@WebServlet("/admin")
public class AdminController extends BaseServlet {
    private StudentService studentService = new StudentServiceImpl();
    private TeacherService teacherService = new TeacherServiceImpl();
    private CourseService courseService = new CourseServiceImpl();
    private ScheduleService scheduleService = new ScheduleServiceImpl();
    private EnrollmentService enrollService = new EnrollmentServiceImpl();
    private ClassroomService classroomService = new ClassroomServiceImpl();
    private SemesterService semesterService = new SemesterServiceImpl();
    private UserService userService = new UserServiceImpl();

    // ========== 页面跳转 ==========

    protected void dashboard(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        forward(req, resp, "/views/admin/dashboard.jsp");
    }

    protected void studentManage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        forward(req, resp, "/views/admin/student_manage.jsp");
    }

    protected void teacherManage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);
        forward(req, resp, "/views/admin/teacher_manage.jsp");
    }

    protected void courseManage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        forward(req, resp, "/views/admin/course_manage.jsp");
    }

    protected void scheduleManage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        forward(req, resp, "/views/admin/schedule_manage.jsp");
    }

    protected void enrollmentApprove(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        forward(req, resp, "/views/admin/enrollment_approve.jsp");
    }

    protected void scoreManage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        forward(req, resp, "/views/admin/score_manage.jsp");
    }

    protected void classroomManage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        forward(req, resp, "/views/admin/classroom_manage.jsp");
    }

    protected void semesterManage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        forward(req, resp, "/views/admin/semester_manage.jsp");
    }

    // ========== 学生管理 ==========

    protected void addStudent(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String studentNo = req.getParameter("studentNo");
        String name = req.getParameter("name");
        String gender = req.getParameter("gender");
        String classIdStr = req.getParameter("classId");
        String major = req.getParameter("major");
        String enrollYear = req.getParameter("enrollYear");
        String phone = req.getParameter("phone");
        String email = req.getParameter("email");

        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setRole("student");
        int userId = userService.register(user) ? getUserIdByUsername(username) : -1;

        if (userId > 0) {
            Student student = new Student();
            student.setUserId(userId);
            student.setStudentNo(studentNo);
            student.setName(name);
            student.setGender(gender);
            if (classIdStr != null && !classIdStr.isEmpty()) {
                student.setClassId(Integer.parseInt(classIdStr));
            }
            student.setMajor(major);
            student.setEnrollYear(enrollYear != null && !enrollYear.isEmpty() ? Integer.parseInt(enrollYear) : null);
            student.setPhone(phone);
            student.setEmail(email);
            studentService.add(student);
        }
        resp.sendRedirect(req.getContextPath() + "/admin?method=studentManage");
    }

    protected void deleteStudent(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String userId = req.getParameter("userId");
        if (userId != null) {
            new com.example.eduadmin.model.dao.UserDao().delete(Integer.parseInt(userId));
        }
        resp.sendRedirect(req.getContextPath() + "/admin?method=studentManage");
    }

    // ========== 教师管理 ==========

    protected void addTeacher(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String password = req.getParameter("password");
        String teacherNo = req.getParameter("teacherNo");
        String name = req.getParameter("name");
        String gender = req.getParameter("gender");
        String title = req.getParameter("title");
        String department = req.getParameter("department");

        User user = new User();
        user.setUsername(teacherNo);
        user.setPassword(password);
        user.setRole("teacher");
        boolean registered = userService.register(user);
        int userId = registered ? getUserIdByUsername(teacherNo) : -1;

        if (userId <= 0) {
            resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            resp.setHeader("Pragma", "no-cache");
            resp.setDateHeader("Expires", 0);
            req.setAttribute("error", "添加失败：工号 " + teacherNo + " 已存在");
            forward(req, resp, "/views/admin/teacher_manage.jsp");
            return;
        }

        Teacher teacher = new Teacher();
        teacher.setUserId(userId);
        teacher.setTeacherNo(teacherNo);
        teacher.setName(name);
        teacher.setGender(gender);
        teacher.setTitle(title);
        teacher.setDepartment(department);
        teacherService.add(teacher);

        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);
        req.setAttribute("success", "教师 " + name + "（" + teacherNo + "）添加成功");
        forward(req, resp, "/views/admin/teacher_manage.jsp");
    }

    protected void deleteTeacher(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String userId = req.getParameter("userId");
        if (userId != null) {
            new com.example.eduadmin.model.dao.UserDao().delete(Integer.parseInt(userId));
        }
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);
        resp.sendRedirect(req.getContextPath() + "/admin?method=teacherManage");
    }

    // ========== 课程管理 ==========

    protected void addCourse(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Course course = new Course();
        course.setCourseName(req.getParameter("courseName"));
        course.setCredit(Double.parseDouble(req.getParameter("credit")));
        course.setHours(Integer.parseInt(req.getParameter("hours")));
        course.setType(req.getParameter("type"));
        course.setDescription(req.getParameter("description"));
        courseService.add(course);
        resp.sendRedirect(req.getContextPath() + "/admin?method=courseManage");
    }

    protected void deleteCourse(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String courseId = req.getParameter("courseId");
        if (courseId != null) {
            courseService.delete(Integer.parseInt(courseId));
        }
        resp.sendRedirect(req.getContextPath() + "/admin?method=courseManage");
    }

    // ========== 排课管理 ==========

    protected void addSchedule(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int courseId = Integer.parseInt(req.getParameter("courseId"));
        int teacherId = Integer.parseInt(req.getParameter("teacherId"));
        String semester = req.getParameter("semester");
        String classroom = req.getParameter("classroom");
        int capacity = Integer.parseInt(req.getParameter("capacity"));
        String timeSlotsStr = req.getParameter("timeSlots");
        if (timeSlotsStr == null || timeSlotsStr.isEmpty()) {
            req.setAttribute("error", "请至少选择一个上课时间");
            forward(req, resp, "/views/admin/schedule_manage.jsp");
            return;
        }
        String[] timeSlots = timeSlotsStr.split(",");
        for (String slot : timeSlots) {
            CourseSchedule testSchedule = new CourseSchedule();
            testSchedule.setCourseId(courseId);
            testSchedule.setTeacherId(teacherId);
            testSchedule.setSemester(semester);
            testSchedule.setClassroom(classroom);
            testSchedule.setTimeSlot(slot);
            String conflictMsg = scheduleService.getConflictMessage(testSchedule);
            if (conflictMsg != null) {
                req.setAttribute("error", conflictMsg);
                forward(req, resp, "/views/admin/schedule_manage.jsp");
                return;
            }
        }
        boolean result = scheduleService.addMulti(courseId, teacherId, semester, classroom, capacity, timeSlots);
        if (!result) {
            req.setAttribute("error", "排课失败：存在时间冲突");
            forward(req, resp, "/views/admin/schedule_manage.jsp");
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/admin?method=scheduleManage");
    }

    protected void deleteSchedule(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String scheduleId = req.getParameter("scheduleId");
        if (scheduleId != null) {
            scheduleService.delete(Integer.parseInt(scheduleId));
        }
        resp.sendRedirect(req.getContextPath() + "/admin?method=scheduleManage");
    }

    protected void updateSchedule(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int courseId = Integer.parseInt(req.getParameter("courseId"));
        int teacherId = Integer.parseInt(req.getParameter("teacherId"));
        String semester = req.getParameter("semester");
        String classroom = req.getParameter("classroom");
        int capacity = Integer.parseInt(req.getParameter("capacity"));
        String timeSlotsStr = req.getParameter("timeSlots");
        if (timeSlotsStr == null || timeSlotsStr.isEmpty()) {
            req.setAttribute("error", "请至少选择一个上课时间");
            forward(req, resp, "/views/admin/schedule_manage.jsp");
            return;
        }
        String[] timeSlots = timeSlotsStr.split(",");
        List<CourseSchedule> oldSlots = scheduleService.findByGroup(courseId, teacherId, semester, classroom);
        Integer excludeId = oldSlots.isEmpty() ? null : oldSlots.get(0).getScheduleId();
        for (String slot : timeSlots) {
            CourseSchedule testSchedule = new CourseSchedule();
            testSchedule.setCourseId(courseId);
            testSchedule.setTeacherId(teacherId);
            testSchedule.setSemester(semester);
            testSchedule.setClassroom(classroom);
            testSchedule.setTimeSlot(slot);
            testSchedule.setScheduleId(excludeId);
            String conflictMsg = scheduleService.getConflictMessage(testSchedule);
            if (conflictMsg != null) {
                req.setAttribute("error", conflictMsg);
                forward(req, resp, "/views/admin/schedule_manage.jsp");
                return;
            }
        }
        boolean result = scheduleService.updateMulti(courseId, teacherId, semester, classroom, capacity, timeSlots, null);
        if (!result) {
            req.setAttribute("error", "修改失败：存在时间冲突");
            forward(req, resp, "/views/admin/schedule_manage.jsp");
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/admin?method=scheduleManage");
    }

    // ========== 选课审核 ==========

    protected void approveEnrollment(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String enrollmentId = req.getParameter("enrollmentId");
        if (enrollmentId != null) {
            enrollService.approve(Integer.parseInt(enrollmentId));
        }
        resp.sendRedirect(req.getContextPath() + "/admin?method=enrollmentApprove");
    }

    protected void rejectEnrollment(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String enrollmentId = req.getParameter("enrollmentId");
        if (enrollmentId != null) {
            enrollService.reject(Integer.parseInt(enrollmentId));
        }
        resp.sendRedirect(req.getContextPath() + "/admin?method=enrollmentApprove");
    }

    // ========== 教室管理 ==========

    protected void addClassroom(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Classroom classroom = new Classroom();
        classroom.setClassroomName(req.getParameter("classroomName"));
        classroom.setBuilding(req.getParameter("building"));
        classroom.setCapacity(Integer.parseInt(req.getParameter("capacity")));
        classroom.setHasMultimedia(Boolean.parseBoolean(req.getParameter("hasMultimedia")));
        classroomService.add(classroom);
        resp.sendRedirect(req.getContextPath() + "/admin?method=classroomManage");
    }

    protected void deleteClassroom(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String classroomId = req.getParameter("classroomId");
        if (classroomId != null) {
            classroomService.delete(Integer.parseInt(classroomId));
        }
        resp.sendRedirect(req.getContextPath() + "/admin?method=classroomManage");
    }

    // ========== 学期管理 ==========

    protected void addSemester(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Semester semester = new Semester();
        semester.setSemesterName(req.getParameter("semesterName"));
        semester.setStartDate(java.sql.Date.valueOf(req.getParameter("startDate")));
        semester.setEndDate(java.sql.Date.valueOf(req.getParameter("endDate")));
        semesterService.add(semester);
        resp.sendRedirect(req.getContextPath() + "/admin?method=semesterManage");
    }

    protected void deleteSemester(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String semesterId = req.getParameter("semesterId");
        if (semesterId != null) {
            semesterService.delete(Integer.parseInt(semesterId));
        }
        resp.sendRedirect(req.getContextPath() + "/admin?method=semesterManage");
    }

    // ========== 工具方法 ==========

    private int getUserIdByUsername(String username) {
        User user = new com.example.eduadmin.model.dao.UserDao().findByUsername(username);
        return user != null ? user.getUserId() : -1;
    }
}