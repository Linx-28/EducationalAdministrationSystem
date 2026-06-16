package com.example.eduadmin.model.service.impl;

import com.example.eduadmin.model.dao.StudentDao;
import com.example.eduadmin.model.dao.TeacherDao;
import com.example.eduadmin.model.dao.UserDao;
import com.example.eduadmin.model.entity.Student;
import com.example.eduadmin.model.entity.Teacher;
import com.example.eduadmin.model.entity.User;
import com.example.eduadmin.model.service.UserService;

public class UserServiceImpl implements UserService {
    private UserDao userDao = new UserDao();
    private StudentDao studentDao = new StudentDao();
    private TeacherDao teacherDao = new TeacherDao();

    @Override
    public User login(String username, String password, String role) {
        User user = null;
        if ("student".equals(role)) {
            user = userDao.findByStudentNo(username);
        } else if ("teacher".equals(role)) {
            user = userDao.findByTeacherNo(username);
        } else {
            user = userDao.findByUsername(username);
        }
        if (user != null && user.getPassword().equals(password) && user.getRole().equals(role)) {
            return user;
        }
        return null;
    }

    @Override
    public boolean changePassword(Integer userId, String oldPwd, String newPwd) {
        User user = userDao.findById(userId);
        if (user != null && user.getPassword().equals(oldPwd)) {
            return userDao.updatePassword(userId, newPwd);
        }
        return false;
    }

    @Override
    public boolean register(User user) {
        if (userDao.findByUsername(user.getUsername()) != null) {
            return false;
        }
        return userDao.insert(user) > 0;
    }

    @Override
    public String getRealName(Integer userId, String role) {
        if ("student".equals(role)) {
            Student student = studentDao.findByUserId(userId);
            return student != null ? student.getName() : "";
        } else if ("teacher".equals(role)) {
            Teacher teacher = teacherDao.findByUserId(userId);
            return teacher != null ? teacher.getName() : "";
        }
        return "管理员";
    }
}