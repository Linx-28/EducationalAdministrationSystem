package com.example.eduadmin.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/teacher")
public class TeacherController extends BaseServlet {
    
    protected void home(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        forward(req, resp, "/views/teacher/home.jsp");
    }
    
    protected void scoreInput(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        forward(req, resp, "/views/teacher/score_input.jsp");
    }
    
    protected void viewScores(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        forward(req, resp, "/views/teacher/view_scores.jsp");
    }
    
    protected void mySchedule(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        forward(req, resp, "/views/teacher/my_schedule.jsp");
    }
    
    protected void studentList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        forward(req, resp, "/views/teacher/student_list.jsp");
    }
}