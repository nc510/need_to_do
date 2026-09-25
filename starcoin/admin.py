"""星币体系后台管理。

注意：所有列表页均不启用 date_hierarchy —— 它依赖 MySQL CONVERT_TZ（需加载时区表），
当前数据库未安装时区定义会导致 500，时间筛选统一走 list_filter。
"""

import logging
import re
from collections import defaultdict
from urllib.parse import urlencode

from django import forms
from django.contrib import admin
from django.contrib.auth.models import User
from django.core.exceptions import PermissionDenied, ValidationError
from django.core.paginator import Paginator
from django.db import transaction
from django.db.models import Count, Max, Q, Sum
from django.http import HttpResponseRedirect
from django.shortcuts import render
from django.urls import path, reverse

from quiz.models import Class, Notification

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
from .services import (
    StarCoinError,
    apply_instant_effect,
    cancel_redemption,
    earn,
    fulfill_redemption,
    grant_item,
)

logger = logging.getLogger(__name__)

# 后台赠送的流水来源标识（StarTransaction.ref_type）
GIFT_REF_TYPE = 'admin_gift'


class StarGiftForm(forms.Form):
    """后台赠送表单：一次给一名或多名用户赠送星币 / 道具。

    单人即只填一个用户；批量可粘贴多行名单，或直接勾选班级。
    """

    users = forms.CharField(
        label='接收用户', required=False,
        widget=forms.Textarea(attrs={
            'rows': 6, 'placeholder': '每行一个：用户名 / 姓名 / 手机号'}),
        help_text='每行一个（也可用逗号、空格分隔），支持用户名、姓名、手机号；重复的自动去重。')
    classes = forms.ModelMultipleChoiceField(
        label='按班级批量', queryset=Class.objects.all(), required=False,
        widget=forms.CheckboxSelectMultiple,
        help_text='勾选即选中、取消勾选即移除；所选班级的全部成员都会收到本次赠送（与上方名单合并）。')
    coins = forms.IntegerField(
        label='赠送星币', required=False, min_value=1, max_value=1000000,
        help_text='正整数，留空表示不赠星币；赠送星币不计入星力榜（活跃奖励）。')
    item = forms.ModelChoiceField(
        label='赠送道具', queryset=StarItem.objects.filter(is_active=True),
        required=False, empty_label='— 不赠送道具 —',
        help_text='仅列出上架中的道具。即时生效型（会员卡 / 斩题卡 / 正确率重置卡）赠送后立即生效；'
                  '背包使用型进入用户背包；人工核销型直接记为「已发放」。')
    quantity = forms.IntegerField(
        label='道具数量', required=False, min_value=1, max_value=100, initial=1,
        help_text='每人获赠的道具张数，默认 1。')
    reason = forms.CharField(
        label='赠送原因', required=False, max_length=80,
        widget=forms.TextInput(attrs={'size': 60}),
        help_text='记录到星币流水与兑换记录中，便于事后对账，例如「月考进步奖励」。')

    def clean(self):
        cleaned = super().clean()
        coins = cleaned.get('coins')
        item = cleaned.get('item')
        quantity = cleaned.get('quantity') or 1
        if not coins and not item:
            raise ValidationError('请至少填写「赠送星币」或选择「赠送道具」其中一项。')
        if item is not None:
            cleaned['quantity'] = quantity
            if item.effect_type == StarItem.EFFECT_ACCURACY_RESET and quantity != 1:
                self.add_error('quantity', f'「{item.name}」一次只能赠送 1 张。')
        return cleaned


# 名单分隔符：换行、空格、中英文逗号、顿号、分号
_GIFT_NAME_SPLIT_RE = re.compile(r'[\s,，、;；]+')


def _resolve_gift_users(raw_text, classes):
    """把「名单文本 + 班级」解析成待赠送用户列表，返回 (users, problems)。

    只有用户名/姓名/手机号能唯一定位到一个用户时才计入：命中 0 个或命中多个都记入
    problems 而不发放 —— 赠送（尤其是补偿）发错人的代价比漏发更大。
    """
    users, problems, seen = [], [], set()

    for class_obj in classes:
        for user in User.objects.filter(profile__class_obj=class_obj).distinct():
            if user.pk not in seen:
                seen.add(user.pk)
                users.append(user)

    for token in dict.fromkeys(_GIFT_NAME_SPLIT_RE.split(raw_text or '')):
        token = token.strip()
        if not token:
            continue
        matches = list(User.objects.filter(
            Q(username=token) | Q(first_name=token)
            | Q(profile__name=token) | Q(profile__phone_number=token)).distinct())
        if not matches:
            problems.append(f'「{token}」未找到对应用户')
        elif len(matches) > 1:
            problems.append(f'「{token}」匹配到 {len(matches)} 个用户，无法确定，请改用用户名或手机号')
        elif matches[0].pk not in seen:
            seen.add(matches[0].pk)
            users.append(matches[0])

    return users, problems


