"""星币体系后台管理。

注意：所有列表页均不启用 date_hierarchy —— 它依赖 MySQL CONVERT_TZ（需加载时区表），
当前数据库未安装时区定义会导致 500，时间筛选统一走 list_filter。
"""

from django.contrib import admin
from django.http import HttpResponseRedirect
from django.urls import reverse

from .models import (
    StarAccount,
    StarItem,
    StarItemUsage,
    StarLoginGift,
    StarLoginStreak,
    StarPackage,
    StarRechargeOrder,
    StarRedemption,
    StarTask,
    StarTaskRecord,
    StarTransaction,
    StarWrongPaperConfig,
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
                    'member_price_display', 'delivery_display', 'stock_display',
                    'per_user_limit', 'is_active', 'sort_order')
    list_editable = ('price_coins', 'member_discount_rate', 'per_user_limit',
                     'is_active', 'sort_order')
    list_filter = ('is_active', 'category', 'effect_type')
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
                '折后星币按四舍五入取整，最低 1 星币且不超过原价。<br>'
                '<b>会员卡类道具（道具效果 = 会员卡）的折扣会被系统强制锁定为 10（无折扣）</b>，'
                '避免会员用折扣价兑换会员卡自我续期。'
            ),
        }),
        ('道具效果', {
            'fields': ('effect_type', 'effect_payload'),
            'description': (
                '决定兑换后如何发放：<br>'
                '· <b>留空</b>：沿用人工核销（待发放 → 后台核销发放）；<br>'
                '· <b>会员卡 / 正确率重置卡 / 斩题卡</b>：兑换后<b>立即生效</b>，无需人工核销；<br>'
                '· <b>改名卡 / 错题组卷卡 / 答案提示卡 / 头像框</b>：兑换后<b>进入背包</b>，'
                '用户在对应场景使用时消耗一张。<br>'
                '效果参数（JSON）：会员卡 {"days": 30}；斩题卡 {"count": 1}；头像框 {"frame": "gold"}。'
            ),
        }),
        ('状态', {
            'fields': ('is_active', 'sort_order'),
        }),
    )

    def get_readonly_fields(self, request, obj=None):
        readonly = list(super().get_readonly_fields(request, obj))
        # 会员卡类道具折扣锁定为 10（无折扣），避免会员低价自我续期套利
        if obj is not None and obj.effect_type == StarItem.EFFECT_MEMBER:
            readonly.append('member_discount_rate')
        return readonly

    @admin.display(description='发放方式')
    def delivery_display(self, obj):
        return obj.delivery_mode_label

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
    list_display = ('id', 'user', 'item', 'quantity', 'used_display', 'original_coins',
                    'coins_cost', 'discount_display', 'status', 'contact',
                    'created_at', 'fulfilled_at')
    list_filter = ('status', 'item')
    search_fields = ('user__username', 'item__name', 'contact')
    readonly_fields = ('user', 'item', 'quantity', 'used_quantity', 'original_coins',
                       'discount_rate', 'coins_cost', 'contact', 'user_remark',
                       'created_at', 'fulfilled_at', 'fulfilled_by')
    ordering = ('-id',)
    actions = ('action_mark_fulfilled', 'action_cancel_and_refund')

    @admin.display(description='已用/总数')
    def used_display(self, obj):
        if not obj.used_quantity:
            return '—'
        return f'{obj.used_quantity}/{obj.quantity}'

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


@admin.register(StarLoginGift)
class StarLoginGiftAdmin(admin.ModelAdmin):
    """每日登录赠礼配置：每天首次登录按用户身份赠送道具。"""

    list_display = ('item', 'effect_display', 'quantity_free', 'quantity_member',
                    'is_active', 'sort_order')
    list_editable = ('quantity_free', 'quantity_member', 'is_active', 'sort_order')
    list_filter = ('is_active',)
    search_fields = ('item__name',)
    ordering = ('sort_order', 'id')
    fieldsets = (
        ('赠送道具', {
            'fields': ('item',),
            'description': (
                '每天<b>首次登录</b>时自动赠送（同一天重复登录不重复赠送）。<br>'
                '只可选「入背包」类道具（改名卡 / 错题组卷卡 / 答案提示卡 / 头像框）：'
                '即时生效型道具没有背包使用入口，人工核销型道具由管理员发放，都不适合自动赠礼。'
            ),
        }),
        ('赠送张数', {
            'fields': ('quantity_free', 'quantity_member'),
            'description': (
                '「免费用户」与「会员」分别取对应张数，填 0 表示该身份不赠送。<br>'
                '会员身份以登录时刻的会员有效期为准（生效中才算会员）。<br>'
                '道具下架后会自动跳过赠送，避免发出无法使用的道具。'
            ),
        }),
        ('状态', {
            'fields': ('is_active', 'sort_order'),
        }),
    )

    @admin.display(description='道具效果')
    def effect_display(self, obj):
        return obj.item.get_effect_type_display() or '—'


@admin.register(StarWrongPaperConfig)
class StarWrongPaperConfigAdmin(admin.ModelAdmin):
    """错题组卷额度（单例）：免费用户每日免费组卷次数。"""

    fieldsets = (
        ('错题组卷额度', {
            'fields': ('free_daily_limit',),
            'description': (
                '免费用户每天可不消耗组卷卡组卷的次数，超出后每次组卷消耗 1 张组卷卡；<br>'
                '填 0 表示关闭免费额度（免费用户每次组卷都要用卡）。<br>'
                '任何用户单次组卷超过 10 题都必须用卡（用卡当次不限题量）；'
                '<b>会员组卷不限次数</b>，但单次超过 10 题同样需要用卡。<br>'
                '次数按自然日统计，次日自动重置。'
            ),
        }),
    )

    def has_add_permission(self, request):
        # 单例：仅当配置不存在时允许新增
        return not StarWrongPaperConfig.objects.exists()

    def has_delete_permission(self, request, obj=None):
        return False

    def changelist_view(self, request, extra_context=None):
        # 单例：列表页直接跳转到唯一的配置对象
        obj = StarWrongPaperConfig.get_solo()
        return HttpResponseRedirect(
            reverse('admin:starcoin_starwrongpaperconfig_change', args=[obj.pk]))


@admin.register(StarItemUsage)
class StarItemUsageAdmin(admin.ModelAdmin):
    """道具使用流水：仅查看，不允许手工增删改。"""

    list_display = ('id', 'user', 'item', 'effect_type', 'detail', 'context', 'created_at')
    list_filter = ('effect_type', 'item')
    search_fields = ('user__username', 'item__name', 'detail', 'context')
    readonly_fields = ('user', 'item', 'redemption', 'effect_type', 'detail',
                       'context', 'created_at')
    ordering = ('-id',)

    def has_add_permission(self, request):
        return False

    def has_change_permission(self, request, obj=None):
        return False

    def has_delete_permission(self, request, obj=None):
        return False
