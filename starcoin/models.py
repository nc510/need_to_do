"""星币体系数据模型。

设计要点：
- 星币账户（StarAccount）与答题统计（quiz.Profile）完全独立，互不影响。
- 余额变更一律经由 services.py 的 earn/spend，在事务内加锁并写流水（StarTransaction），
  保证「余额 = 流水累加」可审计、可对账。
- 榜单口径：星力榜 = active_earned（活跃奖励累计获得），星富榜 = balance（当前余额）。
"""

import uuid
from datetime import timedelta
from decimal import Decimal, ROUND_HALF_UP

from django.conf import settings
from django.core.validators import MaxValueValidator, MinValueValidator
from django.db import models
from django.utils import timezone

# 折扣率统一口径：10 折 = 原价（无折扣），数值越小越便宜
NO_DISCOUNT_RATE = Decimal('10.00')

# 头像框（道具「专属头像框」）预设样式：key -> 名称。
# key 写入 quiz.Profile.avatar_frame，前端按 `avatar-frame-{key}` 加样式类（见 base.html）。
AVATAR_FRAMES = (
    ('gold', '🥇 黄金之环'),
    ('silver', '🥈 白银之环'),
    ('purple', '💜 紫钻之环'),
    ('rainbow', '🌈 流光之环'),
)
MIN_DISCOUNT_RATE = Decimal('0.01')


def normalize_discount_rate(rate):
    """把折扣率容错限定在 0.01～10 之间（后台可能填越界值）"""
    rate = Decimal(rate)
    return min(max(rate, MIN_DISCOUNT_RATE), NO_DISCOUNT_RATE)


def format_discount_rate(rate):
    """折扣文案，如「9 折」「8.5 折」"""
    text = f'{Decimal(rate):.2f}'.rstrip('0').rstrip('.')
    return f'{text} 折'


class StarAccount(models.Model):
    """星币账户（每个用户一个）"""

    user = models.OneToOneField(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE,
        related_name='star_account', verbose_name='用户')
    balance = models.BigIntegerField('当前星币余额', default=0)
    # 星力榜口径：仅统计活跃任务奖励（不含充值），只增不减
    active_earned = models.BigIntegerField('活跃奖励累计获得', default=0)
    recharge_earned = models.BigIntegerField('充值累计获得', default=0)
    total_spent = models.BigIntegerField('累计消耗', default=0)
    created_at = models.DateTimeField('创建时间', auto_now_add=True)
    updated_at = models.DateTimeField('更新时间', auto_now=True)

    class Meta:
        verbose_name = '星币账户'
        verbose_name_plural = '星币账户'
        ordering = ['-balance', 'user_id']
        indexes = [models.Index(fields=['-balance']), models.Index(fields=['-active_earned'])]

    def __str__(self):
        return f'{self.user.username}（余额 {self.balance}）'

    @property
    def total_earned(self):
        """累计获得总额（充值 + 活跃奖励）"""
        return (self.active_earned or 0) + (self.recharge_earned or 0)

    @classmethod
    def get_or_create_for(cls, user):
        account, _created = cls.objects.get_or_create(user=user)
        return account


class StarTransaction(models.Model):
    """星币流水（每一笔余额变动都记一条，用于审计与对账）"""

    KIND_RECHARGE = 'recharge'
    KIND_ACTIVE = 'active'
    KIND_REDEEM = 'redeem'
    KIND_REFUND = 'refund'
    KIND_ADMIN = 'admin_adjust'
    KIND_CHOICES = [
        (KIND_RECHARGE, '充值获得'),
        (KIND_ACTIVE, '活跃奖励'),
        (KIND_REDEEM, '道具兑换'),
        (KIND_REFUND, '兑换退回'),
        (KIND_ADMIN, '管理员调整'),
    ]

    user = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE,
        related_name='star_transactions', verbose_name='用户')
    # 正数=获得，负数=消耗
    amount = models.BigIntegerField('变动数量')
    balance_after = models.BigIntegerField('变动后余额')
    kind = models.CharField('类型', max_length=20, choices=KIND_CHOICES)
    ref_type = models.CharField('来源类型', max_length=20, blank=True, default='')
    ref_id = models.CharField('来源标识', max_length=64, blank=True, default='')
    remark = models.CharField('备注', max_length=200, blank=True, default='')
    created_at = models.DateTimeField('创建时间', auto_now_add=True)

    class Meta:
        verbose_name = '星币流水'
        verbose_name_plural = '星币流水'
        ordering = ['-id']
        indexes = [models.Index(fields=['user', '-created_at'])]

    def __str__(self):
        sign = '+' if self.amount >= 0 else ''
        return f'{self.user.username} {sign}{self.amount}（余额 {self.balance_after}）'