# 赠送通知里道具入账的说法（按发放方式区分）
GIFT_ITEM_DELIVERY_TEXT = {
    StarItem.MODE_INSTANT: '已立即生效',
    StarItem.MODE_INVENTORY: '已放入背包，可在需要时使用',
    StarItem.MODE_MANUAL: '已发放',
}


def _gift_notification_text(coins, item, quantity, reason):
    """赠送通知的标题与内容，如「🎁 收到管理员赠送：50 星币 + 回响之杖 ×2」"""
    summary = []
    lines = []
    if coins:
        summary.append(f'{coins} 星币')
        lines.append(f'星币 {coins} 已到账，可在星币中心查看余额与明细。')
    if item:
        summary.append(f'{item.name} ×{quantity}')
        lines.append(f'道具「{item.name}」×{quantity} {GIFT_ITEM_DELIVERY_TEXT[item.delivery_mode]}。')
    if reason:
        lines.append(f'赠送原因：{reason}')
    return f'🎁 收到管理员赠送：{" + ".join(summary)}', '\n'.join(lines)


# ===== 星币 / 道具统计汇总 =====

# 汇总表每页条数
SUMMARY_PAGE_SIZE = 50

# 汇总表排序方式：key -> 文案（排序键见 _sort_summary_rows）
SUMMARY_SORT_CHOICES = [
    ('balance', '星币余额（多 → 少）'),
    ('balance_asc', '星币余额（少 → 多）'),
    ('earned', '累计获得（多 → 少）'),
    ('items', '道具可用（多 → 少）'),
    ('class', '按班级'),
    ('username', '按用户名'),
]


def _collect_coin_item_rows(keyword='', class_id='', include_empty=False):
    """汇总每个人的星币与道具数据，返回 (rows, totals)。

    口径：
    - 星币取账户上的累计字段（余额 = 流水累加，见 services.earn / spend）；
    - 道具「可用」= Σ(兑换数 - 已用数)，只统计「已发放」记录，与
      services.available_quantity 同源；「待发放」为人工核销类尚未处理的张数；
    - 兑换「花费星币」含赠送记录（赠送成本为 0），已取消的记录不计。
    """
    users = User.objects.all()
    if not include_empty:
        users = users.filter(Q(star_account__isnull=False) | Q(star_redemptions__isnull=False))
    if keyword:
        users = users.filter(Q(username__icontains=keyword)
                             | Q(first_name__icontains=keyword)
                             | Q(profile__name__icontains=keyword)
                             | Q(profile__phone_number__icontains=keyword))
    if class_id:
        users = users.filter(profile__class_obj_id=class_id)

    accounts = {row['user_id']: row for row in StarAccount.objects.values(
        'user_id', 'balance', 'active_earned', 'recharge_earned', 'total_spent')}

    items_by_user = defaultdict(list)
    pending_by_user = defaultdict(int)
    # 注意：必须 order_by() 清掉模型默认排序（StarRedemption.Meta.ordering = ['-id']），
    # 否则 Django 会把 id 并进 GROUP BY，导致每条兑换记录各自成组、聚合失效。
    for row in (StarRedemption.objects
                .values('user_id', 'item_id', 'item__name', 'item__icon',
                        'item__sort_order', 'status')
                .annotate(total=Sum('quantity'), used=Sum('used_quantity'))
                .order_by()):
        if row['status'] == StarRedemption.STATUS_PENDING:
            pending_by_user[row['user_id']] += row['total'] or 0
        elif row['status'] == StarRedemption.STATUS_FULFILLED:
            items_by_user[row['user_id']].append({
                'id': row['item_id'],
                'name': row['item__name'],
                'icon': row['item__icon'],
                'sort': row['item__sort_order'] or 0,
                'avail': (row['total'] or 0) - (row['used'] or 0),
                'used': row['used'] or 0,
            })

    exchange_by_user = {row['user_id']: row for row in (
        StarRedemption.objects.exclude(status=StarRedemption.STATUS_CANCELLED)
        .values('user_id')
        .annotate(times=Count('id'), coins=Sum('coins_cost'), last_at=Max('created_at'))
        .order_by())}

    rows = []
    for user in users.select_related('profile', 'profile__class_obj').distinct():
        account = accounts.get(user.pk) or {}
        items = sorted(items_by_user.get(user.pk, []), key=lambda item: (item['sort'], item['id']))
        exchange = exchange_by_user.get(user.pk) or {}
        active_earned = account.get('active_earned') or 0
        recharge_earned = account.get('recharge_earned') or 0
        profile = getattr(user, 'profile', None)
        class_obj = getattr(profile, 'class_obj', None)
        rows.append({
            'user_id': user.pk,
            'username': user.username,
            'name': (getattr(profile, 'name', '') or user.first_name or ''),
            'class_name': str(class_obj) if class_obj else '',
            'balance': account.get('balance') or 0,
            'active_earned': active_earned,
            'recharge_earned': recharge_earned,
            'earned': active_earned + recharge_earned,
            'spent': account.get('total_spent') or 0,
            'item_avail': sum(item['avail'] for item in items),
            'item_used': sum(item['used'] for item in items),
            'pending': pending_by_user.get(user.pk, 0),
            'exchange_times': exchange.get('times') or 0,
            'exchange_coins': exchange.get('coins') or 0,
            'last_exchange_at': exchange.get('last_at'),
            'items': items,
        })

    totals = {
        'users': len(rows),
        'balance': sum(row['balance'] for row in rows),
        'earned': sum(row['earned'] for row in rows),
        'spent': sum(row['spent'] for row in rows),
        'item_avail': sum(row['item_avail'] for row in rows),
        'pending': sum(row['pending'] for row in rows),
    }
    return rows, totals


