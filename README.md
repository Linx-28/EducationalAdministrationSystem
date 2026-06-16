# 教务管理系统 (Educational Administration System)

基于 Java Servlet + JSP 的高校教务管理系统，支持管理员、教师、学生三种角色，涵盖排课、选课、成绩管理等核心教务功能。

---

## 技术栈

| 类别 | 技术 |
|------|------|
| 后端 | Java Servlet 4.0 + JSP |
| 数据库 | MySQL 8.0 |
| 数据访问 | 原生 JDBC |
| JSON 序列化 | Gson 2.x |
| 服务器 | Tomcat 9.0+ |
| 前端 | HTML + CSS + 原生 JavaScript |

---

## 项目结构

```
EducationalAdministrationSystem/
├── sql/
│   └── init.sql                     # 数据库建表 + 初始数据
├── src/
│   └── com/example/eduadmin/
│       ├── controller/              # Servlet 控制器
│       │   ├── AdminController.java       # 管理员所有操作
│       │   ├── TeacherController.java     # 教师端操作
│       │   ├── StudentController.java     # 学生端操作
│       │   ├── EnrollmentController.java  # 选课/退选
│       │   ├── ScoreController.java       # 成绩录入
│       │   ├── HomeController.java        # 首页
│       │   ├── LoginController.java       # 登录
│       │   └── BaseServlet.java           # Servlet 基类（反射路由）
│       ├── filter/
│       │   ├── EncodingFilter.java        # UTF-8 编码过滤器
│       │   └── LoginFilter.java           # 登录拦截过滤器
│       ├── model/
│       │   ├── entity/                    # 实体类
│       │   │   ├── User.java              # 用户（管理员/教师/学生共用）
│       │   │   ├── Student.java           # 学生
│       │   │   ├── Teacher.java           # 教师
│       │   │   ├── Course.java            # 课程
│       │   │   ├── CourseSchedule.java    # 排课记录
│       │   │   ├── Enrollment.java        # 选课记录
│       │   │   ├── Score.java             # 成绩
│       │   │   ├── Classroom.java         # 教室
│       │   │   ├── Semester.java          # 学期
│       │   │   └── ClassInfo.java         # 班级
│       │   ├── dao/                       # 数据访问层
│       │   │   ├── UserDao.java
│       │   │   ├── StudentDao.java
│       │   │   ├── TeacherDao.java
│       │   │   ├── CourseDao.java
│       │   │   ├── CourseScheduleDao.java
│       │   │   ├── EnrollmentDao.java
│       │   │   ├── ScoreDao.java
│       │   │   ├── ClassroomDao.java
│       │   │   ├── SemesterDao.java
│       │   │   └── ClassInfoDao.java
│       │   └── service/                   # 业务逻辑层
│       │       ├── *.java                 # 接口
│       │       └── impl/*.java            # 实现
│       └── util/
│           ├── DBUtil.java                # 数据库连接工具
│           ├── WebUtils.java              # Web 工具（JSON 写出等）
│           ├── GradeCalculator.java       # 绩点计算
│           └── EnrollmentCart.java        # 选课购物车
├── web/
│   ├── WEB-INF/
│   │   ├── web.xml                        # Servlet 配置
│   │   └── lib/                           # JAR 包
│   ├── views/
│   │   ├── index.jsp                      # 首页/登录
│   │   ├── login.jsp                      # 登录页
│   │   ├── common/                        # 公共组件
│   │   │   ├── header.jsp
│   │   │   ├── sidebar.jsp
│   │   │   └── footer.jsp
│   │   ├── admin/                         # 管理员页面
│   │   │   ├── dashboard.jsp              # 仪表盘
│   │   │   ├── student_manage.jsp         # 学生管理
│   │   │   ├── teacher_manage.jsp         # 教师管理
│   │   │   ├── course_manage.jsp          # 课程管理
│   │   │   ├── schedule_manage.jsp        # 排课管理
│   │   │   ├── enrollment_approve.jsp     # 选课审核
│   │   │   ├── score_manage.jsp           # 成绩管理
│   │   │   ├── classroom_manage.jsp       # 教室管理
│   │   │   └── semester_manage.jsp        # 学期管理
│   │   ├── teacher/                       # 教师页面
│   │   │   ├── home.jsp                   # 教师首页
│   │   │   ├── my_schedule.jsp            # 我的课表
│   │   │   ├── score_input.jsp            # 成绩录入
│   │   │   ├── view_scores.jsp            # 成绩查看
│   │   │   └── student_list.jsp           # 学生名单
│   │   ├── student/                       # 学生页面
│   │   │   ├── home.jsp                   # 学生首页
│   │   │   ├── enroll.jsp                 # 在线选课
│   │   │   ├── my_schedule.jsp            # 我的课表
│   │   │   ├── my_scores.jsp              # 我的成绩
│   │   │   └── profile.jsp               # 个人信息
│   │   └── error/
│   │       ├── 404.jsp
│   │       └── 500.jsp
│   └── static/
│       ├── css/
│       │   ├── common.css
│       │   ├── admin.css
│       │   └── student.css
│       └── js/
│           ├── common.js
│           ├── schedule.js
│           ├── enrollment.js
│           └── score.js
└── README.md
```

