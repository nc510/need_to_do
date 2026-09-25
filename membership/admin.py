from django import forms
from django.contrib import admin
from django.core.exceptions import PermissionDenied
from django.http import HttpResponse, HttpResponseRedirect
from django.shortcuts import render
from django.urls import path, reverse
from django.utils import timezone

from .models import CardKey, Order, Plan, RechargeConfig
from .services import CardKeyError, generate_card_keys


@admin.register(Plan)
class PlanAdmin(admin.ModelAdmin):
    list_display = (
        'name', 'price', 'final_price_display', 'discount_display',
        'duration_days', 'is_active', 'sort_order', 'created_at',
    )
    list_editable = ('price', 'duration_days', 'is_active', 'sort_order')
    list_filter = ('is_active',)
    search_fields = ('name',)
    ordering = ('sort_order', 'id')

    @admin.display(description='折后价(元)')
    def final_price_display(self, obj):
        return obj.final_price

    @admin.display(description='当前折扣')
    def discount_display(self, obj):
        if obj.is_discounted:
            return f'{obj.discount_label}（省 {obj.saved_amount} 元）'
        return '无折扣'


@admin.register(RechargeConfig)
class RechargeConfigAdmin(admin.ModelAdmin):
    """会员充值折扣（单例）：对全部会员套餐统一生效"""

    fieldsets = (
        ('会员充值折扣', {
            'fields': ('discount_rate',),
            'description': (
                '对全部上架会员套餐统一生效：用户下单时按此折扣计算实付金额，'
                '套餐列表与支付页会同步展示折后价。<br>'
                '填 10 表示无折扣；填 9 表示 9 折（按原价的 90% 收取）；'
                '填 8.5 表示 85 折。仅对设置后新下的订单生效，历史订单金额不变。'
            ),
        }),
    )

    def has_add_permission(self, request):
        # 单例：仅当配置不存在时允许新增
        return not RechargeConfig.objects.exists()

    def has_delete_permission(self, request, obj=None):
        return False

    def changelist_view(self, request, extra_context=None):
        # 单例：列表页直接跳转到唯一的配置对象
        obj = RechargeConfig.get_solo()
        return HttpResponseRedirect(reverse('admin:membership_rechargeconfig_change', args=[obj.pk]))


@admin.register(Order)
class OrderAdmin(admin.ModelAdmin):
    list_display = ('order_no', 'user', 'plan', 'discount_label_display', 'amount', 'status', 'trade_no', 'created_at', 'paid_at')
    list_filter = ('status', 'plan', 'created_at')
    search_fields = ('order_no', 'trade_no', 'user__username')
    readonly_fields = ('order_no', 'discount_rate', 'trade_no', 'created_at', 'paid_at')
    ordering = ('-id',)
    # 不启用 date_hierarchy：它依赖 MySQL CONVERT_TZ（需加载时区表），
    # 当前数据库未安装时区定义会导致列表页 500；时间筛选走 list_filter 即可

    @admin.display(description='下单折扣', ordering='discount_rate')
    def discount_label_display(self, obj):
        return obj.discount_label


class CardKeyGenerateForm(forms.Form):
    """卡密批量生成表单：选类型 + 填权益数值 + 数量，一次生成一个批次的卡密。"""

    kind = forms.ChoiceField(
        label='卡密类型', choices=CardKey.KIND_CHOICES, initial=CardKey.KIND_MEMBER,
        help_text='高级功能卡密用于开通/续期高级功能；星币卡密用于到账星币。')
    duration_days = forms.IntegerField(
        label='高级功能天数', required=False, min_value=1, max_value=3650,
        help_text='仅「高级功能卡密」需要填写，如 30 表示兑换后开通/续期 30 天。')
    coins = forms.IntegerField(
        label='到账星币', required=False, min_value=1, max_value=1000000,
        help_text='仅「星币卡密」需要填写，如 1000 表示兑换后到账 1000 星币。')
    quantity = forms.IntegerField(
        label='生成数量', min_value=1, max_value=1000, initial=20,
        help_text='一次最多生成 1000 张；生成后请用列表页的「导出所选卡密」下载上架。')
    remark = forms.CharField(
        label='备注', required=False, max_length=100,
        widget=forms.TextInput(attrs={'size': 50}),
        help_text='便于事后对账，例如「淘宝 30 天卡 6 月批次」。')

    def clean(self):
        cleaned = super().clean()
        kind = cleaned.get('kind')
        if kind == CardKey.KIND_MEMBER and not cleaned.get('duration_days'):
            self.add_error('duration_days', '高级功能卡密必须填写有效天数。')
        if kind == CardKey.KIND_STARCOIN and not cleaned.get('coins'):
            self.add_error('coins', '星币卡密必须填写到账星币。')
        return cleaned


