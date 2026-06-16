package com.example.eduadmin.model.service.impl;

import com.example.eduadmin.model.dao.ClassInfoDao;
import com.example.eduadmin.model.entity.ClassInfo;
import com.example.eduadmin.model.service.ClassInfoService;
import java.util.List;

public class ClassInfoServiceImpl implements ClassInfoService {
    private ClassInfoDao classInfoDao = new ClassInfoDao();

    @Override
    public ClassInfo findById(Integer id) { return classInfoDao.findById(id); }

    @Override
    public List<ClassInfo> findAll() { return classInfoDao.findAll(); }

    @Override
    public boolean add(ClassInfo classInfo) { return classInfoDao.insert(classInfo) > 0; }

    @Override
    public boolean update(ClassInfo classInfo) { return classInfoDao.update(classInfo); }

    @Override
    public boolean delete(Integer id) { return classInfoDao.delete(id); }
}