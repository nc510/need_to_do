from django.db import models
from django.contrib.auth.models import User
from django.db.models.signals import post_save, post_delete, m2m_changed
from django.dispatch import receiver
from django.core.cache import cache

# 学科模型
class Subject(models.Model):
    name = models.CharField(max_length=50, verbose_name='学科名称', unique=True)
    code = models.CharField(max_length=10, verbose_name='学科代码', unique=True, help_text='如 MATH, CHINESE')
    description = models.TextField(verbose_name='学科描述', blank=True, null=True)
    color = models.CharField(max_length=7, verbose_name='学科颜色', default='#667eea', help_text='十六进制颜色值')
    icon = models.CharField(max_length=50, verbose_name='学科图标', default='📚', help_text='Emoji图标')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    
    class Meta:
        verbose_name = '学科'
        verbose_name_plural = '学科'
        ordering = ['name']
    
    def __str__(self):
        return f'{self.icon} {self.name}'

# 章节模型
class Chapter(models.Model):
    subject = models.ForeignKey(Subject, on_delete=models.CASCADE, verbose_name='所属学科', related_name='chapters')
    number = models.IntegerField(verbose_name='章节编号')
    title = models.CharField(max_length=100, verbose_name='章节标题')
    description = models.TextField(verbose_name='章节描述', blank=True, null=True)
    
    class Meta:
        verbose_name = '章节'
        verbose_name_plural = '章节'
        unique_together = ('subject', 'number')
        ordering = ['subject', 'number']
    
    def __str__(self):
        return f'{self.subject.name} - 第{self.number}章 {self.title}'
    
    @property
    def full_number(self):
        return str(self.number)

# 小节模型
class Section(models.Model):
    chapter = models.ForeignKey(Chapter, on_delete=models.CASCADE, verbose_name='所属章节', related_name='sections')
    number = models.IntegerField(verbose_name='小节编号')
    title = models.CharField(max_length=100, verbose_name='小节标题')
    
    class Meta:
        verbose_name = '小节'
        verbose_name_plural = '小节'
        unique_together = ('chapter', 'number')
        ordering = ['chapter', 'number']
    
    def __str__(self):
        return f'{self.chapter.title} - {self.chapter.number}.{self.number} {self.title}'
    
    @property
    def full_number(self):
        return f'{self.chapter.number}.{self.number}'

# 知识点模型
class KnowledgePoint(models.Model):
    section = models.ForeignKey(Section, on_delete=models.SET_NULL, verbose_name='所属小节', related_name='knowledge_points', blank=True, null=True)
    subject = models.ForeignKey(Subject, on_delete=models.CASCADE, verbose_name='所属学科', related_name='knowledge_points_all')
    name = models.CharField(max_length=100, verbose_name='知识点名称')
    description = models.TextField(verbose_name='知识点描述', blank=True, null=True)
    difficulty = models.IntegerField(verbose_name='难度等级', default=2, choices=[(1, '简单'), (2, '中等'), (3, '困难')])
    
    class Meta:
        verbose_name = '知识点'
        verbose_name_plural = '知识点'
        unique_together = ('subject', 'name')
        ordering = ['subject', 'name']
    
    def __str__(self):
        return f'{self.subject.name} - {self.name}'

