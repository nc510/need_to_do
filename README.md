# 在线考试系统

一个基于 Django 的在线考试系统，支持试卷管理、班级管理、在线答题等功能。

## 功能特性

- 📝 **试卷管理**：创建、编辑、发布试卷
- 📚 **题库管理**：支持单选题、多选题、判断题
- 🏫 **班级管理**：创建班级、管理学生、发布作业
- 📊 **答题统计**：查看答题记录和成绩分析
- 📱 **响应式设计**：支持桌面端和移动端访问

## 技术栈

- **后端**：Django 3.2
- **数据库**：MySQL
- **前端**：HTML5 + CSS3 + JavaScript
- **管理后台**：Django SimpleUI

## 快速开始

### 环境要求

- Python 3.8+
- MySQL 5.7+
- pip

### 安装步骤

1. **克隆项目**
   ```bash
   git clone <repository-url>
   cd need_to_do
   ```

2. **配置环境变量**
   ```bash
   # 复制环境变量模板
   cp .env.production.example .env
   
   # 编辑 .env 文件，配置数据库连接等信息
   ```

3. **安装依赖**
   ```bash
   # Windows
   deploy.bat
   
   # Linux/Mac
   chmod +x deploy.sh
   ./deploy.sh
   ```

4. **启动服务**
   ```bash
   python run.py
   ```

5. **访问系统**
   - 首页：http://localhost:8090/quiz/test_paper_list/
   - 管理后台：http://localhost:8090/admin/

## 项目结构

```
need_to_do/
├── quiz/                      # 应用模块
│   ├── __init__.py
│   ├── admin.py              # 后台管理配置
│   ├── apps.py
│   ├── models.py             # 数据模型
│   ├── views.py              # 视图函数
│   ├── urls.py               # URL配置
│   ├── utils.py              # 工具函数
│   ├── tests.py              # 测试文件
│   └── templates/            # 前端模板
├── need_to_do/               # 项目配置
│   ├── __init__.py
│   ├── asgi.py
│   ├── settings.py           # 项目配置
│   ├── urls.py               # 根URL配置
│   └── wsgi.py
├── .env                      # 环境变量（不上Git）
├── .env.production.example   # 生产环境配置示例
├── .gitignore               # Git忽略配置
├── requirements.txt         # 依赖清单
├── run.py                   # 启动脚本
├── deploy.bat               # Windows部署脚本
├── deploy.sh                # Linux/Mac部署脚本
└── manage.py                # Django管理命令
```

## 配置说明

### 环境变量（.env）

| 变量名 | 说明 | 默认值 |
|--------|------|--------|
| DJANGO_SECRET_KEY | Django密钥 | - |
| DJANGO_DEBUG | 调试模式 | False |
| DJANGO_ALLOWED_HOSTS | 允许的主机 | * |
| DB_NAME | 数据库名 | need_to_do |
| DB_USER | 数据库用户名 | root |
| DB_PASSWORD | 数据库密码 | - |
| DB_HOST | 数据库主机 | 127.0.0.1 |
| DB_PORT | 数据库端口 | 3306 |

## 生产环境部署建议

1. **使用 HTTPS**：配置 SSL 证书
2. **关闭 DEBUG**：设置 DJANGO_DEBUG=False
3. **使用 Redis 缓存**：提高性能
4. **配置反向代理**：使用 Nginx
5. **定期备份数据库**：确保数据安全

## 许可证

MIT License