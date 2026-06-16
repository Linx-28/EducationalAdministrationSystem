package com.example.eduadmin.model.dao;

import com.example.eduadmin.model.entity.Score;
import com.example.eduadmin.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ScoreDao {

    public Score findById(Integer scoreId) {
        String sql = "SELECT * FROM scores WHERE score_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, scoreId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public Score findByStudentAndSchedule(Integer studentId, Integer scheduleId) {
        String sql = "SELECT * FROM scores WHERE student_id=? AND schedule_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, scheduleId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<Score> findByStudentId(Integer studentId) {
        List<Score> list = new ArrayList<>();
        String sql = "SELECT * FROM scores WHERE student_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Score> findByScheduleId(Integer scheduleId) {
        List<Score> list = new ArrayList<>();
        String sql = "SELECT * FROM scores WHERE schedule_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, scheduleId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int insertOrUpdate(Score score) {
        Score existing = findByStudentAndSchedule(score.getStudentId(), score.getScheduleId());
        if (existing != null) {
            score.setScoreId(existing.getScoreId());
            return update(score) ? score.getScoreId() : -1;
        }
        String sql = "INSERT INTO scores (student_id, schedule_id, regular_score, exam_score, final_score, gpa) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, score.getStudentId());
            ps.setInt(2, score.getScheduleId());
            ps.setDouble(3, score.getRegularScore() != null ? score.getRegularScore() : 0);
            ps.setDouble(4, score.getExamScore() != null ? score.getExamScore() : 0);
            ps.setDouble(5, score.getFinalScore() != null ? score.getFinalScore() : 0);
            ps.setDouble(6, score.getGpa() != null ? score.getGpa() : 0);
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    public boolean update(Score score) {
        String sql = "UPDATE scores SET regular_score=?, exam_score=?, final_score=?, gpa=? WHERE score_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDouble(1, score.getRegularScore() != null ? score.getRegularScore() : 0);
            ps.setDouble(2, score.getExamScore() != null ? score.getExamScore() : 0);
            ps.setDouble(3, score.getFinalScore() != null ? score.getFinalScore() : 0);
            ps.setDouble(4, score.getGpa() != null ? score.getGpa() : 0);
            ps.setInt(5, score.getScoreId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public Double getAverageByScheduleId(Integer scheduleId) {
        String sql = "SELECT AVG(final_score) FROM scores WHERE schedule_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, scheduleId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0.0;
    }

    public int getCountByScheduleId(Integer scheduleId) {
        String sql = "SELECT COUNT(*) FROM scores WHERE schedule_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, scheduleId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private Score mapRow(ResultSet rs) throws SQLException {
        Score s = new Score();
        s.setScoreId(rs.getInt("score_id"));
        s.setStudentId(rs.getInt("student_id"));
        s.setScheduleId(rs.getInt("schedule_id"));
        s.setRegularScore(rs.getDouble("regular_score"));
        s.setExamScore(rs.getDouble("exam_score"));
        s.setFinalScore(rs.getDouble("final_score"));
        s.setGpa(rs.getDouble("gpa"));
        return s;
    }
}