@admin.register(CardKey)
class CardKeyAdmin(admin.ModelAdmin):
    """卡密管理：批量生成、导出上架、作废，以及核销情况跟踪。"""

    list_display = ('display_code_display', 'kind', 'benefit_display', 'status',
                    'batch_no', 'used_by', 'used_at', 'created_at')
    list_filter = ('kind', 'status', 'batch_no')
    search_fields = ('code', 'batch_no', 'used_by__username', 'remark')
    readonly_fields = ('code', 'kind', 'duration_days', 'coins', 'status', 'batch_no',
                       'remark', 'used_by', 'used_at', 'created_by', 'created_at')
    ordering = ('-id',)
    actions = ('action_export_txt', 'action_disable')
    change_list_template = 'admin/membership/cardkey/change_list.html'
    # 不启用 date_hierarchy：依赖 MySQL 时区表（CONVERT_TZ），未安装会导致列表页 500

    def has_add_permission(self, request):
        # 卡密统一走「批量生成」入口，避免逐张手工录入
        return False

    def get_urls(self):
        custom_urls = [
            path('generate/', self.admin_site.admin_view(self.generate_view),
                 name='membership_cardkey_generate'),
        ]
        return custom_urls + super().get_urls()

    @admin.display(description='卡密')
    def display_code_display(self, obj):
        return obj.display_code

    @admin.display(description='可兑换权益')
    def benefit_display(self, obj):
        return obj.benefit_label

    @admin.action(description='📤 导出所选卡密（txt，每行一张）')
    def action_export_txt(self, request, queryset):
        codes = list(queryset.order_by('id').values_list('code', flat=True))
        if not codes:
            self.message_user(request, '没有可导出的卡密')
            return
        response = HttpResponse(
            '\n'.join(codes) + '\n', content_type='text/plain; charset=utf-8')
        filename = f'card_keys_{timezone.now():%Y%m%d%H%M%S}.txt'
        response['Content-Disposition'] = f'attachment; filename="{filename}"'
        return response

    @admin.action(description='🚫 作废所选卡密（仅未使用的）')
    def action_disable(self, request, queryset):
        updated = queryset.filter(status=CardKey.STATUS_UNUSED).update(
            status=CardKey.STATUS_DISABLED)
        self.message_user(request, f'已作废 {updated} 张未使用的卡密（已使用的卡密不受影响）')

    def generate_view(self, request):
        """批量生成卡密：生成结果直接展示，可复制或回列表页导出"""
        if not self.has_change_permission(request):
            raise PermissionDenied

        result = None
        if request.method == 'POST':
            form = CardKeyGenerateForm(request.POST)
            if form.is_valid():
                data = form.cleaned_data
                try:
                    batch_no, cards = generate_card_keys(
                        data['kind'], data['quantity'],
                        duration_days=data.get('duration_days') or 0,
                        coins=data.get('coins') or 0,
                        remark=(data.get('remark') or '').strip(),
                        operator=request.user)
                except CardKeyError as exc:
                    form.add_error(None, str(exc))
                else:
                    result = {'batch_no': batch_no, 'cards': cards, 'count': len(cards)}
                    form = CardKeyGenerateForm(initial={'kind': data['kind']})
        else:
            form = CardKeyGenerateForm()

        return render(request, 'admin/membership/cardkey/generate.html', {
            **self.admin_site.each_context(request),
            'title': '批量生成卡密',
            'form': form,
            'result': result,
            'opts': self.model._meta,
        })
