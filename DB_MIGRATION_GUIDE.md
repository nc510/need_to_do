# 📚 数据库变更管理规范

## 🎯 目标

确保开发端和服务器端的数据库变更安全、可追溯、可回滚。

---

## 📋 变更类型分类

| 类型 | 操作 | 开发端权限 | 服务器端权限 |
|------|------|-----------|-------------|
| **DML** | SELECT/INSERT/UPDATE/DELETE | ✅ 允许 | ✅ 允许 |
| **DDL** | CREATE/ALTER/DROP/TRUNCATE | ❌ 禁止 | ✅ 允许 |
| **DCL** | GRANT/REVOKE | ❌ 禁止 | ✅ 允许 |

---

## 🛡️ 权限配置

### 开发端账号（已安全配置）

| 账号 | 密码 | 权限 | 用途 |
|------|------|------|------|
| `dev_dml` | DevDML123456! | SELECT/INSERT/UPDATE/DELETE | 正式环境开发 |
| `dev_test` | DevTest123456! | ALL (仅测试库) | 测试环境 |

### 服务器端账号

| 账号 | 权限 | 用途 |
|------|------|------|
| `root` | ALL | 服务器管理 |

---

## 🔄 表结构变更流程

### ✅ 正确流程

```
1. 开发端修改 models.py
2. 生成迁移脚本：python manage.py makemigrations
3. 提交迁移脚本到 Git
4. 服务器端拉取代码
5. 服务器端执行：python manage.py migrate
```

### ❌ 错误操作

```sql
-- 开发端禁止执行：
ALTER TABLE ...
CREATE TABLE ...
DROP TABLE ...
TRUNCATE TABLE ...
```

---

## 🧪 测试环境使用

### 连接测试库

```ini
# .env 配置
DB_NAME=need_to_do_test
DB_USER=dev_test
DB_PASSWORD=DevTest123456!
```

### 测试流程

1. 在测试库验证功能
2. 确认无误后再在正式库操作
3. 使用数据对比工具验证

---

## 📁 迁移脚本管理

### 必须进 Git 的文件

```
quiz/migrations/
├── 0001_initial.py
├── 0002_xxx.py
├── ...
└── __init__.py
```

### 迁移命令

```bash
# 生成迁移脚本
python manage.py makemigrations

# 查看待执行迁移
python manage.py showmigrations

# 执行迁移
python manage.py migrate

# 回滚迁移
python manage.py migrate quiz 0001_initial
```

---

## ⚠️ 注意事项

1. **禁止开发端执行 DDL** - 表结构变更必须通过迁移脚本
2. **测试环境优先** - 新功能先在测试库验证
3. **数据备份** - 重要操作前先备份
4. **权限最小化** - 只授予必要的权限

---

## 🚨 应急处理

### 误删数据恢复

```bash
# 1. 检查binlog
mysqlbinlog --start-datetime="2024-01-01 00:00:00" mysql-bin.000001 > recovery.sql

# 2. 恢复数据
mysql -u root -p need_to_do < recovery.sql
```

### 误执行 DDL 恢复

1. 使用最近的全量备份恢复
2. 重新执行后续的迁移脚本
3. 补回备份后的数据变更
