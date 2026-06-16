package com.example.eduadmin.model.service;

import com.example.eduadmin.model.entity.Course;
import java.util.List;

public interface CourseService {
    Course findById(Integer id);
    List<Course> findAll();
    List<Course> findByType(String type);
    boolean add(Course course);
    boolean update(Course course);
    boolean delete(Integer id);
}