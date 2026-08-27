from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from django.contrib.auth.models import User
from django.contrib.auth.forms import UserChangeForm, UserCreationForm, AdminPasswordChangeForm
from django.urls import reverse
from django.utils.html import format_html
from django.http import HttpResponseRedirect
from django import forms
from .models import Question, TestPaper, Profile, TestRecord, AnswerRecord, WrongQuestion, Class, ClassAdmin, ClassApplication, ClassAssignment, ClassAssignmentRecord, Subject, Chapter, Section, KnowledgePoint, Notification

admin.site.site_header = '📚 在线考试系统管理后台'
admin.site.site_title = '考试系统管理'
admin.site.index_title = '欢迎使用在线考试系统管理后台'

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
    list_display = ('user', 'name', 'role', 'approval_status', 'phone_number', 'class_obj', 'created_at', 'updated_at')
    list_filter = ('role', 'approval_status', 'class_obj', 'created_at')
    list_editable = ('role', 'approval_status')
    search_fields = ('user__username', 'user__email', 'name', 'phone_number')
    ordering = ('-created_at',)
    readonly_fields = ('created_at', 'updated_at')

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
    list_display = ('id', 'title', 'total_score', 'question_count', 'is_published', 'is_public', 'duration', 'max_attempts', 'created_by', 'created_at', 'action_buttons')
    list_display_links = ('id', 'title')
    list_filter = ('is_published', 'is_public', 'created_by', 'created_at')
    search_fields = ('title', 'description', 'created_by')
    ordering = ('-created_at',)
    filter_horizontal = ('questions',)
    fields = ('title', 'description', 'questions', 'is_published', 'is_public', 'duration', 'max_attempts', 'start_time', 'end_time')
    readonly_fields = ('total_score', 'created_at', 'created_by')
    change_list_template = 'admin/quiz/testpaper/change_list.html'
    change_form_template = 'admin/quiz/testpaper/change_form.html'
    actions = ['make_public', 'make_private', 'delete_selected']

    def has_add_permission(self, request):
        return False

    def formfield_for_manytomany(self, db_field, request, **kwargs):
        if db_field.name == 'questions':
            field = super().formfield_for_manytomany(db_field, request, **kwargs)
            field.label_from_instance = lambda obj: f'#{obj.id} {obj.content[:50]}'
            return field
        return super().formfield_for_manytomany(db_field, request, **kwargs)

    def question_count(self, obj):
        return obj.questions.count()
    question_count.short_description = '题目数量'

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
        obj.save()


class TestRecordAdmin(admin.ModelAdmin):
    list_display = ('user', 'test_paper', 'score', 'total_score', 'accuracy_rate', 'completed_at', 'is_wrong_paper_display')
    list_filter = ('completed_at', 'is_wrong_paper')
    search_fields = ('user__username', 'test_paper__title')
    ordering = ('-completed_at',)

    def accuracy_rate(self, obj):
        if obj.total_score > 0:
            rate = int(obj.score / obj.total_score * 100)
            color = '#4caf50' if rate >= 60 else '#f44336'
            return format_html('<span style="color: {}; font-weight: bold;">{}%</span>', color, rate)
        return '0%'
    accuracy_rate.short_description = '正确率'

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
