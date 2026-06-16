package com.example.eduadmin.model.service.impl;

import com.example.eduadmin.model.dao.CourseDao;
import com.example.eduadmin.model.dao.CourseScheduleDao;
import com.example.eduadmin.model.entity.Course;
import com.example.eduadmin.model.entity.CourseSchedule;
import com.example.eduadmin.model.service.ScheduleService;

import java.util.List;

public class ScheduleServiceImpl implements ScheduleService {
    private CourseScheduleDao scheduleDao = new CourseScheduleDao();

    @Override
    public CourseSchedule findById(Integer id) {
        return scheduleDao.findById(id);
    }

    @Override
    public List<CourseSchedule> findBySemester(String semester) {
        return scheduleDao.findBySemester(semester);
    }

    @Override
    public List<CourseSchedule> findByTeacherId(Integer teacherId) {
        return scheduleDao.findByTeacherId(teacherId);
    }

    @Override
    public List<CourseSchedule> findByStudentId(Integer studentId) {
        return scheduleDao.findByStudentId(studentId);
    }

    @Override
    public List<CourseSchedule> findByGroup(Integer courseId, Integer teacherId, String semester, String classroom) {
        return scheduleDao.findByGroup(courseId, teacherId, semester, classroom);
    }

    @Override
    public boolean hasConflict(CourseSchedule schedule) {
        return scheduleDao.hasTimeSlotConflict(schedule.getSemester(),
                schedule.getTimeSlot(), schedule.getScheduleId());
    }

    @Override
    public String getConflictMessage(CourseSchedule schedule) {
        CourseSchedule conflict = scheduleDao.findConflictByTimeSlot(
                schedule.getSemester(), schedule.getTimeSlot(), schedule.getScheduleId());
        if (conflict != null) {
            Course conflictCourse = new CourseDao().findById(conflict.getCourseId());
            String courseName = conflictCourse != null ? conflictCourse.getCourseName() : "未知课程";
            return "该时间段已安排【" + courseName + "】，请选择其他时间段。";
        }
        return null;
    }

    @Override
    public boolean add(CourseSchedule schedule) {
        if (hasConflict(schedule)) return false;
        return scheduleDao.insert(schedule) > 0;
    }

    @Override
    public boolean addMulti(Integer courseId, Integer teacherId, String semester, String classroom, int capacity, String[] timeSlots) {
        for (String slot : timeSlots) {
            if (scheduleDao.hasTimeSlotConflict(semester, slot, null)) return false;
        }
        boolean allOk = true;
        for (String slot : timeSlots) {
            CourseSchedule cs = new CourseSchedule();
            cs.setCourseId(courseId);
            cs.setTeacherId(teacherId);
            cs.setSemester(semester);
            cs.setClassroom(classroom);
            cs.setTimeSlot(slot);
            cs.setCapacity(capacity);
            cs.setEnrolledCount(0);
            if (scheduleDao.insert(cs) <= 0) allOk = false;
        }
        return allOk;
    }

    @Override
    public boolean update(CourseSchedule schedule) {
        if (hasConflict(schedule)) return false;
        return scheduleDao.update(schedule);
    }

    @Override
    public boolean updateMulti(Integer courseId, Integer teacherId, String semester, String classroom, int capacity, String[] timeSlots, Integer excludeScheduleId) {
        List<CourseSchedule> oldSlots = scheduleDao.findByGroup(courseId, teacherId, semester, classroom);
        scheduleDao.deleteByGroup(courseId, teacherId, semester, classroom);
        for (String slot : timeSlots) {
            if (scheduleDao.hasTimeSlotConflict(semester, slot, null)) {
                restoreSlots(oldSlots);
                return false;
            }
        }
        boolean allOk = true;
        for (String slot : timeSlots) {
            CourseSchedule cs = new CourseSchedule();
            cs.setCourseId(courseId);
            cs.setTeacherId(teacherId);
            cs.setSemester(semester);
            cs.setClassroom(classroom);
            cs.setTimeSlot(slot);
            cs.setCapacity(capacity);
            cs.setEnrolledCount(0);
            if (scheduleDao.insert(cs) <= 0) allOk = false;
        }
        return allOk;
    }

    private void restoreSlots(List<CourseSchedule> oldSlots) {
        for (CourseSchedule cs : oldSlots) {
            scheduleDao.insert(cs);
        }
    }

    @Override
    public boolean delete(Integer id) {
        return scheduleDao.delete(id);
    }

    @Override
    public int deleteByGroup(Integer courseId, Integer teacherId, String semester, String classroom) {
        return scheduleDao.deleteByGroup(courseId, teacherId, semester, classroom);
    }
}
