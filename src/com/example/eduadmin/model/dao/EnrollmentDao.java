package com.example.eduadmin.model.dao;

import com.example.eduadmin.model.entity.Enrollment;
import com.example.eduadmin.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EnrollmentDao {

    public Enrollment findById(Integer enrollmentId) {
        String sql = "SELECT * FROM enrollments WHERE enrollment_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, enrollmentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<Enrollment> findByStudentId(Integer studentId) {
        List<Enrollment> list = new ArrayList<>();
        String sql = "SELECT * FROM enrollments WHERE student_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Enrollment> findByScheduleId(Integer scheduleId) {
        List<Enrollment> list = new ArrayList<>();
        String sql = "SELECT * FROM enrollments WHERE schedule_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, scheduleId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Enrollment> findByStatus(String status) {
        List<Enrollment> list = new ArrayList<>();
        String sql = "SELECT * FROM enrollments WHERE status = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean isEnrolled(Integer studentId, Integer scheduleId) {
        String sql = "SELECT COUNT(*) FROM enrollments WHERE student_id=? AND schedule_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, scheduleId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public int countByScheduleId(Integer scheduleId) {
        String sql = "SELECT COUNT(*) FROM enrollments WHERE schedule_id=? AND status='approved'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, scheduleId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public int countUniqueStudentsByCourseId(Integer courseId) {
        String sql = "SELECT COUNT(DISTINCT e.student_id) FROM enrollments e " +
                     "JOIN course_schedules cs ON e.schedule_id = cs.schedule_id " +
                     "WHERE cs.course_id = ? AND e.status = 'approved'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public int insert(Enrollment enrollment) {
        String sql = "INSERT INTO enrollments (student_id, schedule_id, enroll_date, status) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, enrollment.getStudentId());
            ps.setInt(2, enrollment.getScheduleId());
            ps.setTimestamp(3, new Timestamp(enrollment.getEnrollDate().getTime()));
            ps.setString(4, enrollment.getStatus());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    public boolean updateStatus(Integer enrollmentId, String status) {
        String sql = "UPDATE enrollments SET status = ? WHERE enrollment_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, enrollmentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean delete(Integer enrollmentId) {
        String sql = "DELETE FROM enrollments WHERE enrollment_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, enrollmentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean deleteByStudentAndSchedule(Integer studentId, Integer scheduleId) {
        String sql = "DELETE FROM enrollments WHERE student_id = ? AND schedule_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, scheduleId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    private Enrollment mapRow(ResultSet rs) throws SQLException {
        Enrollment e = new Enrollment();
        e.setEnrollmentId(rs.getInt("enrollment_id"));
        e.setStudentId(rs.getInt("student_id"));
        e.setScheduleId(rs.getInt("schedule_id"));
        e.setEnrollDate(rs.getTimestamp("enroll_date"));
        e.setStatus(rs.getString("status"));
        return e;
    }
}