class StarPackage(models.Model):
    """星币充值套餐：用户以人民币购买星币"""

    name = models.CharField('套餐名称', max_length=50)
    price = models.DecimalField('价格（元）', max_digits=8, decimal_places=2)
    coins = models.PositiveIntegerField('基础星币')
    bonus_coins = models.PositiveIntegerField('赠送星币', default=0)
    is_active = models.BooleanField('是否上架', default=True)
    sort_order = models.IntegerField('排序', default=0)
    created_at = models.DateTimeField('创建时间', auto_now_add=True)

    class Meta:
        verbose_name = '星币套餐'
        verbose_name_plural = '星币套餐'
        ordering = ['sort_order', 'id']

    def __str__(self):
        return f'{self.name}（{self.price} 元 / {self.total_coins} 星币）'

    @property
    def total_coins(self):
        """本次充值实际到账星币（基础 + 赠送）"""
        return (self.coins or 0) + (self.bonus_coins or 0)


class StarRechargeOrder(models.Model):
    """星币充值订单（支付宝支付，复用会员支付的 SDK 与密钥）"""

    STATUS_PENDING = 'pending'
    STATUS_PAID = 'paid'
    STATUS_CLOSED = 'closed'
    STATUS_CHOICES = [
        (STATUS_PENDING, '待支付'),
        (STATUS_PAID, '已支付'),
        (STATUS_CLOSED, '已关闭'),
    ]

    # 订单号前缀：与会员订单区分，便于共用异步通知时按前缀分流
    ORDER_NO_PREFIX = 'SC'

    order_no = models.CharField('商户订单号', max_length=32, unique=True)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE,
        related_name='star_orders', verbose_name='用户')
    package = models.ForeignKey(
        StarPackage, on_delete=models.PROTECT, related_name='orders', verbose_name='套餐')
    # 下单时快照金额与到账星币，回调校验以快照为准，避免套餐改价影响历史订单
    amount = models.DecimalField('订单金额（元）', max_digits=8, decimal_places=2)
    coins = models.PositiveIntegerField('到账星币')
    status = models.CharField('状态', max_length=10, choices=STATUS_CHOICES, default=STATUS_PENDING)
    trade_no = models.CharField('支付宝交易号', max_length=64, blank=True, default='')
    created_at = models.DateTimeField('创建时间', auto_now_add=True)
    paid_at = models.DateTimeField('支付时间', null=True, blank=True)

    class Meta:
        verbose_name = '星币充值订单'
        verbose_name_plural = '星币充值订单'
        ordering = ['-id']

    def __str__(self):
        return f'{self.order_no} - {self.get_status_display()}'

    def save(self, *args, **kwargs):
        if not self.order_no:
            self.order_no = self.generate_order_no()
        super().save(*args, **kwargs)

    @staticmethod
    def generate_order_no():
        return (StarRechargeOrder.ORDER_NO_PREFIX
                + timezone.now().strftime('%Y%m%d%H%M%S')
                + uuid.uuid4().hex[:8].upper())

    @property
    def is_expired(self):
        """待支付且已超过支付时限"""
        if self.status != self.STATUS_PENDING:
            return False
        deadline = self.created_at + timedelta(minutes=settings.ORDER_TIMEOUT_MINUTES)
        return timezone.now() > deadline

    def close(self):
        self.status = self.STATUS_CLOSED
        self.save(update_fields=['status'])


