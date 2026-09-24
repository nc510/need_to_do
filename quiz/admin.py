from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from django.contrib.auth.models import User
from django.contrib.auth.forms import UserChangeForm, UserCreationForm, AdminPasswordChangeForm
from django.urls import path, reverse
from django.utils.html import format_html
from django.utils import timezone
from django.http import HttpResponseRedirect
from django import forms
from django.db.models import Count
from .models import Question, TestPaper, Profile, TestRecord, AnswerRecord, WrongQuestion, Class, ClassAdmin, ClassApplication, ClassAssignment, ClassAssignmentRecord, Subject, Chapter, Section, KnowledgePoint, Notification, SiteConfig, Announcement

admin.site.site_header = '📚 来斩题 - 在线考试系统管理后台'
admin.site.site_title = '来斩题 - 在线考试系统'
admin.site.index_title = '欢迎使用来斩题 - 在线考试系统管理后台'

class CustomUserChangeForm(UserChangeForm):
    class Meta(UserChangeForm.Meta):
        model = User
        fields = '__all__'

class CustomUserCreationForm(UserCreationForm):
    class Meta(UserCreationForm.Meta):
        model = User
        fields = ('username', 'email', 'first_name', 'last_name')


class CustomAdminPasswordChangeForm(AdminPasswordChangeForm):
    """后台修改密码时同步记录明文，供管理员查看"""

    def save(self, commit=True):
        user = super().save(commit)
        try:
            profile = user.profile
            profile.plain_password = self.cleaned_data.get('password1', '')
            profile.save(update_fields=['plain_password', 'updated_at'])
        except Profile.DoesNotExist:
            pass
        return user

class CustomUserAdmin(UserAdmin):
    form = CustomUserChangeForm
    add_form = CustomUserCreationForm
    change_password_form = CustomAdminPasswordChangeForm
    change_form_template = 'admin/auth/user/change_form.html'

    list_display = ('username', 'email', 'first_name', 'last_name', 'is_staff', 'is_superuser', 'date_joined', 'actions_column')
    list_filter = ('is_staff', 'is_superuser', 'is_active', 'date_joined')
    search_fields = ('username', 'email', 'first_name', 'last_name')
    ordering = ('-date_joined',)

    fieldsets = (
        ('基本信息', {'fields': ('username', 'password')}),
        ('个人资料', {'fields': ('first_name', 'last_name', 'email')}),
        ('权限', {'fields': ('is_active', 'is_staff', 'is_superuser', 'groups', 'user_permissions')}),
        ('重要日期', {'fields': ('last_login', 'date_joined')}),
    )

    add_fieldsets = (
        ('创建用户', {
            'classes': ('wide',),
            'fields': ('username', 'password1', 'password2', 'email', 'first_name', 'last_name', 'is_staff', 'is_superuser')}
        ),
    )

    def actions_column(self, obj):
        edit_url = reverse('admin:auth_user_change', args=[obj.pk])
        change_password_url = reverse('admin:auth_user_password_change', args=[obj.pk])

        return format_html(
            '<a href="{}" class="btn btn-sm btn-primary" style="margin-right: 5px;">✏️ 编辑</a>'
            '<a href="{}" class="btn btn-sm btn-danger">🔄 修改密码</a>',
            edit_url, change_password_url
        )

    actions_column.short_description = '操作'

    def get_fieldsets(self, request, obj=None):
        fieldsets = super().get_fieldsets(request, obj)

        if obj:
            change_password_url = reverse('admin:auth_user_password_change', args=[obj.pk])
            plain_pw = ''
            try:
                plain_pw = obj.profile.plain_password or ''
            except Profile.DoesNotExist:
                pass

            # 明文密码显示：默认 ******，点击切换显示（配合 admin/auth/user/change_form.html 的 JS）
            if plain_pw:
                plain_pw_box = format_html(
                    '<p style="margin:0 0 10px 0;">'
                    '<strong>明文密码：</strong>'
                    '<code id="plain-pw-value" data-val="{}">********</code>'
                    '<button type="button" onclick="togglePlainPassword(this)" '
                    'style="margin-left:8px;padding:2px 10px;font-size:12px;cursor:pointer;">👁 显示</button>'
                    '<span style="font-size:11px;color:#888;margin-left:6px;">（默认隐藏，点击查看）</span>'
                    '</p>',
                    plain_pw
                )
            else:
                plain_pw_box = format_html(
                    '<p style="color:#856404;margin-bottom:10px;">'
                    '（未记录明文密码：仅新注册或后台修改密码后保存明文，历史用户暂无）</p>'
                )

            if obj.is_superuser:
                password_management_fieldset = (
                    '🔐 密码管理', {
                        'description': format_html(
                            '<div style="background: #d4edda; border: 1px solid #c3e6cb; padding: 15px; border-radius: 4px; margin-bottom: 10px;">'
                            '<p style="font-weight: bold; color: #155724; margin-bottom: 10px;">🔐 超级管理员密码保护</p>'
                            '<p style="color: #155724; margin-bottom: 10px;">此用户为超级管理员，密码修改需要谨慎操作。</p>'
                            '{pw_box}'
                            '<a href="{url}" class="btn btn-danger">🔄 修改密码</a>'
                            '</div>',
                            pw_box=plain_pw_box, url=change_password_url
                        ),
                        'fields': (),
                    }
                )
            else:
                password_management_fieldset = (
                    '🔐 密码管理', {
                        'description': format_html(
                            '<div style="background: #fff3cd; border: 1px solid #ffeeba; padding: 15px; border-radius: 4px; margin-bottom: 10px;">'
                            '<p style="font-weight: bold; color: #856404; margin-bottom: 10px;">🔐 用户密码管理</p>'
                            '<p style="color: #856404; margin-bottom: 10px;">密码采用加密存储，如需修改请点击下方按钮。</p>'
                            '{pw_box}'
                            '<a href="{url}" class="btn btn-danger">🔄 修改密码</a>'
                            '</div>',
                            pw_box=plain_pw_box, url=change_password_url
                        ),
                        'fields': (),
                    }
                )

            fieldsets = [fs for fs in fieldsets if fs[0] != 'Password']
            fieldsets.insert(1, password_management_fieldset)

        return fieldsets

    def has_change_permission(self, request, obj=None):
        if obj and obj.is_superuser and not request.user.is_superuser:
            return False
        return super().has_change_permission(request, obj)

    def has_delete_permission(self, request, obj=None):
        if obj and obj.is_superuser and not request.user.is_superuser:
            return False
        return super().has_delete_permission(request, obj)

    def save_model(self, request, obj, form, change):
        super().save_model(request, obj, form, change)
        # 后台新增用户（change=False）时同步记录明文密码，供管理员查看
        if not change and 'password1' in form.cleaned_data:
            try:
                profile = obj.profile
                profile.plain_password = form.cleaned_data.get('password1', '')
                profile.save(update_fields=['plain_password', 'updated_at'])
            except Profile.DoesNotExist:
                pass

