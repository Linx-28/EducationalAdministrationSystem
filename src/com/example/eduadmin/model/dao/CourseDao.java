package com.example.eduadmin.model.dao;

import com.example.eduadmin.model.entity.Course;
import com.example.eduadmin.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CourseDao {

    public Course findById(Integer courseId) {
        String sql = "SELECT * FROM courses WHERE course_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<Course> findAll() {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT * FROM courses";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Course> findByType(String type) {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT * FROM courses WHERE type = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, type);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int insert(Course course) {
        String sql = "INSERT INTO courses (course_name, credit, hours, type, description) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, course.getCourseName());
            ps.setDouble(2, course.getCredit());
            ps.setInt(3, course.getHours());
            ps.setString(4, course.getType());
            ps.setString(5, course.getDescription());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    public boolean update(Course course) {
        String sql = "UPDATE courses SET course_name=?, credit=?, hours=?, type=?, description=? WHERE course_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, course.getCourseName());
            ps.setDouble(2, course.getCredit());
            ps.setInt(3, course.getHours());
            ps.setString(4, course.getType());
            ps.setString(5, course.getDescription());
            ps.setInt(6, course.getCourseId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean delete(Integer courseId) {
        String sql = "DELETE FROM courses WHERE course_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    private Course mapRow(ResultSet rs) throws SQLException {
        Course c = new Course();
        c.setCourseId(rs.getInt("course_id"));
        c.setCourseName(rs.getString("course_name"));
        c.setCredit(rs.getDouble("credit"));
        c.setHours(rs.getInt("hours"));
        c.setType(rs.getString("type"));
        c.setDescription(rs.getString("description"));
        return c;
    }
}