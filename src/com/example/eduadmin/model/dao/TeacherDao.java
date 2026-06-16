package com.example.eduadmin.model.dao;

import com.example.eduadmin.model.entity.Teacher;
import com.example.eduadmin.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TeacherDao {
    
    public Teacher findByUserId(Integer userId) {
        String sql = "SELECT * FROM teachers WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) {
                Teacher t = new Teacher();
                t.setUserId(rs.getInt("user_id"));
                t.setTeacherNo(rs.getString("teacher_no"));
                t.setName(rs.getString("name"));
                t.setGender(rs.getString("gender"));
                t.setTitle(rs.getString("title"));
                t.setDepartment(rs.getString("department"));
                return t;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(rs, ps, conn);
        }
        return null;
    }
    
    public List<Teacher> findAll() {
        List<Teacher> list = new ArrayList<>();
        String sql = "SELECT * FROM teachers";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Teacher t = new Teacher();
                t.setUserId(rs.getInt("user_id"));
                t.setTeacherNo(rs.getString("teacher_no"));
                t.setName(rs.getString("name"));
                t.setGender(rs.getString("gender"));
                t.setTitle(rs.getString("title"));
                t.setDepartment(rs.getString("department"));
                list.add(t);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(rs, ps, conn);
        }
        return list;
    }
    
    public boolean insert(Teacher teacher) {
        String sql = "INSERT INTO teachers (user_id, teacher_no, name, gender, title, department) VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, teacher.getUserId());
            ps.setString(2, teacher.getTeacherNo());
            ps.setString(3, teacher.getName());
            ps.setString(4, teacher.getGender());
            ps.setString(5, teacher.getTitle());
            ps.setString(6, teacher.getDepartment());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(ps, conn);
        }
        return false;
    }
    
    public boolean update(Teacher teacher) {
        String sql = "UPDATE teachers SET name=?, gender=?, title=?, department=? WHERE user_id=?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, teacher.getName());
            ps.setString(2, teacher.getGender());
            ps.setString(3, teacher.getTitle());
            ps.setString(4, teacher.getDepartment());
            ps.setInt(5, teacher.getUserId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(ps, conn);
        }
        return false;
    }
    
    public boolean delete(Integer userId) {
        String sql = "DELETE FROM teachers WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(ps, conn);
        }
        return false;
    }
}