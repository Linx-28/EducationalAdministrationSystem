package com.example.eduadmin.model.service.impl;

import com.example.eduadmin.model.dao.TeacherDao;
import com.example.eduadmin.model.entity.Teacher;
import com.example.eduadmin.model.service.TeacherService;

import java.util.List;

public class TeacherServiceImpl implements TeacherService {
    private TeacherDao teacherDao = new TeacherDao();

    @Override
    public Teacher findById(Integer userId) {
        return teacherDao.findByUserId(userId);
    }

    @Override
    public List<Teacher> findAll() {
        return teacherDao.findAll();
    }

    @Override
    public boolean add(Teacher teacher) {
        return teacherDao.insert(teacher);
    }

    @Override
    public boolean update(Teacher teacher) {
        return teacherDao.update(teacher);
    }

    @Override
    public boolean delete(Integer userId) {
        return teacherDao.delete(userId);
    }
}