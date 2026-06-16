package com.example.eduadmin.model.service;

import com.example.eduadmin.model.entity.Semester;
import java.util.List;

public interface SemesterService {
    Semester findById(Integer id);
    List<Semester> findAll();
    Semester findCurrent();
    boolean add(Semester semester);
    boolean update(Semester semester);
    boolean delete(Integer id);
}