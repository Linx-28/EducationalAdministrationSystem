package com.example.eduadmin.model.service;

import com.example.eduadmin.model.entity.Student;
import java.util.List;

public interface StudentService {
    Student findById(Integer userId);
    List<Student> findAll(int page, int pageSize);
    int count();
    boolean add(Student student);
    boolean update(Student student);
    boolean delete(Integer userId);
    List<Student> findByClassId(Integer classId);
}