class StarTask(models.Model):
    """星币任务：活跃奖励规则，后台可配置奖励数量与发放周期。"""

    PERIOD_ONCE = 'once'
    PERIOD_DAILY = 'daily'
    PERIOD_UNLIMITED = 'unlimited'
    PERIOD_MILESTONE = 'milestone'
    PERIOD_CHOICES = [
        (PERIOD_ONCE, '仅一次'),
        (PERIOD_DAILY, '每日一次'),
        (PERIOD_UNLIMITED, '每次触发（按每日次数限制）'),
        (PERIOD_MILESTONE, '里程碑（按连续天数循环发放）'),
    ]

    # 事件白名单：每个 code 都在 hooks.py 中有对应的真实触发点
    CODE_CHOICES = [
        ('daily_login', '每日登录'),
        ('submit_paper', '完成试卷'),
        ('pass_paper', '试卷达标'),
        ('submit_assignment', '完成班级作业'),
        ('conquer_question', '答对题目（斩题）'),
        ('login_streak_7', '连续登录 7 天'),
        ('login_streak_30', '连续登录 30 天'),
        ('share_leaderboard', '分享榜单'),
    ]

    # 连续登录里程碑：任务 code → 需要的连续天数。
    # 由 hooks（发放判定）与前台（进度展示）共用，避免两处各写一份。
    MILESTONE_CYCLES = (('login_streak_7', 7), ('login_streak_30', 30))

    code = models.CharField('任务标识', max_length=32, unique=True, choices=CODE_CHOICES)
    name = models.CharField('任务名称', max_length=50)
    description = models.CharField('任务说明', max_length=200, blank=True, default='')
    icon = models.CharField('图标', max_length=10, default='⭐')
    reward_coins = models.PositiveIntegerField('奖励星币', default=1)
    period = models.CharField('发放周期', max_length=10, choices=PERIOD_CHOICES, default=PERIOD_DAILY)
    daily_limit = models.PositiveIntegerField(
        '每日最多发放次数', default=0,
        help_text='仅「每次触发」类型生效；0 表示不限制')
    threshold = models.PositiveIntegerField(
        '达标分数线（%）', default=0,
        help_text='仅「试卷达标」任务生效；按得分百分比判定，0 表示不限制')
    is_active = models.BooleanField('是否启用', default=True)
    sort_order = models.IntegerField('排序', default=0)
    created_at = models.DateTimeField('创建时间', auto_now_add=True)

    class Meta:
        verbose_name = '星币任务'
        verbose_name_plural = '星币任务'
        ordering = ['sort_order', 'id']

    def __str__(self):
        return f'{self.name}（{self.reward_coins} 星币 / {self.get_period_display()}）'

    @property
    def milestone_cycle_days(self):
        """里程碑任务的周期天数（非里程碑任务返回 None）"""
        return dict(self.MILESTONE_CYCLES).get(self.code)


class StarTaskRecord(models.Model):
    """任务发放记录：唯一约束保证幂等，同一周期内不会重复发放。"""

    user = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE,
        related_name='star_task_records', verbose_name='用户')
    task = models.ForeignKey(
        StarTask, on_delete=models.CASCADE, related_name='records', verbose_name='任务')
    # once → 'once'；daily → 'YYYY-MM-DD'；unlimited → 'YYYY-MM-DD-随机串'
    period_key = models.CharField('周期标识', max_length=32)
    reward_coins = models.PositiveIntegerField('发放星币', default=0)
    created_at = models.DateTimeField('发放时间', auto_now_add=True)

    class Meta:
        verbose_name = '星币任务记录'
        verbose_name_plural = '星币任务记录'
        ordering = ['-id']
        unique_together = ('user', 'task', 'period_key')

    def __str__(self):
        return f'{self.user.username} - {self.task.name}（{self.reward_coins}）'


