# 错题本消除机制优化：新增「连续答对次数」字段
# 规则：答对 +1，答错 -1（最低 0），连续答对达到 MASTERY_STREAK_REQUIRED(2) 次才移出错题本

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('quiz', '0036_repair_classassignment_columns'),
    ]

    operations = [
        migrations.AddField(
            model_name='wrongquestion',
            name='correct_streak',
            field=models.PositiveIntegerField(default=0, verbose_name='连续答对次数'),
        ),
    ]
