package com.example.eduadmin.model.entity;

import java.io.Serializable;

public class Teacher extends User implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private String teacherNo; // 工号
    private String name;      // 姓名
    private String gender;    // 性别
    private String title;     // 职称
    private String department; // 院系
    
    public Teacher() {}
    
    public Teacher(Integer userId, String username, String password, String teacherNo, 
                   String name, String gender, String title, String department) {
        super(userId, username, password, "teacher");
        this.teacherNo = teacherNo;
        this.name = name;
        this.gender = gender;
        this.title = title;
        this.department = department;
    }
    
    public String getTeacherNo() { return teacherNo; }
    public void setTeacherNo(String teacherNo) { this.teacherNo = teacherNo; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }
}