class ProfileAdmin(admin.ModelAdmin):
    list_display = ('user', 'display_name', 'role', 'approval_status', 'phone_number', 'class_obj', 'member_start_time', 'member_expire_time', 'member_status', 'created_at', 'updated_at')
    list_filter = ('role', 'approval_status', 'class_obj', 'created_at')
    list_editable = ('role', 'approval_status')
    search_fields = ('user__username', 'user__email', 'user__first_name', 'name', 'phone_number')
    ordering = ('-created_at',)
    readonly_fields = ('created_at', 'updated_at', 'member_status', 'last_seen_at')
    list_select_related = ('user', 'class_obj')
    fieldsets = (
        ('账号信息', {'fields': ('user', 'name', 'role', 'approval_status', 'plain_password')}),
        ('联系方式', {'fields': ('phone_number', 'qq_number', 'class_obj')}),
        ('会员有效期', {
            'fields': ('member_start_time', 'member_expire_time', 'member_status'),
            'description': '会员开始与到期时间仅供记录/展示，不做登录限制。',
        }),
        ('统计数据', {'fields': ('total_score', 'tests_taken', 'conquered_count', 'conquered_bonus', 'answered_total', 'answered_correct'),
                      'description': '斩题数 = 答对去重题目数 + 斩题加成（道具「斩题卡」补记），榜单直接读斩题数。'}),
        ('其他', {'fields': ('session_key', 'last_seen_at', 'created_at', 'updated_at')}),
    )

    def display_name(self, obj):
        """名字：优先注册时填写的姓名（User.first_name），回退 Profile.name"""
        return obj.user.first_name or obj.name or '-'
    display_name.short_description = '名字'
    display_name.admin_order_field = 'user__first_name'

    def member_status(self, obj):
        """会员状态：按开始/到期时间实时计算，仅用于展示"""
        color, text = {
            'none': ('#9e9e9e', '— 未设置'),
            'pending': ('#ff9800', '⏳ 未开始'),
            'active': ('#4caf50', '✅ 生效中'),
            'expired': ('#f44336', '❌ 已到期'),
        }[obj.member_status_code]
        return format_html('<span style="background:{};color:white;padding:3px 8px;border-radius:4px;">{}</span>', color, text)
    member_status.short_description = '会员状态'