class StarLoginStreak(models.Model):
    """连续登录天数：连续登录里程碑任务（7 天 / 30 天）的判定依据。

    每天首次登录由 services.record_login 更新一次，断签则从 1 重新累计。
    streak_start_date 标记「本轮连续」的起始日期，用于给里程碑任务生成周期键，
    保证同一轮连续登录内每个里程碑只发一次，断签重来后可再次发放。
    last_gift_date 记录每日登录赠礼的发放日期，保证「一天只发一次」——
    赠礼既可能由登录动作触发，也可能由当天首次访问页面补发。
    """

    user = models.OneToOneField(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE,
        related_name='star_login_streak', verbose_name='用户')
    current_days = models.PositiveIntegerField('当前连续天数', default=0)
    longest_days = models.PositiveIntegerField('历史最长连续天数', default=0)
    streak_start_date = models.DateField('本轮起始日期', null=True, blank=True)
    last_login_date = models.DateField('最后登录日期', null=True, blank=True)
    last_gift_date = models.DateField(
        '赠礼发放日期', null=True, blank=True,
        help_text='每日登录赠礼的发放日期（当天已发过一次就不再发）')
    updated_at = models.DateTimeField('更新时间', auto_now=True)

    class Meta:
        verbose_name = '连续登录'
        verbose_name_plural = '连续登录'
        ordering = ['-current_days', 'user_id']

    def __str__(self):
        return f'{self.user.username} 连续 {self.current_days} 天'


