from django.db import migrations

# 合规调整：套餐名称去除「会员」字样
RENAME_MAP = {
    '月会员': '壹月高级功能',
    '年会员': '壹年高级功能',
}


def rename_forward(apps, schema_editor):
    Plan = apps.get_model('membership', 'Plan')
    for old_name, new_name in RENAME_MAP.items():
        Plan.objects.filter(name=old_name).update(name=new_name)


def rename_backward(apps, schema_editor):
    Plan = apps.get_model('membership', 'Plan')
    for old_name, new_name in RENAME_MAP.items():
        Plan.objects.filter(name=new_name).update(name=old_name)


class Migration(migrations.Migration):

    dependencies = [
        ('membership', '0004_auto_20260926_0117'),
    ]

    operations = [
        migrations.RunPython(rename_forward, rename_backward),
    ]
