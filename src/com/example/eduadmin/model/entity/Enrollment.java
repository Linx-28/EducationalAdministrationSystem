package com.example.eduadmin.model.entity;

import java.io.Serializable;
import java.util.Date;

public class Enrollment implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private Integer enrollmentId;
    private Integer studentId;
    private Integer scheduleId;
    private Date enrollDate;
    private String status; // pending, approved, rejected
    
    public Enrollment() {}
    
    public Enrollment(Integer enrollmentId, Integer studentId, Integer scheduleId, Date enrollDate, String status) {
        this.enrollmentId = enrollmentId;
        this.studentId = studentId;
        this.scheduleId = scheduleId;
        this.enrollDate = enrollDate;
        this.status = status;
    }
    
    public Integer getEnrollmentId() { return enrollmentId; }
    public void setEnrollmentId(Integer enrollmentId) { this.enrollmentId = enrollmentId; }
    public Integer getStudentId() { return studentId; }
    public void setStudentId(Integer studentId) { this.studentId = studentId; }
    public Integer getScheduleId() { return scheduleId; }
    public void setScheduleId(Integer scheduleId) { this.scheduleId = scheduleId; }
    public Date getEnrollDate() { return enrollDate; }
    public void setEnrollDate(Date enrollDate) { this.enrollDate = enrollDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}