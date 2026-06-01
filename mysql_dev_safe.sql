-- ==============================================================================
-- MySQL 开发端安全账号配置（VPN 环境版本）
-- ==============================================================================
-- 适用场景：
--   - 开发端通过 VPN 连接服务器
--   - 服务器 MySQL 绑定内网 IP: 192.168.77.253
--   - 开发端 VPN IP 可能是: 172.16.x.x 或其他网段
-- ==============================================================================

-- ==============================================================================
-- 第1部分：安全的开发端账号（禁止 DDL）
-- ==============================================================================

-- 允许 172.16.x.x (VPN) 和 192.168.77.x (内网) 两个网段
CREATE USER IF NOT EXISTS 'dev_dml'@'172.16.%' IDENTIFIED BY 'DevDML123456!';
CREATE USER IF NOT EXISTS 'dev_dml'@'192.168.77.%' IDENTIFIED BY 'DevDML123456!';

-- 授予 DML 权限（禁止 DDL）
GRANT SELECT, INSERT, UPDATE, DELETE ON need_to_do.* TO 'dev_dml'@'172.16.%';
GRANT SELECT, INSERT, UPDATE, DELETE ON need_to_do.* TO 'dev_dml'@'192.168.77.%';

-- 授予查看所有数据库的权限（方便管理工具）
GRANT SHOW DATABASES ON *.* TO 'dev_dml'@'172.16.%';
GRANT SHOW DATABASES ON *.* TO 'dev_dml'@'192.168.77.%';

-- ==============================================================================
-- 第2部分：测试环境账号
-- ==============================================================================

-- 创建测试库
CREATE DATABASE IF NOT EXISTS need_to_do_test
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

-- 创建测试账号
CREATE USER IF NOT EXISTS 'dev_test'@'172.16.%' IDENTIFIED BY 'DevTest123456!';
CREATE USER IF NOT EXISTS 'dev_test'@'192.168.77.%' IDENTIFIED BY 'DevTest123456!';

-- 授予测试库的所有权限（开发端可以自由操作测试库）
GRANT ALL PRIVILEGES ON need_to_do_test.* TO 'dev_test'@'172.16.%';
GRANT ALL PRIVILEGES ON need_to_do_test.* TO 'dev_test'@'192.168.77.%';

-- 授予正式库只读权限（测试环境可以对比正式数据）
GRANT SELECT ON need_to_do.* TO 'dev_test'@'172.16.%';
GRANT SELECT ON need_to_do.* TO 'dev_test'@'192.168.77.%';

-- ==============================================================================
-- 第3部分：刷新权限
-- ==============================================================================
FLUSH PRIVILEGES;

-- ==============================================================================
-- 验证结果
-- ==============================================================================
SELECT user, host, Select_priv, Insert_priv, Update_priv, Delete_priv
FROM mysql.user
WHERE user IN ('dev_dml', 'dev_test');

-- ==============================================================================
-- 使用说明：
-- ==============================================================================
-- 开发端配置：
--   - 正式环境：dev_dml / DevDML123456! (192.168.77.253:3306)
--   - 测试环境：dev_test / DevTest123456! (192.168.77.253:3306)
--
-- 权限说明：
--   dev_dml: SELECT, INSERT, UPDATE, DELETE（禁止 DDL）
--   dev_test: need_to_do_test 的 ALL + need_to_do 的 SELECT
--
-- IP 网段：
--   - 172.16.% : VPN 分配的开发端 IP
--   - 192.168.77.% : 内网服务器 IP
--
-- 表结构变更：
--   所有表结构变更必须通过 quiz/migrations/ 脚本管理
--   开发端执行：python manage.py migrate
-- ==============================================================================
