from django.db import models

class Question(models.Model):
    # 题目类型：1-选择题，2-判断题
    TYPE_CHOICE = (1, '选择题'), (2, '判断题')
    type = models.IntegerField(choices=TYPE_CHOICE, verbose_name='题目类型')
    content = models.TextField(verbose_name='题目内容')
    options = models.JSONField(verbose_name='选项', null=True, blank=True, help_text='选择题选项，格式：{"A":"选项内容","B":"选项内容"}')
    correct_answer = models.CharField(max_length=10, verbose_name='正确答案')
    score = models.IntegerField(verbose_name='分值', default=1)
    explanation = models.TextField(verbose_name='解析', null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    updated_at = models.DateTimeField(auto_now=True, verbose_name='更新时间')

    class Meta:
        verbose_name = '题目'
        verbose_name_plural = '题目'
        ordering = ['-created_at']

    def __str__(self):
        return self.content