class Question(models.Model):
    # 题目类型：1-单选题，2-多选题，3-判断题
    TYPE_CHOICE = [(1, '单选题'), (2, '多选题'), (3, '判断题')]
    type = models.IntegerField(choices=TYPE_CHOICE, verbose_name='题目类型')
    content = models.TextField(verbose_name='题目内容')
    options = models.JSONField(verbose_name='选项', default=dict, blank=True, help_text='选择题选项，格式：{"A":"选项内容","B":"选项内容"}')
    correct_answer = models.CharField(max_length=10, verbose_name='正确答案')
    score = models.IntegerField(verbose_name='分值', default=1)
    explanation = models.TextField(verbose_name='解析', null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    updated_at = models.DateTimeField(auto_now=True, verbose_name='更新时间')

    # 公开/私有标记
    is_public = models.BooleanField(verbose_name='是否公开', default=True, help_text='否表示私有题目，只有创建者和后台能看到')
    created_by = models.CharField(max_length=100, verbose_name='创建者', null=True, blank=True)

    # 新增学科分类字段
    subject = models.ForeignKey(Subject, on_delete=models.SET_NULL, verbose_name='所属学科', null=True, blank=True, related_name='questions')
    chapter = models.ForeignKey(Chapter, on_delete=models.SET_NULL, verbose_name='所属章节', null=True, blank=True, related_name='questions')
    section = models.ForeignKey(Section, on_delete=models.SET_NULL, verbose_name='所属小节', null=True, blank=True, related_name='questions')
    knowledge_points = models.ManyToManyField(KnowledgePoint, verbose_name='关联知识点', blank=True, related_name='questions')

    class Meta:
        verbose_name = '题目'
        verbose_name_plural = '题目'
        ordering = ['-created_at']

    def __str__(self):
        return self.content
    
    def as_json(self):
        return {
            'id': self.id,
            'type': self.type,
            'content': self.content,
            'options': self.options,
            'correct_answer': self.correct_answer,
            'score': self.score,
            'explanation': self.explanation
        }

class TestPaper(models.Model):
    SOURCE_CHOICES = [
        ('admin', '后台创建'),
        ('frontend', '前台创建'),
    ]
    title = models.CharField(max_length=100, verbose_name='试卷标题')
    description = models.TextField(verbose_name='试卷描述', null=True, blank=True)
    questions = models.ManyToManyField(Question, verbose_name='包含题目')
    total_score = models.IntegerField(verbose_name='总分', default=0)
    created_by = models.CharField(max_length=100, verbose_name='出题人', null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    is_published = models.BooleanField(verbose_name='是否发布', default=False)
    is_public = models.BooleanField(verbose_name='是否公开', default=True, help_text='否表示私有试卷，只有创建者和后台能看到')
    source = models.CharField(max_length=20, verbose_name='试卷来源', choices=SOURCE_CHOICES, default='frontend')
    # ===== P2-3 考试控制字段 =====
    duration = models.IntegerField(verbose_name='考试时长(分钟)', null=True, blank=True, help_text='为空表示不限时；设置后答题页显示倒计时，到时自动交卷')
    max_attempts = models.IntegerField(verbose_name='最大答题次数', null=True, blank=True, help_text='为空表示不限次数')
    start_time = models.DateTimeField(verbose_name='开放开始时间', null=True, blank=True, help_text='为空表示立即开放')
    end_time = models.DateTimeField(verbose_name='开放结束时间', null=True, blank=True, help_text='为空表示无截止')

    class Meta:
        verbose_name = '试卷'
        verbose_name_plural = '试卷'
        ordering = ['-created_at']

    def __str__(self):
        return self.title

    @property
    def is_exam_controlled(self):
        # 是否启用考试控制（限时/限次/时间窗口），供模板用短名替代超长多条件 if
        return bool(self.duration or self.max_attempts or self.start_time or self.end_time)

    def save(self, *args, **kwargs):
        # total_score 由 m2m_changed 信号和显式赋值管理，save 不自动重算
        # （避免改 title/description 等无关字段时触发全表题目查询；原实现每次 save 都重算）
        super().save(*args, **kwargs)

# 使用信号监听ManyToMany关系变化，确保添加/移除题目时更新总分
@receiver(m2m_changed, sender=TestPaper.questions.through)
def update_testpaper_total_score(sender, instance, action, **kwargs):
    # 题目增删后用 update() 更新总分（避免触发 save 再算 + 递归 save 链）
    if action in ['post_add', 'post_remove', 'post_clear']:
        total = instance.questions.aggregate(total=models.Sum('score'))['total'] or 0
        TestPaper.objects.filter(pk=instance.pk).update(total_score=total)
        instance.total_score = total  # 同步内存对象，避免后续读旧值

class Profile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, verbose_name='用户')
    name = models.CharField(max_length=50, verbose_name='姓名', blank=True, null=True)
    APPROVAL_STATUS = ((0, '未审核'), (1, '审核通过'), (2, '审核拒绝'))
    approval_status = models.IntegerField(choices=APPROVAL_STATUS, default=0, verbose_name='审核状态')
    # 用户角色：student 学生 / teacher 教师 / admin 管理员
    # 与 is_staff 组合判断权限：is_staff=True 的用户视为管理员，可访问后台题库管理
    ROLE_CHOICES = (
        ('student', '学生'),
        ('teacher', '教师'),
        ('admin', '管理员'),
    )
    role = models.CharField(max_length=10, choices=ROLE_CHOICES, default='student', verbose_name='用户角色')
    phone_number = models.CharField(max_length=11, verbose_name='手机号码', blank=True, null=True, unique=True)
    qq_number = models.CharField(max_length=20, verbose_name='QQ号码', blank=True, null=True)
    # 关联班级（允许为空，表示未分配班级）
    class_obj = models.ForeignKey('Class', on_delete=models.SET_NULL, verbose_name='所属班级', null=True, blank=True, related_name='profiles')
    # 单点登录：存储当前活跃的session_key
    session_key = models.CharField(max_length=40, verbose_name='当前会话ID', blank=True, null=True)
    total_score = models.IntegerField(default=0, verbose_name='总得分')
    tests_taken = models.IntegerField(default=0, verbose_name='答题次数')
    accuracy_rate = models.FloatField(default=0.0, verbose_name='正确率')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    updated_at = models.DateTimeField(auto_now=True, verbose_name='更新时间')

    class Meta:
        verbose_name = '会员信息'
        verbose_name_plural = '会员信息'

    def __str__(self):
        return self.user.username

# 创建User时自动创建Profile
@receiver(post_save, sender=User)
def ensure_profile_exists(sender, instance, created, **kwargs):
    if created:
        Profile.objects.get_or_create(user=instance)

# 首页 Hero 区全站统计缓存（hero_stats，见 views_paper.test_paper_list）：
# 试卷/题目任何增删改后即时失效，避免 LocMemCache（进程内）缓存残留旧统计值
@receiver(post_save, sender=TestPaper)
@receiver(post_delete, sender=TestPaper)
@receiver(post_save, sender=Question)
@receiver(post_delete, sender=Question)
def invalidate_hero_stats_cache(sender, **kwargs):
    cache.delete('hero_stats')

class TestRecord(models.Model):
    # 答题记录
    user = models.ForeignKey(User, on_delete=models.CASCADE, verbose_name='用户')
    test_paper = models.ForeignKey(TestPaper, on_delete=models.CASCADE, verbose_name='试卷', null=True, blank=True)
    score = models.IntegerField(verbose_name='得分')
    total_score = models.IntegerField(verbose_name='总分')
    completed_at = models.DateTimeField(auto_now_add=True, verbose_name='完成时间')
    is_wrong_paper = models.BooleanField(default=False, verbose_name='是否错题组卷')

    class Meta:
        verbose_name = '答题记录'
        verbose_name_plural = '答题记录'
        ordering = ['-completed_at']

    def __str__(self):
        if self.test_paper:
            return f'{self.user.username} - {self.test_paper.title} - {self.score}/{self.total_score}'
        else:
            return f'{self.user.username} - 错题复习 - {self.score}/{self.total_score}'

class AnswerRecord(models.Model):
    test_record = models.ForeignKey(TestRecord, on_delete=models.CASCADE, verbose_name='答题记录')
    question = models.ForeignKey(Question, on_delete=models.CASCADE, verbose_name='题目')
    user_answer = models.CharField(max_length=10, verbose_name='用户答案', null=True, blank=True)
    correct_answer = models.CharField(max_length=10, verbose_name='正确答案')
    is_correct = models.BooleanField(verbose_name='是否正确')
    answered_at = models.DateTimeField(auto_now_add=True, verbose_name='答题时间')

    original_question_content = models.TextField(verbose_name='原始题目内容', null=True, blank=True)
    original_question_type = models.IntegerField(verbose_name='原始题目类型', choices=Question.TYPE_CHOICE, null=True, blank=True)
    original_options = models.JSONField(verbose_name='原始选项', default=dict, blank=True, help_text='原始选择题选项，格式：{"A":"选项内容","B":"选项内容"}')
    original_explanation = models.TextField(verbose_name='原始解析', null=True, blank=True)

    class Meta:
        verbose_name = '每题答题记录'
        verbose_name_plural = '每题答题记录'
        ordering = ['-answered_at']

class WrongQuestion(models.Model):
    # 错题本
    user = models.ForeignKey(User, on_delete=models.CASCADE, verbose_name='用户')
    question = models.ForeignKey(Question, on_delete=models.CASCADE, verbose_name='题目')
    user_answer = models.CharField(max_length=10, verbose_name='用户错误答案', null=True, blank=True)
    correct_answer = models.CharField(max_length=10, verbose_name='正确答案', null=True, blank=True)
    added_at = models.DateTimeField(auto_now_add=True, verbose_name='添加时间')
    # 复习状态机 + 间隔重复（艾宾浩斯遗忘曲线简化版）
    REVIEW_STATUS_CHOICES = (
        ('new', '未复习'),
        ('reviewing', '复习中'),
        ('mastered', '已掌握'),
        ('difficult', '顽固错题'),
    )
    review_status = models.CharField(max_length=10, choices=REVIEW_STATUS_CHOICES, default='new', verbose_name='复习状态')
    review_count = models.IntegerField(default=0, verbose_name='复习次数')
    last_reviewed_at = models.DateTimeField(null=True, blank=True, verbose_name='上次复习时间')
    next_review_at = models.DateTimeField(null=True, blank=True, verbose_name='下次复习时间')

    class Meta:
        verbose_name = '错题本'
        verbose_name_plural = '错题本'
        # 一个用户一个题目只能出现一次
        unique_together = ('user', 'question')

    def __str__(self):
        return f'{self.user.username} - {self.question.content}'


class Class(models.Model):
    code = models.CharField(max_length=20, verbose_name='班级编号', unique=True, help_text='用于学生申请加入班级的编号')
    name = models.CharField(max_length=100, verbose_name='班级名称')
    description = models.TextField(verbose_name='班级描述', null=True, blank=True)
    JOIN_RULE_CHOICES = (
        ('auto', '自动进班'),
        ('approval', '授权进班'),
    )
    join_rule = models.CharField(max_length=20, verbose_name='进班规则', choices=JOIN_RULE_CHOICES, default='approval')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    updated_at = models.DateTimeField(auto_now=True, verbose_name='更新时间')

    class Meta:
        verbose_name = '班级'
        verbose_name_plural = '班级'
        ordering = ['code']

    def __str__(self):
        return f'{self.code} - {self.name}'

    def get_admin_users(self):
        admins = ClassAdmin.objects.filter(class_obj=self)
        return [admin.user for admin in admins]

    def get_students(self):
        return User.objects.filter(profile__class_obj=self, profile__approval_status=1)

    def get_pending_applications(self):
        return ClassApplication.objects.filter(class_obj=self, status=0)


class ClassAdmin(models.Model):
    class_obj = models.ForeignKey(Class, on_delete=models.CASCADE, verbose_name='班级', related_name='class_admins')
    user = models.ForeignKey(User, on_delete=models.CASCADE, verbose_name='管理员用户', related_name='admin_classes')

    class Meta:
        verbose_name = '班级管理员'
        verbose_name_plural = '班级管理员'
        unique_together = ('class_obj', 'user')

    def __str__(self):
        return f'{self.user.username} - {self.class_obj.name}'


class ClassApplication(models.Model):
    class_obj = models.ForeignKey(Class, on_delete=models.CASCADE, verbose_name='申请班级', related_name='applications')
    user = models.ForeignKey(User, on_delete=models.CASCADE, verbose_name='申请用户', related_name='class_applications')
    STATUS_CHOICE = ((0, '待审核'), (1, '已通过'), (2, '已拒绝'))
    status = models.IntegerField(choices=STATUS_CHOICE, default=0, verbose_name='申请状态')
    message = models.TextField(verbose_name='申请留言', blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='申请时间')
    reviewed_at = models.DateTimeField(verbose_name='审核时间', null=True, blank=True)
    reviewed_by = models.ForeignKey(User, on_delete=models.SET_NULL, verbose_name='审核人', null=True, blank=True, related_name='reviewed_applications')

    class Meta:
        verbose_name = '班级申请'
        verbose_name_plural = '班级申请'
        unique_together = ('class_obj', 'user')
        ordering = ['-created_at']

    def __str__(self):
        return f'{self.user.username} 申请加入 {self.class_obj.name}'


class ClassAssignment(models.Model):
    """班级作业/考试模型"""
    # 作业类型：1-作业，2-考试
    TYPE_CHOICE = ((1, '作业'), (2, '考试'))
    
    class_obj = models.ForeignKey(Class, on_delete=models.CASCADE, verbose_name='班级', related_name='assignments')
    test_paper = models.ForeignKey(TestPaper, on_delete=models.CASCADE, verbose_name='试卷', related_name='class_assignments')
    title = models.CharField(max_length=100, verbose_name='作业标题')
    description = models.TextField(verbose_name='作业描述', null=True, blank=True)
    type = models.IntegerField(choices=TYPE_CHOICE, default=1, verbose_name='作业类型')
    deadline = models.DateTimeField(verbose_name='截止时间')
    time_limit = models.IntegerField(verbose_name='考试时长(分钟)', null=True, blank=True, help_text='仅考试模式有效，单位分钟')
    STATUS_CHOICE = ((0, '未发布'), (1, '已发布'))
    status = models.IntegerField(choices=STATUS_CHOICE, default=0, verbose_name='状态')
    is_allow_exam = models.BooleanField(default=True, verbose_name='是否允许考试')
    # schema 同步：数据库列 is_random/random_config 由历史迁移添加但文件已丢失，
    # 此处补回模型字段（迁移用 SeparateDatabaseAndState 只更新 state，见 0032）
    is_random = models.BooleanField(default=False, verbose_name='是否随机出题')
    random_config = models.JSONField(default=dict, blank=True, verbose_name='随机出题配置')
    created_by = models.ForeignKey(User, on_delete=models.SET_NULL, verbose_name='创建人', null=True, blank=True, related_name='created_assignments')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')
    published_at = models.DateTimeField(verbose_name='发布时间', null=True, blank=True)

    class Meta:
        verbose_name = '班级作业'
        verbose_name_plural = '班级作业'
        ordering = ['-created_at']

    def __str__(self):
        return f'{self.class_obj.name} - {self.title}'

    # P2-12：移除手动 get_status_display / get_type_display——
    # status/type 字段已带 choices= 参数，Django 自动生成 get_FOO_display；
    # 且全项目（模板/Python）均未调用这两个手动方法，属冗余代码。

    def get_completed_count(self):
        """获取已完成人数"""
        return ClassAssignmentRecord.objects.filter(assignment=self, is_submitted=True).count()

    def get_total_students(self):
        """获取班级总人数"""
        return self.class_obj.get_students().count()

    def get_not_submitted_users(self):
        """获取未提交的学生列表"""
        submitted_users = ClassAssignmentRecord.objects.filter(assignment=self, is_submitted=True).values_list('user_id', flat=True)
        return self.class_obj.get_students().exclude(id__in=submitted_users)


class ClassAssignmentRecord(models.Model):
    """班级作业答题记录"""
    assignment = models.ForeignKey(ClassAssignment, on_delete=models.CASCADE, verbose_name='作业', related_name='records')
    user = models.ForeignKey(User, on_delete=models.CASCADE, verbose_name='学生', related_name='assignment_records')
    test_record = models.ForeignKey(TestRecord, on_delete=models.SET_NULL, verbose_name='答题记录', null=True, blank=True, related_name='assignment_record')
    is_submitted = models.BooleanField(default=False, verbose_name='是否提交')
    score = models.IntegerField(verbose_name='得分', null=True, blank=True)
    start_time = models.DateTimeField(verbose_name='开始答题时间', null=True, blank=True)
    submitted_at = models.DateTimeField(verbose_name='提交时间', null=True, blank=True)
    attempt = models.IntegerField(verbose_name='第几次提交', default=1)

    class Meta:
        verbose_name = '班级作业记录'
        verbose_name_plural = '班级作业记录'
        ordering = ['-submitted_at', '-start_time']

    def __str__(self):
        return f'{self.user.username} - {self.assignment.title}'


class TestDraft(models.Model):
    """答题草稿：答题过程临时保存，支持异常中断后继续测试"""
    user = models.ForeignKey(User, on_delete=models.CASCADE, verbose_name='用户', related_name='test_drafts')
    # 公开试卷 / 错题组卷走 test_paper；班级作业/考试走 assignment
    test_paper = models.ForeignKey(TestPaper, on_delete=models.CASCADE, verbose_name='试卷', null=True, blank=True)
    assignment = models.ForeignKey(ClassAssignment, on_delete=models.CASCADE, verbose_name='班级作业', null=True, blank=True)
    is_wrong_paper = models.BooleanField(default=False, verbose_name='是否错题组卷')
    # 答题内容：{"question_id": "答案串"}（单选/判断=值，多选=排序拼接，与 collect_user_answers 一致）
    answers = models.JSONField(default=dict, verbose_name='答题内容')
    current_index = models.IntegerField(default=0, verbose_name='逐题答题位置')
    mode = models.CharField(max_length=10, default='full', verbose_name='答题模式')  # full/single
    start_time = models.DateTimeField(null=True, blank=True, verbose_name='开始时间')  # 限时考试计时起点
    updated_at = models.DateTimeField(auto_now=True, verbose_name='最后保存时间')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')

    class Meta:
        verbose_name = '答题草稿'
        verbose_name_plural = '答题草稿'
        ordering = ['-updated_at']
        # MySQL 唯一索引对 NULL 去重：test_paper/assignment 为 NULL 时允许多条，不影响各自业务线的唯一性
        constraints = [
            models.UniqueConstraint(fields=['user', 'test_paper', 'is_wrong_paper'], name='uniq_draft_test_paper'),
            models.UniqueConstraint(fields=['user', 'assignment'], name='uniq_draft_assignment'),
        ]

    def __str__(self):
        if self.assignment:
            return f'{self.user.username} - 作业草稿 - {self.assignment.title}'
        if self.test_paper:
            return f'{self.user.username} - {"错题" if self.is_wrong_paper else ""}试卷草稿 - {self.test_paper.title}'
        return f'{self.user.username} - 草稿#{self.id}'

    def answered_count(self):
        """已答题数（以草稿 answers 键为准）"""
        return len(self.answers or {})


class Notification(models.Model):
    """站内通知系统：作业布置、申请审核、作业提交等事件触达"""
    NOTI_TYPES = (
        ('assignment', '新作业'),
        ('submit', '作业提交'),
        ('approval', '申请通知'),
        ('grade', '成绩反馈'),
        ('system', '系统通知'),
    )
    recipient = models.ForeignKey(User, on_delete=models.CASCADE, verbose_name='接收人', related_name='notifications')
    sender = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True, verbose_name='发送人', related_name='sent_notifications')
    type = models.CharField(max_length=20, choices=NOTI_TYPES, verbose_name='通知类型')
    title = models.CharField(max_length=200, verbose_name='标题')
    content = models.TextField(blank=True, default='', verbose_name='内容')
    link = models.CharField(max_length=200, blank=True, default='', verbose_name='跳转链接')
    is_read = models.BooleanField(default=False, verbose_name='是否已读')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='创建时间')

    class Meta:
        verbose_name = '通知'
        verbose_name_plural = '通知'
        ordering = ['-created_at']

    def __str__(self):
        return f'{self.recipient.username} - {self.title}'

    @classmethod
    def notify(cls, recipient, sender, ntype, title, content='', link=''):
        """快捷创建通知（单条）"""
        return cls.objects.create(
            recipient=recipient, sender=sender, type=ntype,
            title=title, content=content, link=link,
        )

    @classmethod
    def notify_many(cls, recipients, sender, ntype, title, content='', link=''):
        """批量创建通知（给多人），返回创建条数"""
        objs = [cls(
            recipient=r, sender=sender, type=ntype,
            title=title, content=content, link=link,
        ) for r in recipients if r]
        if objs:
            cls.objects.bulk_create(objs)
        return len(objs)
