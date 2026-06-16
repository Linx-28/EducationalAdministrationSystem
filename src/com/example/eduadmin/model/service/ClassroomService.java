package com.example.eduadmin.model.service;

import com.example.eduadmin.model.entity.Classroom;
import java.util.List;

public interface ClassroomService {
    Classroom findById(Integer id);
    List<Classroom> findAll();
    boolean isAvailable(String classroom, String timeSlot, String semester);
    boolean add(Classroom classroom);
    boolean update(Classroom classroom);
    boolean delete(Integer id);
}