---

## 数据库设计

### 表结构总览

| 表名 | 说明 | 主键 |
|------|------|------|
| `users` | 用户表（所有角色共用） | `user_id` |
| `students` | 学生信息 | `user_id` (FK → users) |
| `teachers` | 教师信息 | `user_id` (FK → users) |
| `class_info` | 班级 | `class_id` |
| `courses` | 课程 | `course_id` |
| `semesters` | 学期 | `semester_id` |
| `classrooms` | 教室 | `classroom_id` |
| `course_schedules` | 排课表 | `schedule_id` |
| `enrollments` | 选课记录 | `enrollment_id` |
| `scores` | 成绩表 | `score_id` |

### 核心字段说明

- **users**：`username` 为登录账号，`role` 取值 `admin`/`teacher`/`student`
- **students**：`student_no` 学号（唯一），`class_id` 关联班级
- **teachers**：`teacher_no` 工号（唯一）
- **course_schedules**：`time_slot` 格式为 `日期-节次`（如 `1-1` = 周一 1-2节）
- **enrollments**：`status` 取值 `pending`/`approved`/`rejected`
- **scores**：`regular_score` 平时分，`exam_score` 考试分，`final_score` = 平时分×30% + 考试分×70%

---

## 环境配置

### 1. 数据库初始化

```bash
# 登录 MySQL
mysql -u root -p

# 执行初始化脚本
source sql/init.sql
```

或在 Navicat 中打开 `sql/init.sql` 点击"运行"执行。

### 2. 修改数据库连接

编辑 `src/db.properties`：

```properties
jdbc.driver=com.mysql.cj.jdbc.Driver
jdbc.url=jdbc:mysql://localhost:3306/edu_admin?useSSL=false&serverTimezone=Asia/Shanghai&characterEncoding=utf8&allowPublicKeyRetrieval=true
jdbc.username=root
jdbc.password=你的密码
```

### 3. IDEA 配置

1. **打开项目**：File → Open → 选择项目根目录
2. **配置 Module**：Project Structure → Modules
   - 将 `src` 目录标记为 **Sources**
   - 将 `web` 目录标记为 **Web Resource Directory**
3. **添加依赖**：确保 `web/WEB-INF/lib/` 下有以下 JAR 包：
   - `mysql-connector-java-8.x.jar`
   - `gson-2.x.jar`
4. **配置 Tomcat**：Run → Edit Configurations → 添加 Tomcat Server
   - Deployment → 添加 Artifact → 选择 `EducationalAdministrationSystem:war exploded`
   - Application URL 设为 `http://localhost:8080/`

### 4. 启动项目

点击 IDEA 工具栏的 Run/Debug 按钮启动 Tomcat，浏览器访问 `http://localhost:8080`。

---

## 默认账号

### 管理员

| 登录账号 | 密码 |
|----------|------|
| admin | admin |

### 学生

| 学号 | 密码 | 姓名 |
|------|------|------|
| 2025001 | 123456 | 张三 |
| 2025002 | 123456 | 李四 |
| 2025003 | 123456 | 王五 |
| 2025004 | 123456 | 赵六 |
| 2025005 | 123456 | 孙七 |

### 教师

| 工号 | 密码 | 姓名 |
|------|------|------|
| T001 | 123456 | 刘建国 |
| T002 | 123456 | 陈美华 |
| T003 | 123456 | 王志强 |
| T004 | admin123 | 宋浩 |
| T005 | 123456 | 刘晓燕 |
| T006 | 123456 | 张芳 |
| T007 | 123456 | 王伟 |


---

## 功能说明

### 管理员端

| 功能 | 说明 |
|------|------|
| **仪表盘** | 显示学生总数、教师总数、课程总数、本学期排课数等统计数据 |
| **学生管理** | 添加/删除学生，学生按学号排序 |
| **教师管理** | 添加/删除教师，教师按工号排序，所有字段必填，添加成功/失败均有提示 |
| **课程管理** | 添加/删除课程（必修/选修） |
| **排课管理** | 全校统一排课模式，每个时间段只能安排一门课，已排课程在课表中用颜色高亮显示且不可选中，冲突检测精确到课程名称 |
| **选课审核** | 审核学生的选课申请（通过/拒绝） |
| **成绩管理** | 查看所有课程成绩，按学号排序，显示学号和姓名 |
| **教室管理** | 添加/删除教室（教学楼、容量、多媒体） |
| **学期管理** | 添加/删除学期 |

