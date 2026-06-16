package com.example.eduadmin.model.service.impl;

import com.example.eduadmin.model.dao.CourseScheduleDao;
import com.example.eduadmin.model.dao.EnrollmentDao;
import com.example.eduadmin.model.entity.CourseSchedule;
import com.example.eduadmin.model.entity.Enrollment;
import com.example.eduadmin.model.service.EnrollmentService;

import java.util.Date;
import java.util.List;

public class EnrollmentServiceImpl implements EnrollmentService {
    private EnrollmentDao enrollmentDao = new EnrollmentDao();
    private CourseScheduleDao scheduleDao = new CourseScheduleDao();

    @Override
    public boolean enroll(Integer studentId, Integer scheduleId) {
        String msg = getEnrollErrorMessage(studentId, scheduleId);
        if (msg != null) return false;
        CourseSchedule schedule = scheduleDao.findById(scheduleId);
        Enrollment enrollment = new Enrollment();
        enrollment.setStudentId(studentId);
        enrollment.setScheduleId(scheduleId);
        enrollment.setEnrollDate(new Date());
        enrollment.setStatus("approved");
        int id = enrollmentDao.insert(enrollment);
        if (id > 0) {
            scheduleDao.updateEnrolledCount(scheduleId, 1);
            return true;
        }
        return false;
    }

    @Override
    public String getEnrollErrorMessage(Integer studentId, Integer scheduleId) {
        if (isEnrolled(studentId, scheduleId)) {
            return "您已选过该课程";
        }
        CourseSchedule schedule = scheduleDao.findById(scheduleId);
        if (schedule == null) {
            return "课程不存在";
        }
        if (schedule.getEnrolledCount() != null && schedule.getEnrolledCount() >= schedule.getCapacity()) {
            return "该课程已满员";
        }
        if (scheduleDao.hasStudentTimeConflict(studentId, schedule.getTimeSlot(), scheduleId)) {
            return "与已选课程时间冲突";
        }
        return null;
    }

    @Override
    public boolean cancelEnrollment(Integer studentId, Integer scheduleId) {
        if (enrollmentDao.deleteByStudentAndSchedule(studentId, scheduleId)) {
            scheduleDao.updateEnrolledCount(scheduleId, -1);
            return true;
        }
        return false;
    }

    @Override
    public List<Enrollment> findByStudentId(Integer studentId) {
        return enrollmentDao.findByStudentId(studentId);
    }

    @Override
    public List<Enrollment> findByStatus(String status) {
        return enrollmentDao.findByStatus(status);
    }

    @Override
    public List<Enrollment> findByScheduleId(Integer scheduleId) {
        return enrollmentDao.findByScheduleId(scheduleId);
    }

    @Override
    public boolean approve(Integer enrollmentId) {
        return enrollmentDao.updateStatus(enrollmentId, "approved");
    }

    @Override
    public boolean reject(Integer enrollmentId) {
        Enrollment e = enrollmentDao.findById(enrollmentId);
        if (e != null) {
            scheduleDao.updateEnrolledCount(e.getScheduleId(), -1);
            return enrollmentDao.updateStatus(enrollmentId, "rejected");
        }
        return false;
    }

    @Override
    public int countByScheduleId(Integer scheduleId) {
        return enrollmentDao.countByScheduleId(scheduleId);
    }

    @Override
    public int countUniqueStudentsByCourseId(Integer courseId) {
        return enrollmentDao.countUniqueStudentsByCourseId(courseId);
    }

    @Override
    public boolean isEnrolled(Integer studentId, Integer scheduleId) {
        return enrollmentDao.isEnrolled(studentId, scheduleId);
    }
}