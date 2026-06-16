package com.example.eduadmin.model.service;

import com.example.eduadmin.model.entity.User;

public interface UserService {
    User login(String username, String password, String role);
    boolean changePassword(Integer userId, String oldPwd, String newPwd);
    boolean register(User user);
    String getRealName(Integer userId, String role);
}