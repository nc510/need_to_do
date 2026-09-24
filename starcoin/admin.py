"""星币体系后台管理。

注意：所有列表页均不启用 date_hierarchy —— 它依赖 MySQL CONVERT_TZ（需加载时区表），
当前数据库未安装时区定义会导致 500，时间筛选统一走 list_filter。
"""

from django.contrib import admin

from .models import (
    StarAccount,
    StarItem,
    StarLoginStreak,
    StarPackage,
    StarRechargeOrder,
    StarRedemption,
    StarTask,
    StarTaskRecord,
    StarTransaction,
)
from .services import StarCoinError, cancel_redemption, fulfill_redemption


@admin.register(StarAccount)
class StarAccountAdmin(admin.ModelAdmin):
    list_display = ('user', 'balance', 'active_earned', 'recharge_earned', 'total_spent', 'updated_at')
    search_fields = ('user__username', 'user__first_name')
    readonly_fields = ('balance', 'active_earned', 'recharge_earned', 'total_spent',
                       'created_at', 'updated_at')
    ordering = ('-balance', 'user_id')

    @admin.display(description='累计获得')
    def total_earned_display(self, obj):
        return obj.total_earned


@admin.register(StarTransaction)
class StarTransactionAdmin(admin.ModelAdmin):
    list_display = ('user', 'amount', 'balance_after', 'kind', 'remark', 'created_at')
    list_filter = ('kind',)
    search_fields = ('user__username', 'remark')
    readonly_fields = ('user', 'amount', 'balance_after', 'kind', 'ref_type', 'ref_id',
                       'remark', 'created_at')
    ordering = ('-id',)

    def has_add_permission(self, request):
        # 流水只由业务/系统写入，禁止后台手工新增，保证与余额一致
        return False


@admin.register(StarPackage)
class StarPackageAdmin(admin.ModelAdmin):
    list_display = ('name', 'price', 'coins', 'bonus_coins', 'total_coins_display',
                    'is_active', 'sort_order')
    list_editable = ('price', 'coins', 'bonus_coins', 'is_active', 'sort_order')
    list_filter = ('is_active',)
    search_fields = ('name',)
    ordering = ('sort_order', 'id')

    @admin.display(description='到账星币')
    def total_coins_display(self, obj):
        return obj.total_coins


@admin.register(StarRechargeOrder)
class StarRechargeOrderAdmin(admin.ModelAdmin):
    list_display = ('order_no', 'user', 'package', 'amount', 'coins', 'status',
                    'trade_no', 'created_at', 'paid_at')
    list_filter = ('status', 'package')
    search_fields = ('order_no', 'trade_no', 'user__username')
    readonly_fields = ('order_no', 'amount', 'coins', 'trade_no', 'created_at', 'paid_at')
    ordering = ('-id',)


@admin.register(StarTask)
class StarTaskAdmin(admin.ModelAdmin):
    list_display = ('name', 'code', 'reward_coins', 'period', 'daily_limit', 'threshold',
                    'is_active', 'sort_order')
    list_editable = ('reward_coins', 'period', 'daily_limit', 'threshold', 'is_active', 'sort_order')
    list_filter = ('period', 'is_active')
    search_fields = ('name', 'code')
    ordering = ('sort_order', 'id')
    fieldsets = (
        ('任务信息', {
            'fields': ('code', 'name', 'description', 'icon'),
        }),
        ('奖励规则', {
            'fields': ('reward_coins', 'period', 'daily_limit', 'threshold'),
            'description': (
                '「任务标识」对应系统内已埋点的事件，不可随意新增；<br>'
                '「仅一次」永久只发一次；「每日一次」每天发一次；'
                '「每次触发」每次事件都发，可用「每日最多发放次数」限制（0 = 不限）。<br>'
                '「达标分数线」仅对「试卷达标」任务生效，按得分百分比判定。'
            ),
        }),
        ('状态', {
            'fields': ('is_active', 'sort_order'),
        }),
    )


