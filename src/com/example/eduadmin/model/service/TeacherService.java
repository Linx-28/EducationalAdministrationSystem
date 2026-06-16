package com.example.eduadmin.model.service;

import com.example.eduadmin.model.entity.Teacher;
import java.util.List;

public interface TeacherService {
    Teacher findById(Integer userId);
    List<Teacher> findAll();
    boolean add(Teacher teacher);
    boolean update(Teacher teacher);
    boolean delete(Integer userId);
}