package com.example.eduadmin.model.dao;

import com.example.eduadmin.model.entity.Course;
import com.example.eduadmin.model.entity.CourseSchedule;
import com.example.eduadmin.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CourseScheduleDao {

    public CourseSchedule findById(Integer scheduleId) {
        String sql = "SELECT * FROM course_schedules WHERE schedule_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, scheduleId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<CourseSchedule> findBySemester(String semester) {
        List<CourseSchedule> list = new ArrayList<>();
        String sql = "SELECT * FROM course_schedules WHERE semester = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, semester);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<CourseSchedule> findByTeacherId(Integer teacherId) {
        List<CourseSchedule> list = new ArrayList<>();
        String sql = "SELECT * FROM course_schedules WHERE teacher_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, teacherId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<CourseSchedule> findByStudentId(Integer studentId) {
        List<CourseSchedule> list = new ArrayList<>();
        String sql = "SELECT cs.* FROM course_schedules cs " +
                     "JOIN enrollments e ON cs.schedule_id = e.schedule_id " +
                     "WHERE e.student_id = ? AND e.status = 'approved'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean hasTimeSlotConflict(String semester, String timeSlot, Integer excludeScheduleId) {
        String sql = "SELECT COUNT(*) FROM course_schedules WHERE semester=? AND time_slot=? AND schedule_id!=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, semester);
            ps.setString(2, timeSlot);
            ps.setInt(3, excludeScheduleId != null ? excludeScheduleId : 0);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public CourseSchedule findConflictByTimeSlot(String semester, String timeSlot, Integer excludeScheduleId) {
        String sql = "SELECT * FROM course_schedules WHERE semester=? AND time_slot=? AND schedule_id!=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, semester);
            ps.setString(2, timeSlot);
            ps.setInt(3, excludeScheduleId != null ? excludeScheduleId : 0);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean hasStudentTimeConflict(Integer studentId, String timeSlot, Integer excludeScheduleId) {
        String sql = "SELECT COUNT(*) FROM course_schedules cs " +
                     "JOIN enrollments e ON cs.schedule_id = e.schedule_id " +
                     "WHERE e.student_id = ? AND cs.time_slot = ? AND e.status = 'approved' AND cs.schedule_id != ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setString(2, timeSlot);
            ps.setInt(3, excludeScheduleId != null ? excludeScheduleId : 0);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public String getConflictMessage(CourseSchedule schedule) {
        CourseSchedule conflict = findConflictByTimeSlot(
                schedule.getSemester(), schedule.getTimeSlot(), schedule.getScheduleId());
        if (conflict != null) {
            Course conflictCourse = new CourseDao().findById(conflict.getCourseId());
            String courseName = conflictCourse != null ? conflictCourse.getCourseName() : "未知课程";
            return "该时间段已安排【" + courseName + "】，请选择其他时间段。";
        }
        return null;
    }

    public boolean updateEnrolledCount(Integer scheduleId, int delta) {
        String sql = "UPDATE course_schedules SET enrolled_count = enrolled_count + ? WHERE schedule_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, delta);
            ps.setInt(2, scheduleId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public int insert(CourseSchedule schedule) {
        String sql = "INSERT INTO course_schedules (course_id, teacher_id, semester, classroom, time_slot, capacity, enrolled_count) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, schedule.getCourseId());
            ps.setInt(2, schedule.getTeacherId());
            ps.setString(3, schedule.getSemester());
            ps.setString(4, schedule.getClassroom());
            ps.setString(5, schedule.getTimeSlot());
            ps.setInt(6, schedule.getCapacity());
            ps.setInt(7, schedule.getEnrolledCount() != null ? schedule.getEnrolledCount() : 0);
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    public boolean update(CourseSchedule schedule) {
        String sql = "UPDATE course_schedules SET course_id=?, teacher_id=?, semester=?, classroom=?, time_slot=?, capacity=? WHERE schedule_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, schedule.getCourseId());
            ps.setInt(2, schedule.getTeacherId());
            ps.setString(3, schedule.getSemester());
            ps.setString(4, schedule.getClassroom());
            ps.setString(5, schedule.getTimeSlot());
            ps.setInt(6, schedule.getCapacity());
            ps.setInt(7, schedule.getScheduleId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean delete(Integer scheduleId) {
        String sql = "DELETE FROM course_schedules WHERE schedule_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, scheduleId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public List<CourseSchedule> findByGroup(Integer courseId, Integer teacherId, String semester, String classroom) {
        List<CourseSchedule> list = new ArrayList<>();
        String sql = "SELECT * FROM course_schedules WHERE course_id=? AND teacher_id=? AND semester=? AND classroom=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ps.setInt(2, teacherId);
            ps.setString(3, semester);
            ps.setString(4, classroom);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int deleteByGroup(Integer courseId, Integer teacherId, String semester, String classroom) {
        String sql = "DELETE FROM course_schedules WHERE course_id=? AND teacher_id=? AND semester=? AND classroom=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ps.setInt(2, teacherId);
            ps.setString(3, semester);
            ps.setString(4, classroom);
            return ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private CourseSchedule mapRow(ResultSet rs) throws SQLException {
        CourseSchedule cs = new CourseSchedule();
        cs.setScheduleId(rs.getInt("schedule_id"));
        cs.setCourseId(rs.getInt("course_id"));
        cs.setTeacherId(rs.getInt("teacher_id"));
        cs.setSemester(rs.getString("semester"));
        cs.setClassroom(rs.getString("classroom"));
        cs.setTimeSlot(rs.getString("time_slot"));
        cs.setCapacity(rs.getInt("capacity"));
        cs.setEnrolledCount(rs.getInt("enrolled_count"));
        return cs;
    }
}