class SiteConfigAdmin(admin.ModelAdmin):
    """会员默认设置（单例）：注册用户默认审核状态与默认会员时长"""
    fieldsets = (
        ('注册用户默认审核状态', {
            'fields': ('default_approval_status',),
            'description': '新用户注册后自动写入的会员审核状态默认值（注册即生效，可在「会员信息」中逐个调整）。',
        }),
        ('注册用户默认会员时长', {
            'fields': ('default_member_days',),
            'description': '新用户注册后按该天数自动设置会员到期时间；填 0 表示不设到期时间，仅记录注册时刻为会员开始时间。',
        }),
    )

    def has_add_permission(self, request):
        # 单例：仅当配置不存在时允许新增
        return not SiteConfig.objects.exists()

    def has_delete_permission(self, request, obj=None):
        return False

    def changelist_view(self, request, extra_context=None):
        # 单例：列表页直接跳转到唯一的配置对象
        obj = SiteConfig.get_solo()
        return HttpResponseRedirect(reverse('admin:quiz_siteconfig_change', args=[obj.pk]))

class QuestionAdmin(admin.ModelAdmin):
    list_display = ('id', 'type', 'content', 'score', 'is_public', 'created_by', 'subject', 'chapter', 'knowledge_points_display', 'created_at')
    list_display_links = ('id', 'content')
    list_filter = ('type', 'is_public', 'subject', 'created_at')
    search_fields = ('id', 'content', 'explanation', 'created_by')
    ordering = ('-created_at',)
    fields = ('type', 'content', 'options', 'correct_answer', 'score', 'explanation', 'is_public', 'created_by', 'subject', 'chapter', 'section', 'knowledge_points')
    readonly_fields = ('created_at', 'updated_at')
    filter_horizontal = ('knowledge_points',)
    change_list_template = 'admin/quiz/question/change_list.html'
    list_select_related = ('subject', 'chapter', 'section')
    actions = ['make_public', 'make_private', 'delete_selected']
    
    def knowledge_points_display(self, obj):
        kps = list(obj.knowledge_points.all()[:3])
        if obj.knowledge_points.count() > 3:
            return ', '.join([kp.name for kp in kps]) + '...'
        return ', '.join([kp.name for kp in kps])
    knowledge_points_display.short_description = '知识点'
    
    def make_public(self, request, queryset):
        count = queryset.update(is_public=True)
        self.message_user(request, f'已成功将 {count} 道题目设为公开')
    make_public.short_description = '设为公开'
    
    def make_private(self, request, queryset):
        count = queryset.update(is_public=False)
        self.message_user(request, f'已成功将 {count} 道题目设为私有')
    make_private.short_description = '设为私有'

