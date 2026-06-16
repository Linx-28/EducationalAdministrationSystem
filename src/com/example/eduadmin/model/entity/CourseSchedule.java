package com.example.eduadmin.model.entity;

import java.io.Serializable;

public class CourseSchedule implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private Integer scheduleId;
    private Integer courseId;
    private Integer teacherId;
    private String semester;
    private String classroom;
    private String timeSlot;
    private Integer capacity;
    private Integer enrolledCount;
    
    public CourseSchedule() {}
    
    public CourseSchedule(Integer scheduleId, Integer courseId, Integer teacherId, String semester, 
                          String classroom, String timeSlot, Integer capacity, Integer enrolledCount) {
        this.scheduleId = scheduleId;
        this.courseId = courseId;
        this.teacherId = teacherId;
        this.semester = semester;
        this.classroom = classroom;
        this.timeSlot = timeSlot;
        this.capacity = capacity;
        this.enrolledCount = enrolledCount;
    }
    
    public Integer getScheduleId() { return scheduleId; }
    public void setScheduleId(Integer scheduleId) { this.scheduleId = scheduleId; }
    public Integer getCourseId() { return courseId; }
    public void setCourseId(Integer courseId) { this.courseId = courseId; }
    public Integer getTeacherId() { return teacherId; }
    public void setTeacherId(Integer teacherId) { this.teacherId = teacherId; }
    public String getSemester() { return semester; }
    public void setSemester(String semester) { this.semester = semester; }
    public String getClassroom() { return classroom; }
    public void setClassroom(String classroom) { this.classroom = classroom; }
    public String getTimeSlot() { return timeSlot; }
    public void setTimeSlot(String timeSlot) { this.timeSlot = timeSlot; }
    public Integer getCapacity() { return capacity; }
    public void setCapacity(Integer capacity) { this.capacity = capacity; }
    public Integer getEnrolledCount() { return enrolledCount; }
    public void setEnrolledCount(Integer enrolledCount) { this.enrolledCount = enrolledCount; }
}