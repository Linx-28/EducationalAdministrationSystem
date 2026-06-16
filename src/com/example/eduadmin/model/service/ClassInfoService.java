package com.example.eduadmin.model.service;

import com.example.eduadmin.model.entity.ClassInfo;
import java.util.List;

public interface ClassInfoService {
    ClassInfo findById(Integer id);
    List<ClassInfo> findAll();
    boolean add(ClassInfo classInfo);
    boolean update(ClassInfo classInfo);
    boolean delete(Integer id);
}