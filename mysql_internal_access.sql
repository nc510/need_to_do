-- MySQL内网访问账号配置脚本
-- 执行方式: mysql -u root -p < mysql_internal_access.sql
-- 或者直接在Navicat/命令行执行

-- 创建专门用于内网开发的账号
CREATE USER 'dev_user'@'192.168.77.%' IDENTIFIED BY 'DevPass123456!';

-- 授予need_to_do数据库的所有权限
GRANT ALL PRIVILEGES ON need_to_do.* TO 'dev_user'@'192.168.77.%';

-- 授予查看所有数据库的权限（方便管理）
GRANT SHOW DATABASES ON *.* TO 'dev_user'@'192.168.77.%';

-- 刷新权限
FLUSH PRIVILEGES;

-- 验证结果
SELECT user, host FROM mysql.user WHERE user='dev_user';