def _sort_summary_rows(rows, sort_key):
    """按所选方式排序（星币与道具口径不同，统一在内存里排）"""
    if sort_key == 'class':
        # 没有班级的排在最后
        return sorted(rows, key=lambda row: (not row['class_name'], row['class_name'],
                                             row['username'].lower()))
    if sort_key == 'username':
        return sorted(rows, key=lambda row: row['username'].lower())
    key = {
        'balance': lambda row: -row['balance'],
        'balance_asc': lambda row: row['balance'],
        'earned': lambda row: -row['earned'],
        'items': lambda row: -row['item_avail'],
    }.get(sort_key, lambda row: -row['balance'])
    return sorted(rows, key=lambda row: (key(row), row['username'].lower()))


@admin.register(StarAccount)
class StarAccountAdmin(admin.ModelAdmin):
    list_display = ('user', 'balance', 'active_earned', 'recharge_earned', 'total_spent', 'updated_at')
    search_fields = ('user__username', 'user__first_name')
    readonly_fields = ('balance', 'active_earned', 'recharge_earned', 'total_spent',
                       'created_at', 'updated_at')
    ordering = ('-balance', 'user_id')
    actions = ('action_gift',)
    change_list_template = 'admin/starcoin/staraccount/change_list.html'

    @admin.display(description='累计获得')
    def total_earned_display(self, obj):
        return obj.total_earned

    def get_urls(self):
        """追加「赠送星币 / 道具」与「统计汇总」页面（列表页按钮与批量动作都跳到它们）"""
        custom_urls = [
            path('gift/', self.admin_site.admin_view(self.gift_view), name='starcoin_gift'),
            path('summary/', self.admin_site.admin_view(self.summary_view),
                 name='starcoin_summary'),
        ]
        return custom_urls + super().get_urls()

    @admin.action(description='🎁 赠送星币 / 道具')
    def action_gift(self, request, queryset):
        """把勾选的账户带到赠送页预填名单，避免逐个手输用户名"""
        user_ids = ','.join(str(pk) for pk in queryset.values_list('user_id', flat=True))
        return HttpResponseRedirect(f'{reverse("admin:starcoin_gift")}?users={user_ids}')

    def summary_view(self, request):
        """个人星币 / 道具统计汇总：每人一行，可搜索、按班级与排序查看"""
        if not self.has_view_permission(request):
            raise PermissionDenied

        keyword = (request.GET.get('q') or '').strip()
        class_id = (request.GET.get('class_id') or '').strip()
        sort_key = request.GET.get('sort') or SUMMARY_SORT_CHOICES[0][0]
        include_empty = request.GET.get('include_empty') == '1'

        rows, totals = _collect_coin_item_rows(keyword, class_id, include_empty)
        rows = _sort_summary_rows(rows, sort_key)
        page = Paginator(rows, SUMMARY_PAGE_SIZE).get_page(request.GET.get('page'))

        query = {'sort': sort_key}
        if keyword:
            query['q'] = keyword
        if class_id:
            query['class_id'] = class_id
        if include_empty:
            query['include_empty'] = '1'

        return render(request, 'admin/starcoin/summary.html', {
            **self.admin_site.each_context(request),
            'title': '星币道具统计汇总',
            'opts': self.model._meta,
            'rows': page.object_list,
            'page_obj': page,
            'totals': totals,
            'classes': Class.objects.all(),
            'keyword': keyword,
            'class_id': class_id,
            'sort_key': sort_key,
            'include_empty': include_empty,
            'sort_choices': SUMMARY_SORT_CHOICES,
            'base_query': urlencode(query),
        })

    def gift_view(self, request):
        """赠送星币 / 道具：一次给一名或多名用户发放（针对性奖励与补偿）"""
        if not self.has_change_permission(request):
            raise PermissionDenied

        if request.method == 'POST':
            form = StarGiftForm(request.POST)
            if form.is_valid():
                result = self._run_gift(form.cleaned_data, request.user)
                form = StarGiftForm()  # 清空表单，便于连续赠送
            else:
                result = None
        else:
            form = StarGiftForm(initial=self._gift_initial(request))
            result = None

        return render(request, 'admin/starcoin/gift.html', {
            **self.admin_site.each_context(request),
            'title': '赠送星币 / 道具',
            'form': form,
            'result': result,
            'opts': self.model._meta,
        })

    @staticmethod
    def _gift_initial(request):
        """从「星币账户」列表勾选跳转过来时预填名单"""
        raw = request.GET.get('users', '')
        ids = [int(value) for value in raw.split(',') if value.strip().isdigit()]
        if not ids:
            return {}
        usernames = User.objects.filter(pk__in=ids).values_list('username', flat=True)
        return {'users': '\n'.join(usernames)}

    def _run_gift(self, cleaned, operator):
        """逐个用户发放并返回结果明细：单个用户失败不影响其他用户。

        每个用户一个事务：星币与道具要么都到账，要么都不动（例如即时生效型道具
        配置有误时会整体回滚，不会出现「扣了记录却没生效」）。
        """
        users, problems = _resolve_gift_users(cleaned['users'], cleaned['classes'])
        coins = cleaned.get('coins') or 0
        item = cleaned.get('item')
        quantity = cleaned.get('quantity') or 1
        reason = (cleaned.get('reason') or '').strip()

        remark = f'后台赠送：{reason}' if reason else '后台赠送'
        admin_remark = f'后台赠送（操作人：{operator.get_username()}）'
        if reason:
            admin_remark += f' 原因：{reason}'

        success, failed = [], []
        for user in users:
            try:
                with transaction.atomic():
                    if coins:
                        earn(user, coins, StarTransaction.KIND_ADMIN,
                             ref_type=GIFT_REF_TYPE, remark=remark)
                    if item:
                        redemption = grant_item(user, item, quantity, remark=remark,
                                                admin_remark=admin_remark, operator=operator)
                        if item.delivery_mode == StarItem.MODE_INSTANT:
                            apply_instant_effect(user, item, redemption, quantity=quantity)
            except StarCoinError as exc:
                failed.append((user, str(exc)))
            except Exception:
                logger.exception('后台赠送失败：user=%s item=%s',
                                 user.pk, getattr(item, 'pk', None))
                failed.append((user, '系统异常，请查看服务器日志'))
            else:
                success.append(user)

        notified = self._notify_gift_sent(success, coins, item, quantity, reason, operator)

        return {
            'executed': bool(users),
            'coins': coins, 'item': item, 'quantity': quantity, 'reason': reason,
            'success': success, 'failed': failed, 'problems': problems,
            'notified': notified,
        }

    @staticmethod
    def _notify_gift_sent(users, coins, item, quantity, reason, operator):
        """给受赠用户发站内通知，返回是否发送成功。

        发送放在各用户的发放事务之外：通知失败只记日志，不影响已经到账的星币/道具。
        """
        if not users:
            return False
        title, content = _gift_notification_text(coins, item, quantity, reason)
        try:
            Notification.notify_many(
                recipients=users, sender=operator, ntype='system',
                title=title, content=content, link=reverse('starcoin:center'))
        except Exception:
            logger.exception('后台赠送站内通知发送失败（受赠 %s 人）', len(users))
            return False
        return True


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
