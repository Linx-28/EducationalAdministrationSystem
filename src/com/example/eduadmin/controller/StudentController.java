package com.example.eduadmin.controller;

import com.example.eduadmin.model.entity.User;
import com.example.eduadmin.model.service.StudentService;
import com.example.eduadmin.model.service.impl.StudentServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/student")
public class StudentController extends BaseServlet {
    private StudentService studentService = new StudentServiceImpl();
    
    protected void home(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        forward(req, resp, "/views/student/home.jsp");
    }
    
    protected void enroll(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        forward(req, resp, "/views/student/enroll.jsp");
    }
    
    protected void mySchedule(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        forward(req, resp, "/views/student/my_schedule.jsp");
    }
    
    protected void myScores(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        forward(req, resp, "/views/student/my_scores.jsp");
    }
    
    protected void profile(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        forward(req, resp, "/views/student/profile.jsp");
    }
}