class TestPaperAdmin(admin.ModelAdmin):
    list_display = ('id', 'title', 'total_score', 'question_count', 'is_published', 'is_public', 'review_status_column', 'duration', 'max_attempts', 'created_by', 'created_at', 'action_buttons')
    list_display_links = ('id', 'title')
    list_filter = ('is_published', 'is_public', 'review_status', 'created_by', 'created_at')
    search_fields = ('title', 'description', 'created_by')
    ordering = ('-created_at',)
    filter_horizontal = ('questions',)
    fields = ('title', 'description', 'questions', 'is_published', 'is_public', 'review_status', 'review_remark', 'duration', 'max_attempts', 'start_time', 'end_time', 'pass_rate', 'good_rate', 'excellent_rate')
    readonly_fields = ('total_score', 'created_at', 'created_by', 'reviewed_at', 'reviewed_by')
    change_list_template = 'admin/quiz/testpaper/change_list.html'
    change_form_template = 'admin/quiz/testpaper/change_form.html'
    actions = ['approve_papers', 'reject_papers', 'make_public', 'make_private', 'delete_selected']

    def has_add_permission(self, request):
        return False

    def get_urls(self):
        """追加「错题组卷试卷」独立列表页。

        不能用 ?paper_type=xxx 这种自定义查询参数：admin 的 ChangeList 会把无法识别的
        参数当作字段查找，抛 IncorrectLookupParameters 后重定向，页面始终显示不出结果。
        这里改为独立 URL，并放在默认的 <object_id>/ 之前，避免被当成试卷 ID 匹配。
        """
        custom_urls = [
            path('wrong/', self.admin_site.admin_view(self.wrong_paper_changelist),
                 name='quiz_testpaper_wrong_changelist'),
        ]
        return custom_urls + super().get_urls()

    def wrong_paper_changelist(self, request, extra_context=None):
        """错题组卷试卷列表（复用试卷 changelist 模板，仅供查看与清理）"""
        extra_context = {
            **(extra_context or {}),
            'wrong_mode': True,
            'title': '错题组卷试卷（仅供查看与清理）',
        }
        return self.changelist_view(request, extra_context=extra_context)

    def get_queryset(self, request):
        """试卷列表按用途分流：正式列表只看正式试卷，错题组卷列表只看错题组卷。

        仅在两个列表页生效；单条查看/编辑/删除不受影响，管理员仍可查看错题组卷试卷。
        """
        qs = super().get_queryset(request)
        url_name = request.resolver_match.url_name if request.resolver_match else ''
        if url_name == 'quiz_testpaper_wrong_changelist':
            return qs.filter(is_wrong_paper=True)
        if url_name == 'quiz_testpaper_changelist':
            return qs.filter(is_wrong_paper=False)
        return qs

    def formfield_for_manytomany(self, db_field, request, **kwargs):
        if db_field.name == 'questions':
            field = super().formfield_for_manytomany(db_field, request, **kwargs)
            field.label_from_instance = lambda obj: f'#{obj.id} {obj.content[:50]}'
            return field
        return super().formfield_for_manytomany(db_field, request, **kwargs)

    def question_count(self, obj):
        return obj.questions.count()
    question_count.short_description = '题目数量'

    def review_status_column(self, obj):
        """审核状态：前台提交发布后需管理员审核，通过后才进入全站列表"""
        color, text = {
            TestPaper.REVIEW_PENDING: ('#ff9800', '⏳ 待审核'),
            TestPaper.REVIEW_APPROVED: ('#4caf50', '✅ 已通过'),
            TestPaper.REVIEW_REJECTED: ('#f44336', '❌ 已驳回'),
        }[obj.review_status]
        return format_html('<span style="background:{};color:white;padding:3px 8px;border-radius:4px;font-size:12px;">{}</span>', color, text)
    review_status_column.short_description = '审核状态'

    def _notify_creator(self, paper, reviewer):
        """把审核结果通知给试卷创建者（created_by 存的是用户名）"""
        creator = User.objects.filter(username=paper.created_by).first()
        if not creator:
            return
        if paper.review_status == TestPaper.REVIEW_APPROVED:
            title = f'试卷审核通过：{paper.title}'
            content = f'您提交的试卷「{paper.title}」已通过审核，已发布到全站试卷列表。'
        else:
            title = f'试卷审核未通过：{paper.title}'
            content = f'您提交的试卷「{paper.title}」未通过审核，不会出现在全站试卷列表。'
            if paper.review_remark:
                content += f' 驳回原因：{paper.review_remark}'
        try:
            Notification.notify(
                recipient=creator, sender=reviewer, ntype='system',
                title=title, content=content, link='/quiz/my_test_papers/')
        except Exception:
            # 通知失败不影响审核本身
            pass

    def approve_papers(self, request, queryset):
        """批量审核通过：同时发布到全站列表"""
        papers = list(queryset.filter(is_wrong_paper=False))
        for paper in papers:
            paper.review_status = TestPaper.REVIEW_APPROVED
            paper.is_published = True
            paper.reviewed_at = timezone.now()
            paper.reviewed_by = request.user
            paper.save(update_fields=['review_status', 'is_published', 'reviewed_at', 'reviewed_by'])
            self._notify_creator(paper, request.user)
        self.message_user(request, f'已审核通过 {len(papers)} 份试卷并发布到全站列表')
    approve_papers.short_description = '✅ 审核通过（发布到全站）'

    def reject_papers(self, request, queryset):
        """批量审核驳回：从全站列表撤下，可在试卷编辑页补充驳回原因"""
        papers = list(queryset.filter(is_wrong_paper=False))
        for paper in papers:
            paper.review_status = TestPaper.REVIEW_REJECTED
            paper.is_published = False
            paper.reviewed_at = timezone.now()
            paper.reviewed_by = request.user
            paper.save(update_fields=['review_status', 'is_published', 'reviewed_at', 'reviewed_by'])
            self._notify_creator(paper, request.user)
        self.message_user(request, f'已驳回 {len(papers)} 份试卷，已从全站列表撤下')
    reject_papers.short_description = '❌ 审核驳回（从全站撤下）'

    def action_buttons(self, obj):
        change_url = reverse('admin:quiz_testpaper_change', args=[obj.pk])
        delete_url = reverse('admin:quiz_testpaper_delete', args=[obj.pk])
        preview_url = reverse('admin_preview_testpaper', args=[obj.pk])
        return format_html(
            '<a class="button" href="{}" style="background: #2196f3; color: white; padding: 5px 12px; border-radius: 3px; text-decoration: none; font-size: 12px;">👁️ 预览</a>'
            '&nbsp;'
            '<a class="button" href="{}" style="background: #4caf50; color: white; padding: 5px 12px; border-radius: 3px; text-decoration: none; font-size: 12px;">✏️ 编辑</a>'
            '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'
            '<a class="button" href="{}" style="background: #f44336; color: white; padding: 5px 12px; border-radius: 3px; text-decoration: none; font-size: 12px; margin-left: 30px;" onclick="return confirm(\'确定要删除此试卷吗？\')">🗑️ 删除</a>',
            preview_url, change_url, delete_url
        )
    action_buttons.short_description = '操作'
    action_buttons.allow_tags = True

    def make_public(self, request, queryset):
        count = queryset.update(is_public=True)
        self.message_user(request, f'已成功将 {count} 份试卷设为公开')
    make_public.short_description = '设为公开'

    def make_private(self, request, queryset):
        count = queryset.update(is_public=False)
        self.message_user(request, f'已成功将 {count} 份试卷设为私有')
    make_private.short_description = '设为私有'

    def save_model(self, request, obj, form, change):
        if not change:
            obj.created_by = request.user.username
        # 在编辑页直接改审核状态时，补齐审核人/时间并通知创建者（与批量操作口径一致）
        if change and 'review_status' in form.changed_data:
            if obj.review_status == TestPaper.REVIEW_APPROVED:
                obj.is_published = True
            elif obj.review_status == TestPaper.REVIEW_REJECTED:
                obj.is_published = False
            obj.reviewed_at = timezone.now()
            obj.reviewed_by = request.user
            obj.save()
            self._notify_creator(obj, request.user)
            return
        obj.save()


