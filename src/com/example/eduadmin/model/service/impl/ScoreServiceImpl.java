package com.example.eduadmin.model.service.impl;

import com.example.eduadmin.model.dao.ScoreDao;
import com.example.eduadmin.model.entity.Score;
import com.example.eduadmin.model.service.ScoreService;
import com.example.eduadmin.util.GradeCalculator;

import java.util.List;

public class ScoreServiceImpl implements ScoreService {
    private ScoreDao scoreDao = new ScoreDao();

    @Override
    public Score findByStudentAndSchedule(Integer studentId, Integer scheduleId) {
        return scoreDao.findByStudentAndSchedule(studentId, scheduleId);
    }

    @Override
    public List<Score> findByStudentId(Integer studentId) {
        return scoreDao.findByStudentId(studentId);
    }

    @Override
    public List<Score> findByScheduleId(Integer scheduleId) {
        return scoreDao.findByScheduleId(scheduleId);
    }

    @Override
    public boolean saveOrUpdate(Score score) {
        score.setFinalScore(GradeCalculator.calculateFinalScore(score.getRegularScore(), score.getExamScore()));
        score.setGpa(GradeCalculator.calculateGpa(score.getFinalScore()));
        return scoreDao.insertOrUpdate(score) > 0;
    }

    @Override
    public Double getAverageByScheduleId(Integer scheduleId) {
        return scoreDao.getAverageByScheduleId(scheduleId);
    }
}