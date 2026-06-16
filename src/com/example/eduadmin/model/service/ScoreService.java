package com.example.eduadmin.model.service;

import com.example.eduadmin.model.entity.Score;
import java.util.List;

public interface ScoreService {
    Score findByStudentAndSchedule(Integer studentId, Integer scheduleId);
    List<Score> findByStudentId(Integer studentId);
    List<Score> findByScheduleId(Integer scheduleId);
    boolean saveOrUpdate(Score score);
    Double getAverageByScheduleId(Integer scheduleId);
}