class TestRecordAdmin(admin.ModelAdmin):
    list_display = ('user', 'test_paper', 'score', 'total_score', 'score_rate', 'completed_at', 'is_wrong_paper_display')
    list_filter = ('completed_at', 'is_wrong_paper')
    search_fields = ('user__username', 'test_paper__title')
    ordering = ('-completed_at',)

    def score_rate(self, obj):
        # 单次答题的得分率（得分 / 卷面总分），与全站「正确率」（答对题次 / 作答题次）不是同一指标
        # 是否及格按该试卷配置的及格线着色；test_paper 为空（历史脏数据）时回落到默认 60
        if obj.total_score > 0:
            rate = int(obj.score / obj.total_score * 100)
            pass_line = obj.test_paper.pass_rate if obj.test_paper else TestPaper.DEFAULT_PASS_RATE
            color = '#4caf50' if rate >= pass_line else '#f44336'
            return format_html('<span style="color: {}; font-weight: bold;">{}%</span>', color, rate)
        return '0%'
    score_rate.short_description = '得分率'

    def is_wrong_paper_display(self, obj):
        if hasattr(obj, 'is_wrong_paper') and obj.is_wrong_paper:
            return format_html('<span style="background: #ff9800; color: white; padding: 3px 8px; border-radius: 4px; font-size: 12px;">❌ 错题组卷</span>')
        return format_html('<span style="background: #4caf50; color: white; padding: 3px 8px; border-radius: 4px; font-size: 12px;">✅ 正常试卷</span>')
    is_wrong_paper_display.short_description = '试卷类型'

