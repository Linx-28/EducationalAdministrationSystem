package com.example.eduadmin.model.service;

import com.example.eduadmin.model.entity.CourseSchedule;
import java.util.List;

public interface ScheduleService {
    CourseSchedule findById(Integer id);
    List<CourseSchedule> findBySemester(String semester);
    List<CourseSchedule> findByTeacherId(Integer teacherId);
    List<CourseSchedule> findByStudentId(Integer studentId);
    List<CourseSchedule> findByGroup(Integer courseId, Integer teacherId, String semester, String classroom);
    boolean hasConflict(CourseSchedule schedule);
    String getConflictMessage(CourseSchedule schedule);
    boolean add(CourseSchedule schedule);
    boolean addMulti(Integer courseId, Integer teacherId, String semester, String classroom, int capacity, String[] timeSlots);
    boolean update(CourseSchedule schedule);
    boolean updateMulti(Integer courseId, Integer teacherId, String semester, String classroom, int capacity, String[] timeSlots, Integer excludeScheduleId);
    boolean delete(Integer id);
    int deleteByGroup(Integer courseId, Integer teacherId, String semester, String classroom);
}