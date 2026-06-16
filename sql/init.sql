-- ============================================
-- 教务管理系统 数据库初始化脚本
-- 使用方法：在 Navicat 中打开此文件，点击"运行"执行
-- ============================================

-- 删除旧数据库（可选，如需重新初始化请取消注释）
-- DROP DATABASE IF EXISTS edu_admin;

-- 创建数据库
CREATE DATABASE IF NOT EXISTS edu_admin DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE edu_admin;

-- ============================================
-- 1. 创建表结构
-- ============================================

-- 用户表（存储所有角色的登录信息）
DROP TABLE IF EXISTS scores;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS course_schedules;
DROP TABLE IF EXISTS classrooms;
DROP TABLE IF EXISTS semesters;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS class_info;
DROP TABLE IF EXISTS teachers;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '登录账号',
    password VARCHAR(100) NOT NULL COMMENT '登录密码',
    role VARCHAR(20) NOT NULL COMMENT '角色: student/teacher/admin'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 学生表
CREATE TABLE students (
    user_id INT PRIMARY KEY,
    student_no VARCHAR(20) NOT NULL UNIQUE COMMENT '学号',
    name VARCHAR(50) NOT NULL COMMENT '姓名',
    gender VARCHAR(10) COMMENT '性别',
    class_id INT COMMENT '班级ID',
    major VARCHAR(100) COMMENT '专业',
    enroll_year INT COMMENT '入学年份',
    phone VARCHAR(20) COMMENT '电话',
    email VARCHAR(100) COMMENT '邮箱',
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学生表';

-- 教师表
CREATE TABLE teachers (
    user_id INT PRIMARY KEY,
    teacher_no VARCHAR(20) NOT NULL UNIQUE COMMENT '工号',
    name VARCHAR(50) NOT NULL COMMENT '姓名',
    gender VARCHAR(10) COMMENT '性别',
    title VARCHAR(50) COMMENT '职称',
    department VARCHAR(100) COMMENT '院系',
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='教师表';

-- 班级表
CREATE TABLE class_info (
    class_id INT PRIMARY KEY AUTO_INCREMENT,
    class_name VARCHAR(100) NOT NULL COMMENT '班级名称',
    major VARCHAR(100) COMMENT '专业',
    grade INT COMMENT '年级',
    teacher_id INT COMMENT '班主任ID',
    FOREIGN KEY (teacher_id) REFERENCES users(user_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='班级表';

-- 课程表
CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL COMMENT '课程名称',
    credit DOUBLE NOT NULL COMMENT '学分',
    hours INT NOT NULL COMMENT '学时',
    type VARCHAR(20) NOT NULL COMMENT '类型: 必修/选修',
    description TEXT COMMENT '课程描述'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='课程表';

-- 学期表
CREATE TABLE semesters (
    semester_id INT PRIMARY KEY AUTO_INCREMENT,
    semester_name VARCHAR(50) NOT NULL COMMENT '学期名称',
    start_date DATE NOT NULL COMMENT '开始日期',
    end_date DATE NOT NULL COMMENT '结束日期'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学期表';

-- 教室表
CREATE TABLE classrooms (
    classroom_id INT PRIMARY KEY AUTO_INCREMENT,
    classroom_name VARCHAR(50) NOT NULL COMMENT '教室名称',
    building VARCHAR(50) COMMENT '教学楼',
    capacity INT NOT NULL COMMENT '容量',
    has_multimedia BOOLEAN DEFAULT FALSE COMMENT '是否有多媒体'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='教室表';

-- 排课表
CREATE TABLE course_schedules (
    schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT NOT NULL COMMENT '课程ID',
    teacher_id INT NOT NULL COMMENT '授课教师ID',
    semester VARCHAR(50) NOT NULL COMMENT '学期',
    classroom VARCHAR(100) NOT NULL COMMENT '教室',
    time_slot VARCHAR(50) NOT NULL COMMENT '时间片(日期-节次)',
    capacity INT NOT NULL COMMENT '容量',
    enrolled_count INT DEFAULT 0 COMMENT '已选人数',
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (teacher_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='排课表';

-- 选课表
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL COMMENT '学生ID',
    schedule_id INT NOT NULL COMMENT '排课ID',
    enroll_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '选课日期',
    status VARCHAR(20) DEFAULT 'pending' COMMENT '状态: pending/approved/rejected',
    FOREIGN KEY (student_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (schedule_id) REFERENCES course_schedules(schedule_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='选课表';

-- 成绩表
CREATE TABLE scores (
    score_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL COMMENT '学生ID',
    schedule_id INT NOT NULL COMMENT '排课ID',
    regular_score DOUBLE COMMENT '平时分',
    exam_score DOUBLE COMMENT '考试分',
    final_score DOUBLE COMMENT '最终分',
    gpa DOUBLE COMMENT '绩点',
    FOREIGN KEY (student_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (schedule_id) REFERENCES course_schedules(schedule_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='成绩表';

-- ============================================
-- 2. 插入初始数据
-- ============================================

-- 管理员账号（用户名: admin，密码: admin）
INSERT INTO users (username, password, role) VALUES ('admin', 'admin', 'admin');

-- 学生账号（用户名=学号，密码: 123456）
INSERT INTO users (username, password, role) VALUES
('2025001', '123456', 'student'),
('2025002', '123456', 'student'),
('2025003', '123456', 'student'),
('2025004', '123456', 'student'),
('2025005', '123456', 'student');

INSERT INTO students (user_id, student_no, name, gender, class_id, major, enroll_year, phone, email) VALUES
(2, '2025001', '张三', '男', 1, '计算机科学', 2025, '13800001111', 'zhangsan@example.com'),
(3, '2025002', '李四', '女', 2, '软件工程', 2025, '13800002222', 'lisi@example.com'),
(4, '2025003', '王五', '男', 3, '信息安全', 2025, '13800003333', 'wangwu@example.com'),
(5, '2025004', '赵六', '女', 1, '计算机科学', 2025, '13800004444', 'zhaoliu@example.com'),
(6, '2025005', '孙七', '男', 2, '软件工程', 2025, '13800005555', 'sunqi@example.com');

-- 教师账号（用户名=工号，密码: 123456）
INSERT INTO users (username, password, role) VALUES
('T001', '123456', 'teacher'),
('T002', '123456', 'teacher'),
('T003', '123456', 'teacher'),
('T004', 'admin123', 'teacher'),
('T005', '123456', 'teacher'),
('T006', '123456', 'teacher'),
('T007', '123456', 'teacher'),
('T008', '123456', 'teacher');

INSERT INTO teachers (user_id, teacher_no, name, gender, title, department) VALUES
(7, 'T001', '刘建国', '男', '教授', '计算机学院'),
(8, 'T002', '陈美华', '女', '副教授', '计算机学院'),
(9, 'T003', '王志强', '男', '讲师', '计算机学院'),
(10, 'T004', '宋浩', '男', '教授', '计算机学院'),
(11, 'T005', '刘晓燕', '女', '副教授', '计算机学院'),
(12, 'T006', '张芳', '女', '讲师', '计算机学院'),
(13, 'T007', '王伟', '男', '讲师', '计算机学院'),
(14, 'T008', '王伟', '男', '讲师', '计算机学院');

-- 班级
INSERT INTO class_info (class_id, class_name, major, grade, teacher_id) VALUES
(1, '计科2025-1班', '计算机科学', 2025, 7),
(2, '软工2025-1班', '软件工程', 2025, 8),
(3, '信安2025-1班', '信息安全', 2025, 9);

-- 课程
INSERT INTO courses (course_name, credit, hours, type, description) VALUES
('Java程序设计', 3.0, 48, '必修', 'Java语言基础与面向对象编程'),
('数据结构', 4.0, 64, '必修', '常用数据结构与算法分析'),
('数据库原理', 3.5, 56, '必修', '关系数据库设计与SQL'),
('Web开发技术', 3.0, 48, '选修', 'HTML/CSS/JavaScript与后端开发'),
('人工智能导论', 2.5, 40, '选修', '人工智能基础知识与应用'),
('计算机网络', 3.0, 48, '必修', '计算机网络原理与协议');

-- 学期
INSERT INTO semesters (semester_name, start_date, end_date) VALUES
('2025-2026-1', '2025-09-01', '2026-01-15'),
('2025-2026-2', '2026-02-20', '2026-07-01');

-- 教室
INSERT INTO classrooms (classroom_name, building, capacity, has_multimedia) VALUES
('A101', '教学楼A', 60, TRUE),
('A201', '教学楼A', 50, TRUE),
('A301', '教学楼A', 40, FALSE),
('B101', '教学楼B', 120, TRUE),
('B201', '教学楼B', 80, TRUE),
('B301', '教学楼B', 40, FALSE);

-- 排课（2025-2026-1学期）
-- 时间片格式: 日期(1-5表示周一到周五)-节次(1=1-2节,2=3-4节,3=5-6节,4=7-8节,5=9-10节)
INSERT INTO course_schedules (course_id, teacher_id, semester, classroom, time_slot, capacity, enrolled_count) VALUES
-- Java程序设计 - 刘教授
(1, 7, '2025-2026-1', 'A101', '1-1', 60, 0),
(1, 7, '2025-2026-1', 'A101', '3-2', 60, 0),
-- 数据结构 - 刘教授
(2, 7, '2025-2026-1', 'A201', '1-3', 50, 0),
-- 数据库原理 - 陈老师
(3, 8, '2025-2026-1', 'B101', '2-1', 120, 0),
-- Web开发技术 - 陈老师
(4, 8, '2025-2026-1', 'B201', '2-3', 80, 0),
-- 人工智能导论 - 王讲师
(5, 9, '2025-2026-1', 'B301', '3-1', 40, 0),
-- 计算机网络 - 王讲师
(6, 9, '2025-2026-1', 'A301', '4-1', 40, 0);

-- ============================================
-- 3. 初始数据说明
-- ============================================
--
-- 登录账号：
--   管理员：admin / admin
--   学生：  2025001 / 123456（张三）
--           2025002 / 123456（李四）
--           2025003 / 123456（王五）
--           2025004 / 123456（赵六）
--           2025005 / 123456（孙七）
--   教师：  T001 / 123456（刘建国）
--           T002 / 123456（陈美华）
--           T003 / 123456（王志强）
--           T004 / admin123（宋浩）
--           T005 / 123456（刘晓燕）
--           T006 / 123456（张芳）
--           T007 / 123456（王伟）
--           T008 / 123456（王伟）
--
-- 时间片说明：
--   1-1 = 周一 1-2节    1-2 = 周一 3-4节
--   2-1 = 周二 1-2节    2-2 = 周二 3-4节
--   3-1 = 周三 1-2节    3-2 = 周三 3-4节
--   4-1 = 周四 1-2节    4-2 = 周四 3-4节
--   5-1 = 周五 1-2节    5-2 = 周五 3-4节