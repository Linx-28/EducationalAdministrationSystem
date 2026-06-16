package com.example.eduadmin.model.dao;

import com.example.eduadmin.model.entity.Semester;
import com.example.eduadmin.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SemesterDao {

    public Semester findById(Integer semesterId) {
        String sql = "SELECT * FROM semesters WHERE semester_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, semesterId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<Semester> findAll() {
        List<Semester> list = new ArrayList<>();
        String sql = "SELECT * FROM semesters ORDER BY start_date DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Semester findCurrent() {
        String sql = "SELECT * FROM semesters WHERE CURDATE() BETWEEN start_date AND end_date";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public int insert(Semester semester) {
        String sql = "INSERT INTO semesters (semester_name, start_date, end_date) VALUES (?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, semester.getSemesterName());
            ps.setDate(2, new Date(semester.getStartDate().getTime()));
            ps.setDate(3, new Date(semester.getEndDate().getTime()));
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    public boolean update(Semester semester) {
        String sql = "UPDATE semesters SET semester_name=?, start_date=?, end_date=? WHERE semester_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, semester.getSemesterName());
            ps.setDate(2, new Date(semester.getStartDate().getTime()));
            ps.setDate(3, new Date(semester.getEndDate().getTime()));
            ps.setInt(4, semester.getSemesterId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean delete(Integer semesterId) {
        String sql = "DELETE FROM semesters WHERE semester_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, semesterId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    private Semester mapRow(ResultSet rs) throws SQLException {
        Semester s = new Semester();
        s.setSemesterId(rs.getInt("semester_id"));
        s.setSemesterName(rs.getString("semester_name"));
        s.setStartDate(rs.getDate("start_date"));
        s.setEndDate(rs.getDate("end_date"));
        return s;
    }
}