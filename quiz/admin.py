from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from django.contrib.auth.models import User
from django.contrib.auth.forms import UserChangeForm, UserCreationForm, AdminPasswordChangeForm
from django.urls import reverse
from django.utils.html import format_html
from django.http import HttpResponseRedirect
from django import forms
from .models import Question, TestPaper, Profile, TestRecord, AnswerRecord, WrongQuestion, Class, ClassAdmin, ClassApplication, ClassAssignment, ClassAssignmentRecord

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

class CustomUserAdmin(UserAdmin):
    form = CustomUserChangeForm
    add_form = CustomUserCreationForm

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

            if obj.is_superuser:
                password_management_fieldset = (
                    '🔐 密码管理', {
                        'description': format_html(
                            '<div style="background: #d4edda; border: 1px solid #c3e6cb; padding: 15px; border-radius: 4px; margin-bottom: 10px;">'
                            '<p style="font-weight: bold; color: #155724; margin-bottom: 10px;">🔐 超级管理员密码保护</p>'
                            '<p style="color: #155724; margin-bottom: 10px;">此用户为超级管理员，密码修改需要谨慎操作。</p>'
                            '<a href="{}" class="btn btn-danger">🔄 修改密码</a>'
                            '</div>',
                            change_password_url
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
                            '<a href="{}" class="btn btn-danger">🔄 修改密码</a>'
                            '</div>',
                            change_password_url
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

class ProfileAdmin(admin.ModelAdmin):
    list_display = ('user', 'approval_status', 'created_at', 'updated_at')
    list_filter = ('approval_status', 'created_at')
    search_fields = ('user__username', 'user__email')
    ordering = ('-created_at',)
    readonly_fields = ('created_at', 'updated_at')

class QuestionAdmin(admin.ModelAdmin):
    list_display = ('id', 'type', 'content', 'score', 'created_at')
    list_filter = ('type', 'created_at')
    search_fields = ('content', 'explanation')
    ordering = ('-created_at',)
    fields = ('type', 'content', 'options', 'correct_answer', 'score', 'explanation')

class TestPaperAdmin(admin.ModelAdmin):
    list_display = ('id', 'title', 'total_score', 'question_count', 'is_published', 'created_by', 'created_at')
    list_filter = ('is_published', 'created_at')
    search_fields = ('title', 'description')
    ordering = ('-created_at',)
    filter_horizontal = ('questions',)
    fields = ('title', 'description', 'questions', 'is_published')
    readonly_fields = ('total_score', 'created_at', 'created_by')

    def question_count(self, obj):
        return obj.questions.count()
    question_count.short_description = '题目数量'

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

    def answered_at(self, obj):
        if hasattr(obj, 'answered_at'):
            return obj.answered_at
        return 'N/A'
    answered_at.short_description = '答题时间'

class WrongQuestionAdmin(admin.ModelAdmin):
    list_display = ('user', 'question', 'user_answer', 'correct_answer_display', 'added_at')
    list_filter = ('added_at',)
    search_fields = ('user__username', 'question__content')
    ordering = ('-added_at',)

    def correct_answer_display(self, obj):
        return format_html('<span style="color: #4caf50; font-weight: bold;">{}</span>', obj.question.correct_answer)
    correct_answer_display.short_description = '正确答案'

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
