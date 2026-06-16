package com.example.eduadmin.model.service.impl;

import com.example.eduadmin.model.dao.ClassroomDao;
import com.example.eduadmin.model.entity.Classroom;
import com.example.eduadmin.model.service.ClassroomService;
import java.util.List;

public class ClassroomServiceImpl implements ClassroomService {
    private ClassroomDao classroomDao = new ClassroomDao();

    @Override
    public Classroom findById(Integer id) { return classroomDao.findById(id); }

    @Override
    public List<Classroom> findAll() { return classroomDao.findAll(); }

    @Override
    public boolean isAvailable(String classroom, String timeSlot, String semester) {
        return classroomDao.isAvailable(classroom, timeSlot, semester);
    }

    @Override
    public boolean add(Classroom classroom) { return classroomDao.insert(classroom) > 0; }

    @Override
    public boolean update(Classroom classroom) { return classroomDao.update(classroom); }

    @Override
    public boolean delete(Integer id) { return classroomDao.delete(id); }
}