class StarItem(models.Model):
    """星币道具：用户以星币兑换的奖品。

    道具效果（effect_type）决定兑换后的发放方式，见 delivery_mode：
    - 即时生效型（会员卡/正确率重置卡/斩题卡）：兑换当次即生效，无需后台核销；
    - 背包使用型（改名卡/组卷卡/提示卡/头像框）：兑换后入背包，到具体场景使用时消耗；
    - 留空：沿用人工核销流程（待发放 → 后台核销）。
    """

    EFFECT_NONE = ''
    EFFECT_RENAME = 'rename_card'
    EFFECT_WRONG_PAPER = 'wrong_paper_card'
    EFFECT_ACCURACY_RESET = 'accuracy_reset'
    EFFECT_HINT = 'hint_card'
    EFFECT_AVATAR_FRAME = 'avatar_frame'
    EFFECT_CONQUER = 'conquer_card'
    EFFECT_MEMBER = 'member_card'
    EFFECT_CHOICES = [
        (EFFECT_NONE, '无（人工核销发放）'),
        (EFFECT_RENAME, '改名卡'),
        (EFFECT_WRONG_PAPER, '错题组卷卡'),
        (EFFECT_ACCURACY_RESET, '正确率重置卡'),
        (EFFECT_HINT, '答案提示卡'),
        (EFFECT_AVATAR_FRAME, '头像框'),
        (EFFECT_CONQUER, '斩题卡'),
        (EFFECT_MEMBER, '会员卡'),
    ]

    # 兑换即生效的效果
    INSTANT_EFFECTS = (EFFECT_MEMBER, EFFECT_ACCURACY_RESET, EFFECT_CONQUER)
    # 兑换入背包、需在具体场景使用才生效的效果
    INVENTORY_EFFECTS = (EFFECT_RENAME, EFFECT_WRONG_PAPER, EFFECT_HINT, EFFECT_AVATAR_FRAME)

    MODE_INSTANT = 'instant'
    MODE_INVENTORY = 'inventory'
    MODE_MANUAL = 'manual'

    name = models.CharField('道具名称', max_length=50)
    description = models.CharField('道具说明', max_length=200, blank=True, default='')
    icon = models.CharField('图标', max_length=10, default='🎁')
    category = models.CharField('分类', max_length=30, blank=True, default='')
    price_coins = models.PositiveIntegerField('所需星币')
    # 会员折扣：仅「会员生效中」的用户兑换时享受，非会员一律按原价
    member_discount_rate = models.DecimalField(
        '会员折扣（折）', max_digits=4, decimal_places=2, default=NO_DISCOUNT_RATE,
        validators=[MinValueValidator(MIN_DISCOUNT_RATE), MaxValueValidator(NO_DISCOUNT_RATE)],
        help_text='仅会员生效中的用户享受；10 表示无折扣，9 表示会员 9 折。取值范围 0.01～10。'
                  '会员卡类道具会被强制锁定为 10（无折扣）。')
    # -1 表示不限库存
    stock = models.IntegerField('库存', default=-1, help_text='-1 表示不限库存')
    # 0 表示不限购
    per_user_limit = models.PositiveIntegerField('每人限购', default=0, help_text='0 表示不限购')
    is_active = models.BooleanField('是否上架', default=True)
    sort_order = models.IntegerField('排序', default=0)
    effect_type = models.CharField(
        '道具效果', max_length=20, blank=True, default='', choices=EFFECT_CHOICES,
        help_text='留空 = 人工核销发放；选择后由系统自动发放（即时生效或入背包）')
    effect_payload = models.JSONField(
        '效果参数', default=dict, blank=True,
        help_text='会员卡示例 {"days": 30}；斩题卡示例 {"count": 1}；头像框示例 {"frame": "gold"}')
    created_at = models.DateTimeField('创建时间', auto_now_add=True)

    class Meta:
        verbose_name = '星币道具'
        verbose_name_plural = '星币道具'
        ordering = ['sort_order', 'id']

    def __str__(self):
        return f'{self.name}（{self.price_coins} 星币）'

    def save(self, *args, **kwargs):
        # 会员类道具强制无折扣：否则会员可用折扣价兑换会员卡自我续期，形成套利
        if self.effect_type == self.EFFECT_MEMBER:
            self.member_discount_rate = NO_DISCOUNT_RATE
        super().save(*args, **kwargs)

    @property
    def is_unlimited_stock(self):
        return self.stock < 0

    @property
    def is_sold_out(self):
        return self.stock == 0

    @staticmethod
    def delivery_mode_for(effect_type):
        """按效果类型判定发放方式（供聚合查询等无实例场景复用）"""
        if not effect_type:
            return StarItem.MODE_MANUAL
        if effect_type in StarItem.INSTANT_EFFECTS:
            return StarItem.MODE_INSTANT
        return StarItem.MODE_INVENTORY

    @property
    def delivery_mode(self):
        """发放方式：instant（兑换即生效）/ inventory（入背包待使用）/ manual（人工核销）"""
        return StarItem.delivery_mode_for(self.effect_type)

    @property
    def needs_manual_fulfill(self):
        """是否仍需后台人工核销"""
        return self.delivery_mode == self.MODE_MANUAL

    @property
    def delivery_mode_label(self):
        return {
            self.MODE_INSTANT: '兑换后立即生效',
            self.MODE_INVENTORY: '兑换后进背包',
            self.MODE_MANUAL: '后台人工发放',
        }[self.delivery_mode]

    @property
    def delivery_badge(self):
        """商城卡片角标：发放方式 + 关键参数（会员卡显示天数）"""
        if self.delivery_mode == self.MODE_INSTANT:
            days = self.effect_payload.get('days') if self.effect_type == self.EFFECT_MEMBER else None
            return f'⚡ 兑换后立即生效 · 会员 +{days} 天' if days else '⚡ 兑换后立即生效'
        if self.delivery_mode == self.MODE_INVENTORY:
            return '🎒 兑换后入背包，需要时再使用'
        return '📦 兑换后由管理员核销发放'

    @property
    def effective_discount_rate(self):
        """容错后的会员折扣率"""
        return normalize_discount_rate(self.member_discount_rate)

    @property
    def is_member_discounted(self):
        """是否配置了会员折扣"""
        return self.effective_discount_rate < NO_DISCOUNT_RATE

    @property
    def member_discount_label(self):
        """会员折扣文案，如「9 折」"""
        return format_discount_rate(self.effective_discount_rate)

    @property
    def member_price_coins(self):
        """会员折后价（星币）：四舍五入，最低 1 星币且不超过原价"""
        if not self.is_member_discounted:
            return self.price_coins
        final = (Decimal(self.price_coins) * self.effective_discount_rate
                 / NO_DISCOUNT_RATE).quantize(Decimal('1'), rounding=ROUND_HALF_UP)
        final = max(final, Decimal('1'))
        return int(min(final, Decimal(self.price_coins)))

    @property
    def member_saved_coins(self):
        """会员每件可省星币"""
        return self.price_coins - self.member_price_coins

    def price_for_member(self, is_member):
        """按用户是否为会员返回单价（星币）"""
        return self.member_price_coins if is_member else self.price_coins


