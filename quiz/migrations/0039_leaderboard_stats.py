# 榜单功能（斩题榜 / 得分榜 / 正确率榜）：
# 1) 新增 ConqueredQuestion 表，记录「答对且去重」的斩获题目；
# 2) Profile 增加斩题数 / 累计作答题次 / 累计答对题次的冗余计数，供榜单排序直接查单表；
# 3) 回填历史数据，避免榜单上线时历史作答全部为空。

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion
from django.db.models import Count, Q


def backfill_leaderboard_stats(apps, schema_editor):
    AnswerRecord = apps.get_model('quiz', 'AnswerRecord')
    ConqueredQuestion = apps.get_model('quiz', 'ConqueredQuestion')
    Profile = apps.get_model('quiz', 'Profile')

    # 1) 已斩获题目：历史答对记录去重后写入（同一题答对多次只保留一条）
    # 注意：AnswerRecord.Meta.ordering 会被带进 SELECT DISTINCT，
    # 必须先 order_by() 清空排序，否则 (user, question) 仍会出现重复行。
    batch = []
    rows = (AnswerRecord.objects.filter(is_correct=True)
            .order_by()
            .values_list('test_record__user_id', 'question_id').distinct())
    for user_id, question_id in rows.iterator(chunk_size=2000):
        batch.append(ConqueredQuestion(user_id=user_id, question_id=question_id))
        if len(batch) >= 1000:
            ConqueredQuestion.objects.bulk_create(batch, ignore_conflicts=True)
            batch = []
    if batch:
        ConqueredQuestion.objects.bulk_create(batch, ignore_conflicts=True)

    # 2) 每人作答题次 / 答对题次（未作答的题不计入作答题次）
    # 同样要 order_by() 清空 Meta.ordering，否则排序字段会进入 GROUP BY 导致分组错乱
    answered = {
        row['test_record__user_id']: row
        for row in AnswerRecord.objects.order_by().values('test_record__user_id').annotate(
            total=Count('id', filter=Q(user_answer__isnull=False) & ~Q(user_answer='')),
            correct=Count('id', filter=Q(is_correct=True)),
        )
    }
    # 3) 每人斩题数
    conquered = {
        row['user_id']: row['cnt']
        for row in ConqueredQuestion.objects.order_by()
        .values('user_id').annotate(cnt=Count('id'))
    }

    updates = []
    for profile in Profile.objects.all().iterator(chunk_size=500):
        row = answered.get(profile.user_id) or {}
        profile.answered_total = row.get('total', 0)
        profile.answered_correct = row.get('correct', 0)
        profile.conquered_count = conquered.get(profile.user_id, 0)
        updates.append(profile)
        if len(updates) >= 500:
            Profile.objects.bulk_update(
                updates, ['answered_total', 'answered_correct', 'conquered_count'])
            updates = []
    if updates:
        Profile.objects.bulk_update(
            updates, ['answered_total', 'answered_correct', 'conquered_count'])


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('quiz', '0038_testrecord_duration_seconds'),
    ]

    operations = [
        migrations.AddField(
            model_name='profile',
            name='answered_correct',
            field=models.PositiveIntegerField(default=0, verbose_name='累计答对题次'),
        ),
        migrations.AddField(
            model_name='profile',
            name='answered_total',
            field=models.PositiveIntegerField(default=0, verbose_name='累计作答题次'),
        ),
        migrations.AddField(
            model_name='profile',
            name='conquered_count',
            field=models.PositiveIntegerField(default=0, verbose_name='斩题数'),
        ),
        migrations.CreateModel(
            name='ConqueredQuestion',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('first_correct_at', models.DateTimeField(auto_now_add=True, verbose_name='首次答对时间')),
                ('question', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='quiz.question', verbose_name='题目')),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL, verbose_name='用户')),
            ],
            options={
                'verbose_name': '已斩获题目',
                'verbose_name_plural': '已斩获题目',
                'ordering': ['-first_correct_at'],
                'unique_together': {('user', 'question')},
            },
        ),
        migrations.RunPython(backfill_leaderboard_stats, migrations.RunPython.noop),
    ]