class AnswerRecordAdmin(admin.ModelAdmin):
    list_display = ('test_record', 'question', 'user_answer', 'correct_answer', 'is_correct_display', 'answered_at')
    list_filter = ('is_correct', 'answered_at')
    search_fields = ('question__content', 'test_record__user__username')
    ordering = ('-answered_at',)

    def is_correct_display(self, obj):
        # 未作答既不算对也不算错，单独标记，避免被当成答错
        if not obj.user_answer:
            return format_html('<span style="background: #9e9e9e; color: white; padding: 3px 8px; border-radius: 4px;">— 未答</span>')
        if obj.is_correct:
            return format_html('<span style="background: #4caf50; color: white; padding: 3px 8px; border-radius: 4px;">✅ 正确</span>')
        return format_html('<span style="background: #f44336; color: white; padding: 3px 8px; border-radius: 4px;">❌ 错误</span>')
    is_correct_display.short_description = '答题结果'


class WrongQuestionAdmin(admin.ModelAdmin):
    list_display = ('user', 'question', 'review_status', 'review_count', 'next_review_at', 'user_answer', 'correct_answer_display', 'added_at')
    list_filter = ('review_status', 'added_at')
    search_fields = ('user__username', 'question__content')
    ordering = ('-added_at',)
    list_editable = ('review_status',)
    change_list_template = 'admin/quiz/wrongquestion/change_list.html'

    # 汇总页签的状态列与 WrongQuestion.REVIEW_STATUS_CHOICES 保持一致
    _summary_status_keys = ('new', 'reviewing', 'difficult', 'mastered')

    def changelist_view(self, request, extra_context=None):
        """列表页顶部追加「按成员汇总错题数」（含各复习状态分类）。

        汇总基于当前筛选后的结果集（cl.queryset），跟随右侧过滤器/搜索联动；
        一次分组聚合完成，避免按用户逐条统计的 N+1。
        """
        response = super().changelist_view(request, extra_context)
        try:
            cl = response.context_data['cl']
        except (AttributeError, KeyError):
            return response
        per_user = {}
        for row in (cl.queryset
                    .values('user_id', 'user__username', 'review_status')
                    .annotate(cnt=Count('id'))):
            entry = per_user.setdefault(row['user_id'], {
                'username': row['user__username'], 'total': 0,
                'new': 0, 'reviewing': 0, 'difficult': 0, 'mastered': 0})
            if row['review_status'] in self._summary_status_keys:
                entry[row['review_status']] += row['cnt']
            entry['total'] += row['cnt']
        rows = sorted(per_user.values(), key=lambda r: (-r['total'], r['username']))
        totals = {k: sum(r[k] for r in rows) for k in ('total',) + self._summary_status_keys}
        response.context_data['wrong_summary'] = rows
        response.context_data['wrong_summary_totals'] = totals
        return response

    def correct_answer_display(self, obj):
        return format_html('<span style="color: #4caf50; font-weight: bold;">{}</span>', obj.question.correct_answer)
    correct_answer_display.short_description = '正确答案'


class NotificationAdmin(admin.ModelAdmin):
    list_display = ('recipient', 'sender', 'type', 'title', 'is_read', 'created_at')
    list_filter = ('type', 'is_read', 'created_at')
    search_fields = ('recipient__username', 'sender__username', 'title')
    ordering = ('-created_at',)
    list_editable = ('is_read',)
    actions = ['mark_read', 'mark_unread']

    def mark_read(self, request, queryset):
        queryset.update(is_read=True)
    mark_read.short_description = '标记为已读'

    def mark_unread(self, request, queryset):
        queryset.update(is_read=False)
    mark_unread.short_description = '标记为未读'