### 教师端

| 功能 | 说明 |
|------|------|
| **首页** | 显示教师个人信息和授课概览 |
| **我的课表** | 按周显示本周课程时间表 |
| **成绩录入** | 选择课程 → 按班级分组显示学生 → 录入平时分和考试分 → 批量保存 |
| **成绩查看** | 选择课程 → 按班级分组查看成绩、平均分、绩点 |
| **学生名单** | 选择课程 → 按班级分组查看选课学生信息 |

> 教师端课程下拉框显示"X个班"（有学生选课的班级数），而非时间段数。

### 学生端

| 功能 | 说明 |
|------|------|
| **首页** | 显示学生个人信息 |
| **在线选课** | 查看可选课程列表，一键选课（自动选中该课程所有时间段），支持退选，显示时间冲突和容量状态 |
| **我的课表** | 按周显示已选课程时间表 |
| **我的成绩** | 查看已出成绩，显示平时分、考试分、最终分、绩点 |
| **个人信息** | 查看和修改个人资料 |

---

## 排课时间片说明

`time_slot` 格式为 `日期-节次`：

| 格式 | 含义 |
|------|------|
| 1-1 | 周一 第1-2节 |
| 1-2 | 周一 第3-4节 |
| 1-3 | 周一 第5-6节 |
| 1-4 | 周一 第7-8节 |
| 1-5 | 周一 第9-10节 |
| 2-1 | 周二 第1-2节 |
| ... | ... |
| 5-5 | 周五 第9-10节 |

共 5天 × 5节 × 2课时 = **25个时间段**

---

## 架构设计

### 请求流转

```
浏览器请求 → EncodingFilter(UTF-8) → LoginFilter(登录校验)
         → BaseServlet(反射路由) → XxxController.method()
         → Service层 → DAO层 → JDBC → MySQL
         → 转发到 JSP → 响应 HTML
```

### MVC 分层

| 层 | 职责 | 位置 |
|----|------|------|
| **View** | 页面展示 | `web/views/*.jsp` |
| **Controller** | 请求分发、参数校验、调用 Service | `controller/*.java` |
| **Service** | 业务逻辑（冲突检测、成绩计算等） | `model/service/impl/*.java` |
| **DAO** | 数据库 CRUD | `model/dao/*.java` |
| **Entity** | 数据实体 | `model/entity/*.java` |

### 路由机制

采用 `BaseServlet` + 反射实现方法路由：

```
GET /admin?method=teacherManage  →  AdminController.teacherManage()
POST /admin?method=addTeacher    →  AdminController.addTeacher()
GET /teacher?method=scoreInput   →  TeacherController.scoreInput()
GET /student?method=enroll       →  StudentController.enroll()
GET /enrollment?method=enroll    →  EnrollmentController.enroll()
GET /score?method=batchSave      →  ScoreController.batchSave()
```

---

## 核心业务逻辑

### 全校统一排课

- 每个时间段（如周一第1-2节）只能安排一门课
- 前端时间格用颜色区分：灰色 = 已被占用（显示课程名），青色 = 当前编辑课程可重选，蓝色 = 已选择
- 后端双重校验：前端 JS 阻止 + 后端 Service 层时间冲突检测

### 选课机制

- 选课以课程为单位，一次选中该课程所有时间段
- 选课前检测：时间冲突、课程容量
- 选课成功后自动更新各时间段的 `enrolled_count`
- 退选同理，自动递减

### 成绩计算

```
最终分 = 平时分 × 30% + 考试分 × 70%
绩点换算：90+ = 4.0，80-89 = 3.0，70-79 = 2.0，60-69 = 1.0，<60 = 0.0
```

### 容量显示

- 学生选课页面显示的是**唯一学生数**（同一学生选了多节课只算一人），通过 `COUNT(DISTINCT student_id)` 实现
- 各时间段的 `enrolled_count` 独立维护

---

## 常见问题

### Q: 启动后页面 404

检查 IDEA 中 Tomcat 的 Application URL 是否配置为项目上下文路径，或检查 `web.xml` 的 `welcome-file`。

### Q: 数据库连接失败

1. 确认 MySQL 服务已启动
2. 检查 `src/db.properties` 中的用户名、密码、端口
3. 确认数据库 `edu_admin` 已通过 `init.sql` 创建

### Q: 中文乱码

`EncodingFilter` 已全局设置 UTF-8，如仍有问题检查 MySQL 连接字符串是否包含 `characterEncoding=utf8`。

### Q: 添加教师/学生时报"已存在"

删除教师/学生时已改为同时删除 `users` 表记录（级联删除），工号/学号会释放。如仍报错，检查数据库中是否有残留的 `users` 记录。
