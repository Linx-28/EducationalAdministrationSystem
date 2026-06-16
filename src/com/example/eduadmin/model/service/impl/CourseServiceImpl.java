package com.example.eduadmin.model.service.impl;

import com.example.eduadmin.model.dao.CourseDao;
import com.example.eduadmin.model.entity.Course;
import com.example.eduadmin.model.service.CourseService;

import java.util.List;

public class CourseServiceImpl implements CourseService {
    private CourseDao courseDao = new CourseDao();

    @Override
    public Course findById(Integer id) {
        return courseDao.findById(id);
    }

    @Override
    public List<Course> findAll() {
        return courseDao.findAll();
    }

    @Override
    public List<Course> findByType(String type) {
        return courseDao.findByType(type);
    }

    @Override
    public boolean add(Course course) {
        return courseDao.insert(course) > 0;
    }

    @Override
    public boolean update(Course course) {
        return courseDao.update(course);
    }

    @Override
    public boolean delete(Integer id) {
        return courseDao.delete(id);
    }
}