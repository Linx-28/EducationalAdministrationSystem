package com.example.eduadmin.model.entity;

import java.io.Serializable;

public class ClassInfo implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private Integer classId;
    private String className;
    private String major;
    private Integer grade;
    private Integer teacherId; // 班主任ID
    
    public ClassInfo() {}
    
    public ClassInfo(Integer classId, String className, String major, Integer grade, Integer teacherId) {
        this.classId = classId;
        this.className = className;
        this.major = major;
        this.grade = grade;
        this.teacherId = teacherId;
    }
    
    public Integer getClassId() { return classId; }
    public void setClassId(Integer classId) { this.classId = classId; }
    public String getClassName() { return className; }
    public void setClassName(String className) { this.className = className; }
    public String getMajor() { return major; }
    public void setMajor(String major) { this.major = major; }
    public Integer getGrade() { return grade; }
    public void setGrade(Integer grade) { this.grade = grade; }
    public Integer getTeacherId() { return teacherId; }
    public void setTeacherId(Integer teacherId) { this.teacherId = teacherId; }
}