class StarLoginGift(models.Model):
    """每日登录赠礼：每天首次登录时按用户身份（免费 / 会员）赠送道具。

    一行 = 一件道具在免费档 / 会员档各赠几张（0 表示该档不赠）。
    只允许配置「入背包」类道具：即时生效型道具走背包没有使用入口，
    而人工核销型道具本就由管理员发放，都不适合作为自动赠礼。
    """

    item = models.ForeignKey(
        StarItem, on_delete=models.CASCADE, related_name='login_gifts',
        verbose_name='赠送道具',
        limit_choices_to={'effect_type__in': StarItem.INVENTORY_EFFECTS})
    quantity_free = models.PositiveIntegerField('免费用户张数', default=1)
    quantity_member = models.PositiveIntegerField('会员张数', default=2)
    is_active = models.BooleanField('是否启用', default=True)
    sort_order = models.IntegerField('排序', default=0)
    updated_at = models.DateTimeField('更新时间', auto_now=True)

    class Meta:
        verbose_name = '每日登录赠礼'
        verbose_name_plural = '每日登录赠礼'
        ordering = ['sort_order', 'id']
        constraints = [
            models.UniqueConstraint(fields=['item'], name='uniq_login_gift_item'),
        ]

    def __str__(self):
        return (f'{self.item.name}（免费 {self.quantity_free} / '
                f'会员 {self.quantity_member}）')

    def quantity_for(self, is_member):
        """按身份取本次赠送张数（0 表示该档不赠）"""
        return self.quantity_member if is_member else self.quantity_free


class StarWrongPaperConfig(models.Model):
    """错题组卷额度（单例）：免费用户每天可不消耗组卷卡免费组卷的次数。

    组卷卡（回响之杖）的价值锚点：免费额度用完后，每次组卷消耗 1 张；
    任何用户单次超过 10 题也必须用卡（用卡当次不限题量）；会员组卷不限次数。
    """

    free_daily_limit = models.PositiveIntegerField(
        '免费用户每日免费组卷次数', default=1,
        help_text='免费用户每天可不消耗组卷卡组卷的次数（每次最多 10 题）；'
                  '0 表示关闭免费额度（每次组卷都要用卡）。会员不受此限制。')

    class Meta:
        verbose_name = '错题组卷额度'
        verbose_name_plural = '错题组卷额度'

    def __str__(self):
        return f'免费用户每日免费组卷 {self.free_daily_limit} 次'

    def save(self, *args, **kwargs):
        # 单例：固定主键为 1，避免后台出现多条配置
        self.pk = 1
        super().save(*args, **kwargs)

    @classmethod
    def get_solo(cls):
        """获取（不存在则创建）错题组卷额度配置单例"""
        return cls.objects.get_or_create(pk=1)[0]