class AnnouncementAdmin(admin.ModelAdmin):
    """系统公告：滚动条 / 公告板两种前台展示形态，按生效时间自动上下架"""
    list_display = ('title', 'level_badge', 'display_mode', 'is_active',
                    'sort_order', 'start_at', 'end_at', 'status_badge', 'updated_at')
    list_filter = ('level', 'display_mode', 'is_active')
    search_fields = ('title', 'content')
    list_editable = ('is_active', 'sort_order')
    ordering = ('sort_order', '-created_at')
    readonly_fields = ('created_at', 'updated_at', 'status_badge')
    actions = ['action_enable', 'action_disable']
    fieldsets = (
        ('公告内容', {
            'fields': ('title', 'content', 'level'),
            'description': '滚动条只展示「标题 + 内容摘要」，适合一句话提示；'
                           '篇幅较长的公告建议选「公告板」，内容支持换行。',
        }),
        ('展示设置', {
            'fields': ('display_mode', 'is_active', 'sort_order'),
            'description': '排序数值越小越靠前；停用后前台立即不再展示。',
        }),
        ('生效时间（可留空）', {
            'fields': ('start_at', 'end_at', 'status_badge'),
            'description': '留空即立即生效 / 长期有效；到达失效时间后前台自动隐藏，无需人工下架。',
        }),
        ('记录', {'fields': ('created_at', 'updated_at')}),
    )

    def level_badge(self, obj):
        color = {
            Announcement.LEVEL_INFO: '#667eea',
            Announcement.LEVEL_SUCCESS: '#27ae60',
            Announcement.LEVEL_WARNING: '#e67e22',
            Announcement.LEVEL_DANGER: '#e74c3c',
        }[obj.level]
        return format_html(
            '<span style="background:{};color:#fff;padding:3px 8px;border-radius:4px;">{}</span>',
            color, obj.get_level_display())
    level_badge.short_description = '级别'
    level_badge.admin_order_field = 'level'

    def status_badge(self, obj):
        """前台是否正在展示：启用 + 在生效时间窗内"""
        now = timezone.now()
        if not obj.is_active:
            state = ('#9e9e9e', '⏸️ 已停用')
        elif obj.start_at and now < obj.start_at:
            state = ('#ff9800', '⏳ 未开始')
        elif obj.end_at and now > obj.end_at:
            state = ('#f44336', '❌ 已失效')
        else:
            state = ('#4caf50', '✅ 展示中')
        return format_html(
            '<span style="background:{};color:#fff;padding:3px 8px;border-radius:4px;">{}</span>',
            state[0], state[1])
    status_badge.short_description = '前台状态'

    def action_enable(self, request, queryset):
        queryset.update(is_active=True)
    action_enable.short_description = '启用所选公告'

    def action_disable(self, request, queryset):
        queryset.update(is_active=False)
    action_disable.short_description = '停用所选公告'


class ClassAdminAdmin(admin.ModelAdmin):
    list_display = ('class_obj', 'user', 'get_user_email', 'get_user_profile')
    list_filter = ('class_obj',)
    search_fields = ('class_obj__name', 'user__username')

    def get_user_email(self, obj):
        return obj.user.email or '未设置'
    get_user_email.short_description = '管理员邮箱'

    def get_user_profile(self, obj):
        try:
            profile = obj.user.profile
            return profile.approval_status
        except:
            return '无'
    get_user_profile.short_description = '账户状态'

class ClassAdminClass(admin.ModelAdmin):
    list_display = ('code', 'name', 'description', 'created_at', 'student_count', 'admin_count')
    list_filter = ('created_at',)
    search_fields = ('code', 'name', 'description')
    ordering = ('code',)

    def student_count(self, obj):
        return obj.profiles.count()
    student_count.short_description = '学生人数'

    def admin_count(self, obj):
        return obj.class_admins.count()
    admin_count.short_description = '管理员人数'


class ClassApplicationAdmin(admin.ModelAdmin):
    list_display = ('class_obj', 'user', 'status_display', 'message', 'created_at', 'reviewed_at')
    list_filter = ('status', 'created_at', 'class_obj')
    search_fields = ('class_obj__name', 'class_obj__code', 'user__username')
    ordering = ('-created_at',)
    readonly_fields = ('created_at', 'reviewed_at', 'reviewed_by')

    def status_display(self, obj):
        if obj.status == 1:
            return format_html('<span style="background: #4caf50; color: white; padding: 3px 8px; border-radius: 4px;">✅ 已通过</span>')
        elif obj.status == 2:
            return format_html('<span style="background: #f44336; color: white; padding: 3px 8px; border-radius: 4px;">❌ 已拒绝</span>')
        else:
            return format_html('<span style="background: #ff9800; color: white; padding: 3px 8px; border-radius: 4px;">⏳ 待审核</span>')
    status_display.short_description = '申请状态'

    def get_readonly_fields(self, request, obj=None):
        if obj:
            return ['created_at', 'reviewed_at', 'reviewed_by']
        return ['created_at']

# 注销默认的UserAdmin，注册自定义的
admin.site.unregister(User)
admin.site.register(User, CustomUserAdmin)