@admin.register(StarTaskRecord)
class StarTaskRecordAdmin(admin.ModelAdmin):
    list_display = ('user', 'task', 'reward_coins', 'period_key', 'created_at')
    list_filter = ('task',)
    search_fields = ('user__username',)
    readonly_fields = ('user', 'task', 'reward_coins', 'period_key', 'created_at')
    ordering = ('-id',)

    def has_add_permission(self, request):
        return False


@admin.register(StarLoginStreak)
class StarLoginStreakAdmin(admin.ModelAdmin):
    list_display = ('user', 'current_days', 'longest_days', 'streak_start_date',
                    'last_login_date', 'updated_at')
    search_fields = ('user__username', 'user__first_name')
    readonly_fields = ('user', 'current_days', 'longest_days', 'streak_start_date',
                       'last_login_date', 'updated_at')
    ordering = ('-current_days', 'user_id')

    def has_add_permission(self, request):
        # 连续登录由登录流程自动维护，禁止后台手工新增
        return False


@admin.register(StarItem)
class StarItemAdmin(admin.ModelAdmin):
    list_display = ('name', 'category', 'price_coins', 'member_discount_rate',
                    'member_price_display', 'stock_display', 'per_user_limit',
                    'is_active', 'sort_order')
    list_editable = ('price_coins', 'member_discount_rate', 'per_user_limit',
                     'is_active', 'sort_order')
    list_filter = ('is_active', 'category')
    search_fields = ('name', 'category')
    ordering = ('sort_order', 'id')
    fieldsets = (
        ('道具信息', {
            'fields': ('name', 'description', 'icon', 'category'),
        }),
        ('价格与库存', {
            'fields': ('price_coins', 'member_discount_rate', 'stock', 'per_user_limit'),
            'description': (
                '「会员折扣」是会员专属权益，仅「会员生效中」的用户兑换时生效，'
                '非会员一律按原价扣星币。<br>'
                '10 表示无折扣；9 表示会员 9 折；8.5 表示 85 折，取值范围 0.01～10。<br>'
                '折后星币按四舍五入取整，最低 1 星币且不超过原价。'
            ),
        }),
        ('状态', {
            'fields': ('is_active', 'sort_order'),
        }),
    )

    @admin.display(description='库存')
    def stock_display(self, obj):
        return '不限' if obj.is_unlimited_stock else obj.stock

    @admin.display(description='会员价（星币）')
    def member_price_display(self, obj):
        if not obj.is_member_discounted:
            return '—'
        return f'{obj.member_price_coins}（省 {obj.member_saved_coins}）'


@admin.register(StarRedemption)
class StarRedemptionAdmin(admin.ModelAdmin):
    list_display = ('id', 'user', 'item', 'quantity', 'original_coins', 'coins_cost',
                    'discount_display', 'status', 'contact', 'created_at', 'fulfilled_at')
    list_filter = ('status', 'item')
    search_fields = ('user__username', 'item__name', 'contact')
    readonly_fields = ('user', 'item', 'quantity', 'original_coins', 'discount_rate',
                       'coins_cost', 'contact', 'user_remark', 'created_at',
                       'fulfilled_at', 'fulfilled_by')
    ordering = ('-id',)
    actions = ('action_mark_fulfilled', 'action_cancel_and_refund')

    @admin.display(description='会员折扣')
    def discount_display(self, obj):
        if not obj.is_discounted:
            return '无折扣'
        return f'{obj.discount_label} · 省 {obj.saved_coins} 星币'

    @admin.action(description='标记为已发放')
    def action_mark_fulfilled(self, request, queryset):
        done = skipped = 0
        for redemption in queryset:
            try:
                fulfill_redemption(redemption, operator=request.user)
                done += 1
            except StarCoinError:
                skipped += 1
        self.message_user(request, f'已发放 {done} 条，跳过 {skipped} 条（非待发放状态）')

    @admin.action(description='取消并退回星币')
    def action_cancel_and_refund(self, request, queryset):
        done = skipped = 0
        for redemption in queryset:
            try:
                cancel_redemption(redemption, operator=request.user)
                done += 1
            except StarCoinError:
                skipped += 1
        self.message_user(request, f'已取消并退回 {done} 条，跳过 {skipped} 条（非待发放状态）')
