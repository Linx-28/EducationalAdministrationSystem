package com.example.eduadmin.model.entity;

import java.io.Serializable;

public class Classroom implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private Integer classroomId;
    private String classroomName;
    private String building;
    private Integer capacity;
    private Boolean hasMultimedia;
    
    public Classroom() {}
    
    public Classroom(Integer classroomId, String classroomName, String building, Integer capacity, Boolean hasMultimedia) {
        this.classroomId = classroomId;
        this.classroomName = classroomName;
        this.building = building;
        this.capacity = capacity;
        this.hasMultimedia = hasMultimedia;
    }
    
    public Integer getClassroomId() { return classroomId; }
    public void setClassroomId(Integer classroomId) { this.classroomId = classroomId; }
    public String getClassroomName() { return classroomName; }
    public void setClassroomName(String classroomName) { this.classroomName = classroomName; }
    public String getBuilding() { return building; }
    public void setBuilding(String building) { this.building = building; }
    public Integer getCapacity() { return capacity; }
    public void setCapacity(Integer capacity) { this.capacity = capacity; }
    public Boolean getHasMultimedia() { return hasMultimedia; }
    public void setHasMultimedia(Boolean hasMultimedia) { this.hasMultimedia = hasMultimedia; }
}