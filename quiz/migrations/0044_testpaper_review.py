from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):
    """试卷发布审核：前台创建的试卷提交发布后需管理员审核通过才进入全站列表。

    review_status 默认 1（审核通过），使历史试卷与后台创建的试卷不受影响；
    前台提交发布时由代码显式置为 0（待审核）。
    """

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('quiz', '0043_testpaper_is_wrong_paper'),
    ]

    operations = [
        migrations.AddField(
            model_name='testpaper',
            name='review_status',
            field=models.IntegerField(
                choices=[(0, '待审核'), (1, '审核通过'), (2, '审核驳回')],
                db_index=True, default=1,
                help_text='前台试卷提交发布后为「待审核」，管理员审核通过后才会出现在全站试卷列表',
                verbose_name='审核状态'),
        ),
        migrations.AddField(
            model_name='testpaper',
            name='review_remark',
            field=models.TextField(
                blank=True, default='',
                help_text='驳回时填写的原因，会展示给试卷创建者',
                verbose_name='审核备注'),
        ),
        migrations.AddField(
            model_name='testpaper',
            name='reviewed_at',
            field=models.DateTimeField(blank=True, null=True, verbose_name='审核时间'),
        ),
        migrations.AddField(
            model_name='testpaper',
            name='reviewed_by',
            field=models.ForeignKey(
                blank=True, null=True,
                on_delete=django.db.models.deletion.SET_NULL,
                related_name='reviewed_test_papers',
                to=settings.AUTH_USER_MODEL, verbose_name='审核人'),
        ),
    ]
