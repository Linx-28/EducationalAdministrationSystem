package com.example.eduadmin.model.dao;

import com.example.eduadmin.model.entity.Student;
import com.example.eduadmin.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StudentDao {
    
    public Student findByUserId(Integer userId) {
        String sql = "SELECT * FROM students WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) {
                Student s = new Student();
                s.setUserId(rs.getInt("user_id"));
                s.setStudentNo(rs.getString("student_no"));
                s.setName(rs.getString("name"));
                s.setGender(rs.getString("gender"));
                s.setClassId(rs.getInt("class_id"));
                s.setMajor(rs.getString("major"));
                s.setEnrollYear(rs.getInt("enroll_year"));
                s.setPhone(rs.getString("phone"));
                s.setEmail(rs.getString("email"));
                return s;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(rs, ps, conn);
        }
        return null;
    }
    
    public List<Student> findAll(int page, int pageSize) {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT * FROM students LIMIT ? OFFSET ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, pageSize);
            ps.setInt(2, (page - 1) * pageSize);
            rs = ps.executeQuery();
            while (rs.next()) {
                Student s = new Student();
                s.setUserId(rs.getInt("user_id"));
                s.setStudentNo(rs.getString("student_no"));
                s.setName(rs.getString("name"));
                s.setGender(rs.getString("gender"));
                s.setClassId(rs.getInt("class_id"));
                s.setMajor(rs.getString("major"));
                s.setEnrollYear(rs.getInt("enroll_year"));
                s.setPhone(rs.getString("phone"));
                s.setEmail(rs.getString("email"));
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(rs, ps, conn);
        }
        return list;
    }
    
    public int count() {
        String sql = "SELECT COUNT(*) FROM students";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(rs, ps, conn);
        }
        return 0;
    }
    
    public boolean insert(Student student) {
        String sql = "INSERT INTO students (user_id, student_no, name, gender, class_id, major, enroll_year, phone, email) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, student.getUserId());
            ps.setString(2, student.getStudentNo());
            ps.setString(3, student.getName());
            ps.setString(4, student.getGender());
            if (student.getClassId() != null) {
                ps.setInt(5, student.getClassId());
            } else {
                ps.setNull(5, java.sql.Types.INTEGER);
            }
            ps.setString(6, student.getMajor());
            if (student.getEnrollYear() != null) {
                ps.setInt(7, student.getEnrollYear());
            } else {
                ps.setNull(7, java.sql.Types.INTEGER);
            }
            ps.setString(8, student.getPhone());
            ps.setString(9, student.getEmail());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(ps, conn);
        }
        return false;
    }
    
    public boolean update(Student student) {
        String sql = "UPDATE students SET name=?, gender=?, class_id=?, major=?, enroll_year=?, phone=?, email=? WHERE user_id=?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, student.getName());
            ps.setString(2, student.getGender());
            if (student.getClassId() != null) {
                ps.setInt(3, student.getClassId());
            } else {
                ps.setNull(3, java.sql.Types.INTEGER);
            }
            ps.setString(4, student.getMajor());
            if (student.getEnrollYear() != null) {
                ps.setInt(5, student.getEnrollYear());
            } else {
                ps.setNull(5, java.sql.Types.INTEGER);
            }
            ps.setString(6, student.getPhone());
            ps.setString(7, student.getEmail());
            ps.setInt(8, student.getUserId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(ps, conn);
        }
        return false;
    }
    
    public boolean delete(Integer userId) {
        String sql = "DELETE FROM students WHERE user_id = ?";
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
    
    public List<Student> findByClassId(Integer classId) {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT * FROM students WHERE class_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, classId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Student s = new Student();
                s.setUserId(rs.getInt("user_id"));
                s.setStudentNo(rs.getString("student_no"));
                s.setName(rs.getString("name"));
                s.setGender(rs.getString("gender"));
                s.setClassId(rs.getInt("class_id"));
                s.setMajor(rs.getString("major"));
                s.setEnrollYear(rs.getInt("enroll_year"));
                s.setPhone(rs.getString("phone"));
                s.setEmail(rs.getString("email"));
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(rs, ps, conn);
        }
        return list;
    }
}