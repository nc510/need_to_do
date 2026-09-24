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
    """

    user = models.OneToOneField(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE,
        related_name='star_login_streak', verbose_name='用户')
    current_days = models.PositiveIntegerField('当前连续天数', default=0)
    longest_days = models.PositiveIntegerField('历史最长连续天数', default=0)
    streak_start_date = models.DateField('本轮起始日期', null=True, blank=True)
    last_login_date = models.DateField('最后登录日期', null=True, blank=True)
    updated_at = models.DateTimeField('更新时间', auto_now=True)

    class Meta:
        verbose_name = '连续登录'
        verbose_name_plural = '连续登录'
        ordering = ['-current_days', 'user_id']

    def __str__(self):
        return f'{self.user.username} 连续 {self.current_days} 天'


class StarItem(models.Model):
    """星币道具：用户以星币兑换的奖品"""

    name = models.CharField('道具名称', max_length=50)
    description = models.CharField('道具说明', max_length=200, blank=True, default='')
    icon = models.CharField('图标', max_length=10, default='🎁')
    category = models.CharField('分类', max_length=30, blank=True, default='')
    price_coins = models.PositiveIntegerField('所需星币')
    # 会员折扣：仅「会员生效中」的用户兑换时享受，非会员一律按原价
    member_discount_rate = models.DecimalField(
        '会员折扣（折）', max_digits=4, decimal_places=2, default=NO_DISCOUNT_RATE,
        validators=[MinValueValidator(MIN_DISCOUNT_RATE), MaxValueValidator(NO_DISCOUNT_RATE)],
        help_text='仅会员生效中的用户享受；10 表示无折扣，9 表示会员 9 折。取值范围 0.01～10。')
    # -1 表示不限库存
    stock = models.IntegerField('库存', default=-1, help_text='-1 表示不限库存')
    # 0 表示不限购
    per_user_limit = models.PositiveIntegerField('每人限购', default=0, help_text='0 表示不限购')
    is_active = models.BooleanField('是否上架', default=True)
    sort_order = models.IntegerField('排序', default=0)
    created_at = models.DateTimeField('创建时间', auto_now_add=True)

    class Meta:
        verbose_name = '星币道具'
        verbose_name_plural = '星币道具'
        ordering = ['sort_order', 'id']

    def __str__(self):
        return f'{self.name}（{self.price_coins} 星币）'

    @property
    def is_unlimited_stock(self):
        return self.stock < 0

    @property
    def is_sold_out(self):
        return self.stock == 0

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
