package com.example.eduadmin.model.entity;

import java.io.Serializable;

public class Student extends User implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private String studentNo; // 学号
    private String name;      // 姓名
    private String gender;    // 性别
    private Integer classId;  // 班级ID
    private String major;     // 专业
    private Integer enrollYear; // 入学年份
    private String phone;     // 电话
    private String email;     // 邮箱
    
    public Student() {}
    
    public Student(Integer userId, String username, String password, String studentNo, 
                   String name, String gender, Integer classId, String major, 
                   Integer enrollYear, String phone, String email) {
        super(userId, username, password, "student");
        this.studentNo = studentNo;
        this.name = name;
        this.gender = gender;
        this.classId = classId;
        this.major = major;
        this.enrollYear = enrollYear;
        this.phone = phone;
        this.email = email;
    }
    
    public String getStudentNo() { return studentNo; }
    public void setStudentNo(String studentNo) { this.studentNo = studentNo; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    public Integer getClassId() { return classId; }
    public void setClassId(Integer classId) { this.classId = classId; }
    public String getMajor() { return major; }
    public void setMajor(String major) { this.major = major; }
    public Integer getEnrollYear() { return enrollYear; }
    public void setEnrollYear(Integer enrollYear) { this.enrollYear = enrollYear; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
}