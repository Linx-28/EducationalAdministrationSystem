package com.example.eduadmin.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/home")
public class HomeController extends BaseServlet {
    
    protected void index(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Object user = req.getSession().getAttribute("user");
        if (user == null) {
            forward(req, resp, "/views/login.jsp");
        } else {
            String role = ((com.example.eduadmin.model.entity.User) user).getRole();
            switch (role) {
                case "student":
                    redirect(req, resp, "/student?method=home");
                    break;
                case "teacher":
                    redirect(req, resp, "/teacher?method=home");
                    break;
                case "admin":
                    redirect(req, resp, "/admin?method=dashboard");
                    break;
                default:
                    forward(req, resp, "/views/index.jsp");
            }
        }
    }
}