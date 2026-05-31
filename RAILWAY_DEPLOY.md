# 🚀 Railway 部署指南

## 快速部署步骤

### 1. 准备工作

确保代码已推送到 GitHub:
```bash
git add .
git commit -m "配置Railway部署"
git push
```

### 2. 在 Railway 创建项目

1. 访问 https://railway.app
2. 点击 "New Project" → "Deploy from repo"
3. 选择你的仓库 `nc510/need_to_do`
4. 点击 "Deploy now"

### 3. 添加 PostgreSQL 数据库

1. 在 Railway 项目中，点击 "Add Service" → "Database" → "PostgreSQL"
2. 等待数据库创建完成

### 4. 配置环境变量

在 Railway 项目 → Settings → Variables 中添加:

| 变量名 | 值 | 说明 |
|--------|-----|------|
| `DJANGO_SECRET_KEY` | 随机生成的密钥 | 可以用 `openssl rand -hex 32` 生成 |
| `DJANGO_DEBUG` | `False` | 生产环境关闭调试 |
| `DJANGO_ALLOWED_HOSTS` | `.railway.app` | 允许的域名 |
| `PYTHON_VERSION` | `3.10` | Python版本 |

### 5. 部署

1. 推送代码到 GitHub 将自动触发部署
2. 或在 Railway 手动触发重新部署

### 6. 访问网站

部署成功后，在 Railway 项目首页会显示分配的域名:
```
https://your-app.railway.app
```

---

## 📱 手机继续开发

### 方法1: 使用 GitHub Codespaces (推荐)

1. 访问 https://github.com/codespaces
2. 点击 "New codespace"
3. 选择你的仓库
4. 在浏览器中编辑代码
5. 提交修改自动部署

### 方法2: 使用 Git

```bash
# 克隆代码
git clone git@github.com:nc510/need_to_do.git
cd need_to_do

# 修改代码
# ...

# 提交并推送
git add .
git commit -m "你的提交信息"
git push
```

---

## 📋 已创建的配置文件

| 文件 | 作用 |
|------|------|
| `Procfile` | Railway 进程配置 |
| `railway.json` | Railway 项目配置 |
| `requirements.txt` | 添加了 `whitenoise` 和 `dj-database-url` |
| `need_to_do/settings.py` | 配置了 Railway 数据库和静态文件 |

---

## 🛠️ 本地开发与生产切换

项目会自动检测运行环境:

- **Railway 生产**: 使用 PostgreSQL + Whitenoise
- **本地开发**: 使用 MySQL + 本地配置

---

## ⚠️ 注意事项

1. **SECRET_KEY**: 生产环境务必使用安全的密钥
2. **数据库备份**: 定期在 Railway 备份数据库
3. **静态文件**: Whitenoise 已配置，无需额外CDN

---

## 📞 需要帮助？

如果部署遇到问题，检查 Railway 的 Deploy Logs。
