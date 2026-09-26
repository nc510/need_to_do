# 数据库驱动改用 mysqlclient（Django 官方推荐的 MySQL 驱动），
# 因此不再需要 pymysql 的 install_as_MySQLdb 兼容层。
#
# 回滚到 pymysql 的步骤（两步）：
#   1) pip install pymysql==1.1.1，并把 requirements.txt 的 mysqlclient 换回 pymysql
#   2) 在本文件恢复以下两行：
#        import pymysql
#        pymysql.install_as_MySQLdb()