class StarRedemption(models.Model):
    """道具兑换记录：兑换即扣星币，奖品由后台人工核销发放。"""

    STATUS_PENDING = 'pending'
    STATUS_FULFILLED = 'fulfilled'
    STATUS_CANCELLED = 'cancelled'
    STATUS_CHOICES = [
        (STATUS_PENDING, '待发放'),
        (STATUS_FULFILLED, '已发放'),
        (STATUS_CANCELLED, '已取消'),
    ]

    user = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE,
        related_name='star_redemptions', verbose_name='用户')
    item = models.ForeignKey(
        StarItem, on_delete=models.PROTECT, related_name='redemptions', verbose_name='道具')
    quantity = models.PositiveIntegerField('兑换数量', default=1)
    # 背包使用型道具：本条兑换记录已被用掉的张数，剩余可用 = quantity - used_quantity
    used_quantity = models.PositiveIntegerField('已使用数量', default=0)
    # 兑换时的星币花费快照（已含会员折扣）
    coins_cost = models.PositiveIntegerField('消耗星币')
    # 兑换时快照原价与折扣率，后台事后改价/改折扣都不影响历史记录展示
    original_coins = models.PositiveIntegerField('原价星币', default=0)
    discount_rate = models.DecimalField(
        '兑换折扣（折）', max_digits=4, decimal_places=2, default=NO_DISCOUNT_RATE,
        help_text='兑换瞬间的会员折扣快照，10 表示无折扣')
    status = models.CharField('状态', max_length=10, choices=STATUS_CHOICES, default=STATUS_PENDING)
    contact = models.CharField('联系方式', max_length=200, blank=True, default='', help_text='收货地址/联系方式，便于后台发放')
    user_remark = models.CharField('用户留言', max_length=200, blank=True, default='')
    admin_remark = models.CharField('处理备注', max_length=200, blank=True, default='')
    fulfilled_by = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True, blank=True,
        related_name='star_fulfilled_redemptions', verbose_name='处理人')
    fulfilled_at = models.DateTimeField('处理时间', null=True, blank=True)
    created_at = models.DateTimeField('兑换时间', auto_now_add=True)

    class Meta:
        verbose_name = '星币兑换记录'
        verbose_name_plural = '星币兑换记录'
        ordering = ['-id']

    def __str__(self):
        return f'{self.user.username} 兑换 {self.item.name}×{self.quantity}'

    @property
    def is_discounted(self):
        """本单是否享受了会员折扣（以兑换瞬间的快照为准）"""
        return Decimal(self.discount_rate) < NO_DISCOUNT_RATE

    @property
    def discount_label(self):
        """本单折扣文案：折扣中显示「x 折」，否则显示「无折扣」"""
        if not self.is_discounted:
            return '无折扣'
        return format_discount_rate(self.discount_rate)

    @property
    def saved_coins(self):
        """本单优惠星币（原价 - 实付）；历史数据未记原价时按 0 处理"""
        return max((self.original_coins or 0) - self.coins_cost, 0)

    @property
    def avail_quantity(self):
        """本条兑换记录剩余可用张数（仅背包使用型道具有意义）"""
        return max((self.quantity or 0) - (self.used_quantity or 0), 0)


class StarItemUsage(models.Model):
    """道具使用流水：记录道具在何时、因何被使用（即时生效）或消耗一张（背包使用）。

    与 StarTransaction（星币流水）分开：这里只记「道具张数」的消耗与生效留痕，
    用于审计与「可用数量 = 已发放 - 已使用」口径对账。
    """

    user = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE,
        related_name='star_item_usages', verbose_name='用户')
    item = models.ForeignKey(
        StarItem, on_delete=models.PROTECT, related_name='usages', verbose_name='道具')
    redemption = models.ForeignKey(
        StarRedemption, on_delete=models.PROTECT, related_name='usages',
        verbose_name='来源兑换记录')
    effect_type = models.CharField('效果类型', max_length=20, blank=True, default='')
    detail = models.CharField('使用明细', max_length=200, blank=True, default='')
    context = models.CharField('使用场景', max_length=50, blank=True, default='')
    created_at = models.DateTimeField('使用时间', auto_now_add=True)

    class Meta:
        verbose_name = '道具使用流水'
        verbose_name_plural = '道具使用流水'
        ordering = ['-id']

    def __str__(self):
        return f'{self.user.username} 使用 {self.item.name}'
