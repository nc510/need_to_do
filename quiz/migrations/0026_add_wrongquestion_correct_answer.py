from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('quiz', '0025_auto_20260602_1705'),
    ]

    operations = [
        migrations.AddField(
            model_name='wrongquestion',
            name='correct_answer',
            field=models.CharField(blank=True, max_length=10, null=True, verbose_name='正确答案'),
        ),
    ]
