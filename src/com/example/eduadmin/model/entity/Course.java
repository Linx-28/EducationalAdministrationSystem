package com.example.eduadmin.model.entity;

import java.io.Serializable;

public class Course implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private Integer courseId;
    private String courseName;
    private Double credit;
    private Integer hours;
    private String type; // 必修/选修
    private String description;
    
    public Course() {}
    
    public Course(Integer courseId, String courseName, Double credit, Integer hours, String type, String description) {
        this.courseId = courseId;
        this.courseName = courseName;
        this.credit = credit;
        this.hours = hours;
        this.type = type;
        this.description = description;
    }
    
    public Integer getCourseId() { return courseId; }
    public void setCourseId(Integer courseId) { this.courseId = courseId; }
    public String getCourseName() { return courseName; }
    public void setCourseName(String courseName) { this.courseName = courseName; }
    public Double getCredit() { return credit; }
    public void setCredit(Double credit) { this.credit = credit; }
    public Integer getHours() { return hours; }
    public void setHours(Integer hours) { this.hours = hours; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}