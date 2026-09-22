from django.contrib import admin
from django.http import HttpResponseRedirect
from django.urls import reverse

from .models import Order, Plan, RechargeConfig


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
