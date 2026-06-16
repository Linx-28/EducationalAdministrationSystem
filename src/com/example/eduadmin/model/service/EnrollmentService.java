package com.example.eduadmin.model.service;

import com.example.eduadmin.model.entity.Enrollment;
import java.util.List;

public interface EnrollmentService {
    boolean enroll(Integer studentId, Integer scheduleId);
    String getEnrollErrorMessage(Integer studentId, Integer scheduleId);
    boolean cancelEnrollment(Integer studentId, Integer scheduleId);
    List<Enrollment> findByStudentId(Integer studentId);
    List<Enrollment> findByScheduleId(Integer scheduleId);
    List<Enrollment> findByStatus(String status);
    boolean approve(Integer enrollmentId);
    boolean reject(Integer enrollmentId);
    int countByScheduleId(Integer scheduleId);
    int countUniqueStudentsByCourseId(Integer courseId);
    boolean isEnrolled(Integer studentId, Integer scheduleId);
}