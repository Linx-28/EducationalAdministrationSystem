package com.example.eduadmin.controller;

import com.example.eduadmin.model.entity.CourseSchedule;
import com.example.eduadmin.model.entity.User;
import com.example.eduadmin.model.service.EnrollmentService;
import com.example.eduadmin.model.service.ScheduleService;
import com.example.eduadmin.model.service.impl.EnrollmentServiceImpl;
import com.example.eduadmin.model.service.impl.ScheduleServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/enrollment")
public class EnrollmentController extends BaseServlet {
    private EnrollmentService enrollmentService = new EnrollmentServiceImpl();
    private ScheduleService scheduleService = new ScheduleServiceImpl();

    protected void enroll(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.getWriter().print("{\"success\":false,\"message\":\"请先登录\"}");
            return;
        }
        String scheduleIdStr = req.getParameter("scheduleId");
        if (scheduleIdStr == null || scheduleIdStr.isEmpty()) {
            resp.getWriter().print("{\"success\":false,\"message\":\"参数错误\"}");
            return;
        }
        int scheduleId = Integer.parseInt(scheduleIdStr);
        String errorMsg = enrollmentService.getEnrollErrorMessage(user.getUserId(), scheduleId);
        if (errorMsg != null) {
            Map json = new HashMap();
            json.put("success", false);
            json.put("message", errorMsg);
            com.example.eduadmin.util.WebUtils.writeJson(resp, json);
            return;
        }
        boolean result = enrollmentService.enroll(user.getUserId(), scheduleId);
        Map json = new HashMap();
        json.put("success", result);
        json.put("message", result ? "选课成功" : "选课失败");
        com.example.eduadmin.util.WebUtils.writeJson(resp, json);
    }

    protected void enrollCourse(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.getWriter().print("{\"success\":false,\"message\":\"请先登录\"}");
            return;
        }
        String courseIdStr = req.getParameter("courseId");
        if (courseIdStr == null || courseIdStr.isEmpty()) {
            resp.getWriter().print("{\"success\":false,\"message\":\"参数错误\"}");
            return;
        }
        int courseId = Integer.parseInt(courseIdStr);
        List schedules = scheduleService.findBySemester("2025-2026-1");

        java.util.List targetSchedules = new java.util.ArrayList();
        for (int i = 0; i < schedules.size(); i++) {
            CourseSchedule cs = (CourseSchedule) schedules.get(i);
            if (cs.getCourseId().intValue() == courseId) {
                targetSchedules.add(cs);
            }
        }

        for (int i = 0; i < targetSchedules.size(); i++) {
            CourseSchedule cs = (CourseSchedule) targetSchedules.get(i);
            String errorMsg = enrollmentService.getEnrollErrorMessage(user.getUserId(), cs.getScheduleId());
            if (errorMsg != null) {
                Map json = new HashMap();
                json.put("success", false);
                json.put("message", errorMsg);
                com.example.eduadmin.util.WebUtils.writeJson(resp, json);
                return;
            }
        }

        int successCount = 0;
        for (int i = 0; i < targetSchedules.size(); i++) {
            CourseSchedule cs = (CourseSchedule) targetSchedules.get(i);
            if (enrollmentService.enroll(user.getUserId(), cs.getScheduleId())) {
                successCount++;
            }
        }

        Map json = new HashMap();
        if (successCount > 0) {
            json.put("success", true);
            json.put("message", "选课成功，共选中 " + successCount + " 个时间段");
        } else {
            json.put("success", false);
            json.put("message", "选课失败");
        }
        com.example.eduadmin.util.WebUtils.writeJson(resp, json);
    }

    protected void cancelEnroll(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.getWriter().print("{\"success\":false,\"message\":\"请先登录\"}");
            return;
        }
        String scheduleIdStr = req.getParameter("scheduleId");
        if (scheduleIdStr == null || scheduleIdStr.isEmpty()) {
            resp.getWriter().print("{\"success\":false,\"message\":\"参数错误\"}");
            return;
        }
        int scheduleId = Integer.parseInt(scheduleIdStr);
        boolean result = enrollmentService.cancelEnrollment(user.getUserId(), scheduleId);
        Map json = new HashMap();
        json.put("success", result);
        json.put("message", result ? "退选成功" : "退选失败");
        com.example.eduadmin.util.WebUtils.writeJson(resp, json);
    }

    protected void cancelEnrollCourse(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.getWriter().print("{\"success\":false,\"message\":\"请先登录\"}");
            return;
        }
        String courseIdStr = req.getParameter("courseId");
        if (courseIdStr == null || courseIdStr.isEmpty()) {
            resp.getWriter().print("{\"success\":false,\"message\":\"参数错误\"}");
            return;
        }
        int courseId = Integer.parseInt(courseIdStr);
        List schedules = scheduleService.findBySemester("2025-2026-1");
        int count = 0;
        for (int i = 0; i < schedules.size(); i++) {
            CourseSchedule cs = (CourseSchedule) schedules.get(i);
            if (cs.getCourseId().intValue() == courseId) {
                if (enrollmentService.cancelEnrollment(user.getUserId(), cs.getScheduleId())) {
                    count++;
                }
            }
        }
        Map json = new HashMap();
        json.put("success", count > 0);
        json.put("message", count > 0 ? "退选成功" : "退选失败");
        com.example.eduadmin.util.WebUtils.writeJson(resp, json);
    }
}