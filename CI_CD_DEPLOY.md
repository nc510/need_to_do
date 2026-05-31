# 🚀 Railway + GitHub Actions CI/CD 部署指南

## 📋 目录

1. [准备工作](#准备工作)
2. [Railway 部署步骤](#railway-部署步骤)
3. [GitHub Actions CI/CD 配置](#github-actions-cicd-配置)
4. [环境变量配置](#环境变量配置)
5. [常见问题解决](#常见问题解决)

---

## 准备工作

### 1. 确保代码已推送到 GitHub

```bash
# 检查当前状态
git status

# 添加所有更改
git add .

# 提交
git commit -m "配置 CI/CD 部署"

# 推送到 GitHub
git push origin main
```

### 2. 确认仓库地址

您的仓库地址应该是：`https://github.com/nc510/need_to_do`

---

## Railway 部署步骤

### 步骤 1：创建 Railway 项目

1. 访问 [Railway.app](https://railway.app)
2. 点击 **"New Project"**
3. 选择 **"Deploy from GitHub repo"**
4. 选择仓库 `nc510/need_to_do`
5. 点击 **"Deploy now"**

### 步骤 2：添加 PostgreSQL 数据库

1. 在 Railway 项目页面，点击 **"Add Service"**
2. 选择 **"Database"** → **"PostgreSQL"**
3. 等待数据库创建完成（约 1-2 分钟）
4. Railway 会自动设置 `DATABASE_URL` 环境变量

### 步骤 3：配置环境变量

在 Railway 项目 → **Settings** → **Variables** 中添加：

| 变量名 | 值 | 说明 |
|--------|-----|------|
| `DJANGO_SECRET_KEY` | 使用下方命令生成 | Django 安全密钥 |
| `DJANGO_DEBUG` | `False` | 关闭调试模式 |
| `DJANGO_ALLOWED_HOSTS` | `.railway.app` | 允许的域名 |
| `PYTHON_VERSION` | `3.10` | Python 版本 |

生成 SECRET_KEY：
```bash
# Linux/Mac
openssl rand -hex 32

# Windows PowerShell
[Convert]::ToBase64String((1..32 | ForEach-Object { Get-Random -Maximum 256 }))
```

### 步骤 4：连接数据库

Railway 会自动将 PostgreSQL 服务与 Django 服务连接。确保：
- Django 服务和 PostgreSQL 服务在同一个项目中
- `DATABASE_URL` 环境变量已自动设置

### 步骤 5：触发部署

1. 点击 **"Deploy"** 按钮
2. 查看部署日志
3. 等待部署完成（约 3-5 分钟）

### 步骤 6：获取应用 URL

部署成功后，Railway 会分配一个域名：
```
https://your-app.up.railway.app
```

访问测试：
```
https://your-app.up.railway.app/quiz/test_paper_list/
```

---

## GitHub Actions CI/CD 配置

### 工作流程说明

已创建的 CI/CD 流程包含三个阶段：

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   测试代码   │ -> │  部署到     │ -> │  验证部署   │
│   (test)    │    │  Railway    │    │  (verify)   │
└─────────────┘    └─────────────┘    └─────────────┘
```

**触发条件：**
- Push 到 `main` 或 `master` 分支
- Pull Request 到 `main` 或 `master` 分支
- 手动触发（workflow_dispatch）

**测试阶段：**
- 安装依赖
- 代码检查 (flake8)
- Django 部署检查
- 迁移文件检查

**部署阶段：**
- 仅在测试通过后执行
- 使用 Railway CLI 部署
- 自动应用最新代码

**验证阶段：**
- 等待服务启动
- 健康检查
- 发送部署通知

### 配置 GitHub Secrets

在 GitHub 仓库设置中添加以下 Secrets：

**路径：** `Settings` → `Secrets and variables` → `Actions` → `New repository secret`

| Secret 名称 | 值 | 获取方式 |
|-------------|-----|----------|
| `RAILWAY_TOKEN` | Railway API Token | 见下方步骤 |
| `RAILWAY_SERVICE_ID` | 服务 ID | 见下方步骤 |
| `RAILWAY_APP_URL` | 应用 URL | `https://your-app.up.railway.app` |

#### 获取 RAILWAY_TOKEN

1. 访问 [Railway Account Settings](https://railway.app/account)
2. 点击 **"Generate Token"**
3. 复制生成的 Token

#### 获取 RAILWAY_SERVICE_ID

```bash
# 安装 Railway CLI
npm install -g @railway/cli

# 登录
railway login

# 列出项目
railway list

# 进入项目
railway link

# 查看服务信息
railway status
```

服务 ID 格式类似：`svc-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`

---

## 环境变量配置

### Railway 环境变量（必需）

| 变量 | 值 | 说明 |
|------|-----|------|
| `DJANGO_SECRET_KEY` | 64位随机字符串 | **必须设置** |
| `DJANGO_DEBUG` | `False` | 生产环境必须关闭 |
| `DJANGO_ALLOWED_HOSTS` | `.railway.app` | 允许 Railway 域名 |
| `DATABASE_URL` | 自动设置 | PostgreSQL 连接 |
| `PYTHON_VERSION` | `3.10` | Python 版本 |

### 可选环境变量

| 变量 | 值 | 说明 |
|------|-----|------|
| `WEB_CONCURRENCY` | `4` | Worker 数量 |
| `PORT` | 自动设置 | Railway 自动分配 |

---

## 常见问题解决

### 问题 1：部署失败 - 收集静态文件错误

**解决方案：**
确保 `staticfiles` 目录存在：
```bash
mkdir staticfiles
```

### 问题 2：数据库连接失败

**检查步骤：**
1. 确认 PostgreSQL 服务已创建
2. 确认 `DATABASE_URL` 环境变量已设置
3. 查看部署日志中的数据库连接信息

### 问题 3：500 错误

**排查方法：**
1. 检查 `DJANGO_SECRET_KEY` 是否设置
2. 检查 `DJANGO_DEBUG` 是否为 `False`
3. 检查 `DJANGO_ALLOWED_HOSTS` 是否包含 `.railway.app`

### 问题 4：CI/CD 部署失败

**检查步骤：**
1. 确认 GitHub Secrets 已正确设置
2. 确认 Railway Token 有效
3. 查看 GitHub Actions 日志

---

## 📊 部署状态监控

### Railway Dashboard

- 查看实时日志：Railway 项目 → Deployments → 点击部署 → Logs
- 查看资源使用：Railway 项目 → Settings → Metrics

### GitHub Actions

- 查看运行状态：GitHub 仓库 → Actions 标签页
- 查看历史记录：每次部署都有详细日志

---

## 🔧 手动操作命令

### Railway CLI 常用命令

```bash
# 安装 CLI
npm install -g @railway/cli

# 登录
railway login

# 链接项目
railway link

# 查看状态
railway status

# 查看日志
railway logs

# 手动部署
railway up

# 打开应用
railway open
```

### Django 管理命令

```bash
# 创建超级用户（需要在 Railway 终端执行）
railway run python manage.py createsuperuser

# 执行迁移
railway run python manage.py migrate

# 收集静态文件
railway run python manage.py collectstatic
```

---

## ✅ 部署检查清单

- [ ] 代码已推送到 GitHub
- [ ] Railway 项目已创建
- [ ] PostgreSQL 数据库已添加
- [ ] 环境变量已配置
- [ ] 部署成功
- [ ] 应用可正常访问
- [ ] GitHub Secrets 已配置
- [ ] CI/CD 流程测试通过

---

## 📞 需要帮助？

如果遇到问题：
1. 查看 Railway 部署日志
2. 查看 GitHub Actions 日志
3. 检查环境变量配置
4. 参考本文档的常见问题部分