admin.site.register(Question, QuestionAdmin)
admin.site.register(TestPaper, TestPaperAdmin)
admin.site.register(Profile, ProfileAdmin)
admin.site.register(SiteConfig, SiteConfigAdmin)
admin.site.register(TestRecord, TestRecordAdmin)
admin.site.register(AnswerRecord, AnswerRecordAdmin)
admin.site.register(WrongQuestion, WrongQuestionAdmin)
admin.site.register(Class, ClassAdminClass)
admin.site.register(ClassAdmin, ClassAdminAdmin)
admin.site.register(ClassApplication, ClassApplicationAdmin)


class ClassAssignmentAdmin(admin.ModelAdmin):
    list_display = ('class_obj', 'title', 'type', 'status', 'deadline', 'created_at')
    list_filter = ('status', 'type', 'class_obj')
    search_fields = ('title', 'description')
    ordering = ('-created_at',)
    readonly_fields = ('created_at', 'published_at')

    def formfield_for_foreignkey(self, db_field, request, **kwargs):
        # 错题组卷试卷不参与作业/考试布置，后台选题下拉同样排除
        if db_field.name == 'test_paper':
            kwargs['queryset'] = TestPaper.objects.filter(is_wrong_paper=False)
        return super().formfield_for_foreignkey(db_field, request, **kwargs)


class ClassAssignmentRecordAdmin(admin.ModelAdmin):
    list_display = ('assignment', 'user', 'is_submitted', 'score', 'submitted_at')
    list_filter = ('is_submitted', 'submitted_at')
    search_fields = ('user__username', 'assignment__title')
    ordering = ('-submitted_at',)
    readonly_fields = ('submitted_at',)


admin.site.register(ClassAssignment, ClassAssignmentAdmin)
admin.site.register(ClassAssignmentRecord, ClassAssignmentRecordAdmin)

# 学科分类管理
class SubjectAdmin(admin.ModelAdmin):
    list_display = ('name', 'code', 'icon', 'color', 'description', 'created_at')
    list_filter = ('created_at',)
    search_fields = ('name', 'code', 'description')
    ordering = ('name',)
    fieldsets = (
        ('基本信息', {'fields': ('name', 'code', 'icon', 'color')}),
        ('描述', {'fields': ('description',)}),
    )
    prepopulated_fields = {'code': ('name',)}
    
    def formfield_for_dbfield(self, db_field, request, **kwargs):
        field = super().formfield_for_dbfield(db_field, request, **kwargs)
        if db_field.name == 'color':
            field.widget.attrs['type'] = 'color'
        return field

class ChapterAdmin(admin.ModelAdmin):
    list_display = ('subject', 'number', 'title', 'description', 'section_count')
    list_filter = ('subject',)
    search_fields = ('title', 'description')
    ordering = ('subject', 'number')
    list_select_related = ('subject',)
    
    def section_count(self, obj):
        return obj.sections.count()
    section_count.short_description = '小节数量'

class SectionAdmin(admin.ModelAdmin):
    list_display = ('chapter', 'full_number', 'title', 'knowledge_point_count')
    list_filter = ('chapter__subject', 'chapter')
    search_fields = ('title',)
    ordering = ('chapter', 'number')
    list_select_related = ('chapter', 'chapter__subject')
    
    def knowledge_point_count(self, obj):
        return obj.knowledge_points.count()
    knowledge_point_count.short_description = '知识点数量'

class KnowledgePointAdmin(admin.ModelAdmin):
    list_display = ('subject', 'name', 'section', 'difficulty', 'description')
    list_filter = ('subject', 'difficulty', 'section__chapter__subject')
    search_fields = ('name', 'description')
    ordering = ('subject', 'name')
    list_select_related = ('subject', 'section', 'section__chapter')
    
    def formfield_for_foreignkey(self, db_field, request, **kwargs):
        if db_field.name == 'section':
            if request.GET.get('subject'):
                kwargs['queryset'] = Section.objects.filter(chapter__subject_id=request.GET['subject'])
        return super().formfield_for_foreignkey(db_field, request, **kwargs)

admin.site.register(Subject, SubjectAdmin)
admin.site.register(Chapter, ChapterAdmin)
admin.site.register(Section, SectionAdmin)
admin.site.register(KnowledgePoint, KnowledgePointAdmin)
admin.site.register(Notification, NotificationAdmin)
admin.site.register(Announcement, AnnouncementAdmin)
