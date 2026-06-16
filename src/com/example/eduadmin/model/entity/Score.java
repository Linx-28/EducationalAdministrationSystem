package com.example.eduadmin.model.entity;

import java.io.Serializable;

public class Score implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private Integer scoreId;
    private Integer studentId;
    private Integer scheduleId;
    private Double regularScore; // 平时分
    private Double examScore;    // 考试分
    private Double finalScore;   // 最终分
    private Double gpa;          // 绩点
    
    public Score() {}
    
    public Score(Integer scoreId, Integer studentId, Integer scheduleId, Double regularScore, 
                 Double examScore, Double finalScore, Double gpa) {
        this.scoreId = scoreId;
        this.studentId = studentId;
        this.scheduleId = scheduleId;
        this.regularScore = regularScore;
        this.examScore = examScore;
        this.finalScore = finalScore;
        this.gpa = gpa;
    }
    
    public Integer getScoreId() { return scoreId; }
    public void setScoreId(Integer scoreId) { this.scoreId = scoreId; }
    public Integer getStudentId() { return studentId; }
    public void setStudentId(Integer studentId) { this.studentId = studentId; }
    public Integer getScheduleId() { return scheduleId; }
    public void setScheduleId(Integer scheduleId) { this.scheduleId = scheduleId; }
    public Double getRegularScore() { return regularScore; }
    public void setRegularScore(Double regularScore) { this.regularScore = regularScore; }
    public Double getExamScore() { return examScore; }
    public void setExamScore(Double examScore) { this.examScore = examScore; }
    public Double getFinalScore() { return finalScore; }
    public void setFinalScore(Double finalScore) { this.finalScore = finalScore; }
    public Double getGpa() { return gpa; }
    public void setGpa(Double gpa) { this.gpa = gpa; }
}