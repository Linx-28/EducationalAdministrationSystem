package com.example.eduadmin.model.dao;

import com.example.eduadmin.model.entity.ClassInfo;
import com.example.eduadmin.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClassInfoDao {

    public ClassInfo findById(Integer classId) {
        String sql = "SELECT * FROM class_info WHERE class_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, classId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<ClassInfo> findAll() {
        List<ClassInfo> list = new ArrayList<>();
        String sql = "SELECT * FROM class_info";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int insert(ClassInfo classInfo) {
        String sql = "INSERT INTO class_info (class_name, major, grade, teacher_id) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, classInfo.getClassName());
            ps.setString(2, classInfo.getMajor());
            ps.setInt(3, classInfo.getGrade());
            ps.setObject(4, classInfo.getTeacherId());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    public boolean update(ClassInfo classInfo) {
        String sql = "UPDATE class_info SET class_name=?, major=?, grade=?, teacher_id=? WHERE class_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, classInfo.getClassName());
            ps.setString(2, classInfo.getMajor());
            ps.setInt(3, classInfo.getGrade());
            ps.setObject(4, classInfo.getTeacherId());
            ps.setInt(5, classInfo.getClassId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean delete(Integer classId) {
        String sql = "DELETE FROM class_info WHERE class_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, classId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    private ClassInfo mapRow(ResultSet rs) throws SQLException {
        ClassInfo c = new ClassInfo();
        c.setClassId(rs.getInt("class_id"));
        c.setClassName(rs.getString("class_name"));
        c.setMajor(rs.getString("major"));
        c.setGrade(rs.getInt("grade"));
        c.setTeacherId(rs.getObject("teacher_id") != null ? rs.getInt("teacher_id") : null);
        return c;
    }
}