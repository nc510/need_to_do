"""每日登录赠礼改为按自然日幂等发放（支持「当天首次访问页面」补发）。

新增 StarLoginStreak.last_gift_date 作为「赠礼当天已发」的依据。
回填为 last_login_date：这些用户的赠礼在登录时已按旧逻辑发过，
回填可避免上线当天被页面访问逻辑再补发一次。
"""

from django.db import migrations, models


def backfill_last_gift_date(apps, schema_editor):
    star_login_streak = apps.get_model('starcoin', 'StarLoginStreak')
    star_login_streak.objects.exclude(last_login_date__isnull=True).update(
        last_gift_date=models.F('last_login_date'))


def reset_last_gift_date(apps, schema_editor):
    apps.get_model('starcoin', 'StarLoginStreak').objects.update(last_gift_date=None)


class Migration(migrations.Migration):

    dependencies = [
        ('starcoin', '0008_starwrongpaperconfig'),
    ]

    operations = [
        migrations.AddField(
            model_name='starloginstreak',
            name='last_gift_date',
            field=models.DateField(blank=True, help_text='每日登录赠礼的发放日期（当天已发过一次就不再发）', null=True, verbose_name='赠礼发放日期'),
        ),
        migrations.RunPython(backfill_last_gift_date, reset_last_gift_date),
    ]
