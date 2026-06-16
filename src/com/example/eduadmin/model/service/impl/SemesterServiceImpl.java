package com.example.eduadmin.model.service.impl;

import com.example.eduadmin.model.dao.SemesterDao;
import com.example.eduadmin.model.entity.Semester;
import com.example.eduadmin.model.service.SemesterService;
import java.util.List;

public class SemesterServiceImpl implements SemesterService {
    private SemesterDao semesterDao = new SemesterDao();

    @Override
    public Semester findById(Integer id) { return semesterDao.findById(id); }

    @Override
    public List<Semester> findAll() { return semesterDao.findAll(); }

    @Override
    public Semester findCurrent() { return semesterDao.findCurrent(); }

    @Override
    public boolean add(Semester semester) { return semesterDao.insert(semester) > 0; }

    @Override
    public boolean update(Semester semester) { return semesterDao.update(semester); }

    @Override
    public boolean delete(Integer id) { return semesterDao.delete(id); }
}