package com.example.eduadmin.model.entity;

import java.io.Serializable;
import java.util.Date;

public class Semester implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private Integer semesterId;
    private String semesterName;
    private Date startDate;
    private Date endDate;
    
    public Semester() {}
    
    public Semester(Integer semesterId, String semesterName, Date startDate, Date endDate) {
        this.semesterId = semesterId;
        this.semesterName = semesterName;
        this.startDate = startDate;
        this.endDate = endDate;
    }
    
    public Integer getSemesterId() { return semesterId; }
    public void setSemesterId(Integer semesterId) { this.semesterId = semesterId; }
    public String getSemesterName() { return semesterName; }
    public void setSemesterName(String semesterName) { this.semesterName = semesterName; }
    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }
    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }
}