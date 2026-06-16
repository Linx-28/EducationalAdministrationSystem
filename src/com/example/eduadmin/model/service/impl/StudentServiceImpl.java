package com.example.eduadmin.model.service.impl;

import com.example.eduadmin.model.dao.StudentDao;
import com.example.eduadmin.model.entity.Student;
import com.example.eduadmin.model.service.StudentService;

import java.util.List;

public class StudentServiceImpl implements StudentService {
    private StudentDao studentDao = new StudentDao();

    @Override
    public Student findById(Integer userId) {
        return studentDao.findByUserId(userId);
    }

    @Override
    public List<Student> findAll(int page, int pageSize) {
        return studentDao.findAll(page, pageSize);
    }

    @Override
    public int count() {
        return studentDao.count();
    }

    @Override
    public boolean add(Student student) {
        return studentDao.insert(student);
    }

    @Override
    public boolean update(Student student) {
        return studentDao.update(student);
    }

    @Override
    public boolean delete(Integer userId) {
        return studentDao.delete(userId);
    }

    @Override
    public List<Student> findByClassId(Integer classId) {
        return studentDao.findByClassId(classId);
    }
}