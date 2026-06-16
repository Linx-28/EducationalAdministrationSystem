package com.example.eduadmin.controller;

import com.example.eduadmin.model.entity.User;
import com.example.eduadmin.model.service.UserService;
import com.example.eduadmin.model.service.impl.UserServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/login")
public class LoginController extends BaseServlet {
    private UserService userService = new UserServiceImpl();

    protected void index(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        forward(req, resp, "/views/login.jsp");
    }

    protected void login(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String role = req.getParameter("role");

        User user = userService.login(username, password, role);
        if (user != null) {
            req.getSession().setAttribute("user", user);
            String realName = userService.getRealName(user.getUserId(), role);
            req.getSession().setAttribute("realName", realName);
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
                    redirect(req, resp, "/");
            }
        } else {
            req.setAttribute("error", "用户名或密码错误");
            forward(req, resp, "/views/login.jsp");
        }
    }

    protected void logout(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getSession().invalidate();
        redirect(req, resp, "/views/login.jsp");
    }
}