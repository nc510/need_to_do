# 修复迁移（2026-09-16）：
# 全新数据库执行完 0035 后，quiz_classassignment 表缺少 is_allow_exam / is_random / random_config 三列，
# 原因是 0028、0032 用的是 SeparateDatabaseAndState（当时线上库这三列已存在，只补 ORM state 不动 DB），
# 导致新环境部署后 ORM 插入/查询这三列直接报错（MySQL 1054 / 1364）。
# 本迁移幂等：先查表结构，列缺失才补；列已存在则完全不碰数据库，可在老库安全执行。
# 注：MySQL 5.7 的 ALTER TABLE 不支持 ADD COLUMN IF NOT EXISTS，因此必须先用 information_schema 判断。

from django.db import migrations

TABLE = 'quiz_classassignment'

# 各列按模型定义：BooleanField(default=True) / BooleanField(default=False) / JSONField(default=dict)
COLUMN_TYPES = {
    'is_allow_exam': {
        'mysql': 'tinyint(1) NOT NULL DEFAULT 1',
        'sqlite': 'bool NOT NULL DEFAULT 1',
    },
    'is_random': {
        'mysql': 'tinyint(1) NOT NULL DEFAULT 0',
        'sqlite': 'bool NOT NULL DEFAULT 0',
    },
    # MySQL 5.7 的 JSON 列不支持默认值，非空表无法加 NOT NULL 列，故允许 NULL（ORM 侧始终写入 {}）
    'random_config': {
        'mysql': 'json NULL',
        'sqlite': 'text NULL',
    },
}


def add_missing_columns(apps, schema_editor):
    connection = schema_editor.connection
    vendor = connection.vendor
    if vendor not in ('mysql', 'sqlite'):
        return
    with connection.cursor() as cursor:
        if TABLE not in connection.introspection.table_names(cursor):
            return
        existing = {col.name for col in connection.introspection.get_table_description(cursor, TABLE)}
    for name, types in COLUMN_TYPES.items():
        if name in existing:
            continue
        with connection.cursor() as cursor:
            cursor.execute(f'ALTER TABLE {TABLE} ADD COLUMN {name} {types[vendor]}')


class Migration(migrations.Migration):

    dependencies = [
        ('quiz', '0035_profile_plain_password'),
    ]

    operations = [
        # 只补数据库结构，ORM state 已由 0028 / 0032 定义，无需再改 state
        migrations.RunPython(add_missing_columns, reverse_code=migrations.RunPython.noop),
    ]
