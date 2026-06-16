package com.example.eduadmin.model.dao;

import com.example.eduadmin.model.entity.Classroom;
import com.example.eduadmin.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClassroomDao {

    public Classroom findById(Integer classroomId) {
        String sql = "SELECT * FROM classrooms WHERE classroom_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, classroomId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<Classroom> findAll() {
        List<Classroom> list = new ArrayList<>();
        String sql = "SELECT * FROM classrooms";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean isAvailable(String classroom, String timeSlot, String semester) {
        String sql = "SELECT COUNT(*) FROM course_schedules WHERE classroom=? AND time_slot=? AND semester=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, classroom);
            ps.setString(2, timeSlot);
            ps.setString(3, semester);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) == 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public int insert(Classroom classroom) {
        String sql = "INSERT INTO classrooms (classroom_name, building, capacity, has_multimedia) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, classroom.getClassroomName());
            ps.setString(2, classroom.getBuilding());
            ps.setInt(3, classroom.getCapacity());
            ps.setBoolean(4, classroom.getHasMultimedia());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    public boolean update(Classroom classroom) {
        String sql = "UPDATE classrooms SET classroom_name=?, building=?, capacity=?, has_multimedia=? WHERE classroom_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, classroom.getClassroomName());
            ps.setString(2, classroom.getBuilding());
            ps.setInt(3, classroom.getCapacity());
            ps.setBoolean(4, classroom.getHasMultimedia());
            ps.setInt(5, classroom.getClassroomId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean delete(Integer classroomId) {
        String sql = "DELETE FROM classrooms WHERE classroom_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, classroomId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    private Classroom mapRow(ResultSet rs) throws SQLException {
        Classroom c = new Classroom();
        c.setClassroomId(rs.getInt("classroom_id"));
        c.setClassroomName(rs.getString("classroom_name"));
        c.setBuilding(rs.getString("building"));
        c.setCapacity(rs.getInt("capacity"));
        c.setHasMultimedia(rs.getBoolean("has_multimedia"));
        return c;
    }
}