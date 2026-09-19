from django.db import migrations, models


def mark_legacy_wrong_papers(apps, schema_editor):
    """回填历史错题组卷试卷标记。

    该字段此前不存在，历史数据只能按特征识别：
    1) 存在 is_wrong_paper=True 的答题记录指向的试卷（最可靠）；
    2) 标题与描述均为「错题巩固试卷」且从未发布的试卷（错题组卷创建时的固定特征）。
    """
    TestPaper = apps.get_model('quiz', 'TestPaper')
    TestRecord = apps.get_model('quiz', 'TestRecord')

    record_paper_ids = list(
        TestRecord.objects.filter(
            is_wrong_paper=True, test_paper__isnull=False
        ).values_list('test_paper_id', flat=True)
    )
    if record_paper_ids:
        TestPaper.objects.filter(pk__in=record_paper_ids).update(is_wrong_paper=True)

    TestPaper.objects.filter(
        is_published=False,
        title='错题巩固试卷',
        description='错题巩固试卷',
    ).update(is_wrong_paper=True)


def unmark_wrong_papers(apps, schema_editor):
    TestPaper = apps.get_model('quiz', 'TestPaper')
    TestPaper.objects.filter(is_wrong_paper=True).update(is_wrong_paper=False)


class Migration(migrations.Migration):

    dependencies = [
        ('quiz', '0042_profile_last_seen_at'),
    ]

    operations = [
        migrations.AddField(
            model_name='testpaper',
            name='is_wrong_paper',
            field=models.BooleanField(db_index=True, default=False, verbose_name='是否错题组卷'),
        ),
        migrations.RunPython(mark_legacy_wrong_papers, unmark_wrong_papers),
    ]
