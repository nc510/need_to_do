from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('quiz', '0026_add_wrongquestion_correct_answer'),
    ]

    operations = [
        migrations.AddField(
            model_name='profile',
            name='total_score',
            field=models.IntegerField(default=0, verbose_name='总得分'),
        ),
        migrations.AddField(
            model_name='profile',
            name='tests_taken',
            field=models.IntegerField(default=0, verbose_name='答题次数'),
        ),
        migrations.AddField(
            model_name='profile',
            name='accuracy_rate',
            field=models.FloatField(default=0.0, verbose_name='正确率'),
        ),
    ]
