# 贡献指南

感谢你对本项目的关注！我们欢迎任何形式的贡献。

## 如何贡献

### 报告 Bug

1. 在 [Issues](https://github.com/Linx-28/EducationalAdministrationSystem/issues) 页面搜索是否已有相同问题
2. 如果没有，点击 "New Issue" 并选择 "Bug 报告" 模板
3. 填写详细信息，包括复现步骤、环境信息等

### 提交功能建议

1. 在 Issues 页面搜索是否已有相同建议
2. 如果没有，点击 "New Issue" 并选择 "功能请求" 模板
3. 描述你期望的功能和使用场景

### 提交代码

1. Fork 本仓库
2. 创建你的特性分支：`git checkout -b feature/your-feature`
3. 提交你的更改：`git commit -m 'feat: add some feature'`
4. 推送到分支：`git push origin feature/your-feature`
5. 创建一个 Pull Request

## 开发环境

### 环境要求

- JDK 8+
- Tomcat 9.0+
- MySQL 8.0+

### 本地运行

1. 克隆仓库：`git clone https://github.com/Linx-28/EducationalAdministrationSystem.git`
2. 导入到 IDE（推荐 IntelliJ IDEA）
3. 配置 Tomcat 服务器
4. 导入数据库：`mysql -u root -p < sql/init.sql`
5. 修改 `src/db.properties` 中的数据库连接信息
6. 启动项目

## 代码规范

### Java 代码

- 遵循 Java 命名规范
- 使用有意义的变量名和方法名
- 添加必要的注释

### 提交信息

使用 [Conventional Commits](https://www.conventionalcommits.org/) 规范：

- `feat:` 新功能
- `fix:` 修复 Bug
- `docs:` 文档更新
- `style:` 代码格式（不影响代码运行的变更）
- `refactor:` 重构（既不修复 Bug 也不添加功能）
- `test:` 添加测试
- `chore:` 构建过程或辅助工具的变动

## 行为准则

请遵循我们的 [行为准则](CODE_OF_CONDUCT.md)。

## 问题

如有任何问题，请通过 Issues 联系我们。
