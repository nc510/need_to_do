from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from django.contrib.auth.models import User
from django.contrib.auth.forms import UserChangeForm, UserCreationForm, AdminPasswordChangeForm
from django.urls import reverse
from django.utils.html import format_html
from django.http import HttpResponseRedirect
from django import forms
from .models import Question, TestPaper, Profile, TestRecord, AnswerRecord, WrongQuestion

class CustomUserChangeForm(UserChangeForm):
    # 添加明文密码显示字段
    plain_password_display = forms.CharField(
        label='明文密码',
        required=False,
        widget=forms.TextInput(attrs={'readonly': 'readonly', 'style': 'background: #f5f5f5; color: #333; font-weight: bold; font-size: 16px; padding: 8px; border: 1px solid #ccc; border-radius: 4px; width: 300px;'}),
        help_text='当前用户的明文密码（仅普通用户可见）'
    )
    
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
    
    list_display = ('username', 'email', 'first_name', 'last_name', 'is_staff', 'is_superuser', 'date_joined', 'show_plain_password', 'actions_column')
    list_filter = ('is_staff', 'is_superuser', 'is_active', 'date_joined')
    search_fields = ('username', 'email', 'first_name', 'last_name')
    ordering = ('-date_joined',)
    
    def show_plain_password(self, obj):
        if obj.is_superuser:
            return '***'
        try:
            profile = Profile.objects.get(user=obj)
            if profile.plain_password:
                return profile.plain_password
            else:
                return '未设置'
        except Profile.DoesNotExist:
            return '无'
    
    show_plain_password.short_description = '明文密码'
    
    def actions_column(self, obj):
        edit_url = reverse('admin:auth_user_change', args=[obj.pk])
        change_password_url = reverse('admin:auth_user_password_change', args=[obj.pk])
        
        if obj.is_superuser:
            return format_html(
                '<a href="{}" style="background: #409eff; color: white; padding: 6px 14px; border-radius: 4px; text-decoration: none; font-size: 12px; font-weight: bold; margin-right: 5px; display: inline-block;">✏️ 编辑</a>',
                edit_url
            )
        else:
            return format_html(
                '<a href="{}" style="background: #409eff; color: white; padding: 6px 14px; border-radius: 4px; text-decoration: none; font-size: 12px; font-weight: bold; margin-right: 5px; display: inline-block;">✏️ 编辑</a>'
                '<a href="{}" style="background: #dc3545; color: white; padding: 6px 14px; border-radius: 4px; text-decoration: none; font-size: 12px; font-weight: bold; display: inline-block;">🔄 修改密码</a>',
                edit_url, change_password_url
            )
    
    actions_column.short_description = '操作'
    
    def get_fieldsets(self, request, obj=None):
        fieldsets = super().get_fieldsets(request, obj)
        
        # 如果是超级用户，隐藏密码字段
        if obj and obj.is_superuser:
            fieldsets = [fs for fs in fieldsets if fs[0] != 'Password']
        else:
            # 为普通用户添加更显眼的密码管理区域
            if obj:
                try:
                    profile = Profile.objects.get(user=obj)
                    plain_pwd = profile.plain_password if profile.plain_password else '未设置'
                except Profile.DoesNotExist:
                    plain_pwd = '未设置'
                
                change_password_url = reverse('admin:auth_user_password_change', args=[obj.pk])
                
                # 创建自定义的密码管理字段集
                password_management_fieldset = (
                    '密码管理', {
                        'description': format_html(
                            '<div style="background: #fff3cd; border: 1px solid #ffeeba; padding: 15px; border-radius: 4px; margin-bottom: 10px;">'
                            '<p style="font-weight: bold; color: #856404; margin-bottom: 10px;">🔐 当前明文密码：<span style="font-size: 18px; color: #dc3545;">{}</span></p>'
                            '<a href="{}" style="background: #dc3545; color: white; padding: 10px 20px; border-radius: 4px; text-decoration: none; font-weight: bold; display: inline-block;">'
                            '🔄 修改密码'
                            '</a>'
                            '</div>',
                            plain_pwd, change_password_url
                        ),
                        'fields': ('plain_password_display',),
                    }
                )
                
                # 替换原有的Password字段集
                fieldsets = [fs for fs in fieldsets if fs[0] != 'Password']
                fieldsets.insert(1, password_management_fieldset)
        
        return fieldsets
    
    def save_model(self, request, obj, form, change):
        # 保存密码前先获取新密码
        new_password = None
        if 'password1' in form.cleaned_data and form.cleaned_data['password1']:
            new_password = form.cleaned_data['password1']
        elif 'password' in form.cleaned_data and form.cleaned_data['password']:
            new_password = form.cleaned_data['password']
        
        super().save_model(request, obj, form, change)
        
        # 如果设置了新密码，同步保存明文密码到Profile（仅非超级用户）
        if new_password and not obj.is_superuser:
            try:
                profile = Profile.objects.get(user=obj)
            except Profile.DoesNotExist:
                profile = Profile(user=obj)
            profile.plain_password = new_password
            profile.save()

class ProfileAdmin(admin.ModelAdmin):
    list_display = ('user', 'approval_status', 'plain_password', 'created_at', 'updated_at')
    list_filter = ('approval_status', 'created_at')
    search_fields = ('user__username', 'user__email')
    ordering = ('-created_at',)
    readonly_fields = ('plain_password',)

class QuestionAdmin(admin.ModelAdmin):
    list_display = ('id', 'type', 'content', 'score', 'created_at')
    list_filter = ('type', 'created_at')
    search_fields = ('content', 'explanation')
    ordering = ('-created_at',)
    fields = ('type', 'content', 'options', 'correct_answer', 'score', 'explanation')
    readonly_fields = ('created_at', 'updated_at')

class TestPaperAdmin(admin.ModelAdmin):
    list_display = ('id', 'title', 'total_score', 'is_published', 'created_by', 'created_at')
    list_filter = ('is_published', 'created_at')
    search_fields = ('title', 'description')
    ordering = ('-created_at',)
    filter_horizontal = ('questions',)
    fields = ('title', 'description', 'questions', 'is_published', 'created_by')
    readonly_fields = ('total_score', 'created_at')


class TestRecordAdmin(admin.ModelAdmin):
    list_display = ('user', 'test_paper', 'score', 'total_score', 'completed_at')
    list_filter = ('completed_at',)
    search_fields = ('user__username', 'test_paper__title')
    ordering = ('-completed_at',)

class AnswerRecordAdmin(admin.ModelAdmin):
    list_display = ('test_record', 'question', 'user_answer', 'correct_answer', 'is_correct')
    list_filter = ('is_correct',)
    search_fields = ('question__content', 'test_record__user__username')
    ordering = ('test_record',)

class WrongQuestionAdmin(admin.ModelAdmin):
    list_display = ('user', 'question', 'user_answer', 'added_at')
    list_filter = ('added_at',)
    search_fields = ('user__username', 'question__content')
    ordering = ('-added_at',)

# 注销默认的UserAdmin，注册自定义的
admin.site.unregister(User)
admin.site.register(User, CustomUserAdmin)

admin.site.register(Question, QuestionAdmin)
admin.site.register(TestPaper, TestPaperAdmin)
admin.site.register(Profile, ProfileAdmin)
admin.site.register(TestRecord, TestRecordAdmin)
admin.site.register(AnswerRecord, AnswerRecordAdmin)
admin.site.register(WrongQuestion, WrongQuestionAdmin)
