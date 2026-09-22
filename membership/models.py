import uuid
from datetime import timedelta
from decimal import Decimal, ROUND_HALF_UP

from django.conf import settings
from django.core.validators import MaxValueValidator, MinValueValidator
from django.db import models
from django.utils import timezone


class Plan(models.Model):
    """会员套餐"""

    name = models.CharField('套餐名称', max_length=50)
    price = models.DecimalField('价格', max_digits=8, decimal_places=2)
    duration_days = models.PositiveIntegerField('有效天数')
    is_active = models.BooleanField('是否上架', default=True)
    sort_order = models.IntegerField('排序', default=0)
    created_at = models.DateTimeField('创建时间', auto_now_add=True)

    class Meta:
        verbose_name = '会员套餐'
        verbose_name_plural = '会员套餐'
        ordering = ['sort_order', 'id']

    def __str__(self):
        return f'{self.name}（{self.price} 元 / {self.duration_days} 天）'

    @property
    def discount_rate(self):
        """当前适用的充值折扣（单位：折，10=无折扣）"""
        return RechargeConfig.get_solo().effective_rate

    @property
    def final_price(self):
        """折后实付价（元，四舍五入保留两位小数，最低 0.01 元，不超过原价）"""
        final = (Decimal(self.price) * self.discount_rate / Decimal('10')).quantize(
            Decimal('0.01'), rounding=ROUND_HALF_UP)
        if final < Decimal('0.01'):
            final = Decimal('0.01')
        if final > Decimal(self.price):
            final = Decimal(self.price)
        return final

    @property
    def is_discounted(self):
        return self.final_price < Decimal(self.price)

    @property
    def saved_amount(self):
        """折扣优惠金额（元）"""
        return (Decimal(self.price) - self.final_price).quantize(Decimal('0.01'))

    @property
    def discount_label(self):
        """折扣文案，如「9 折」「8.5 折」"""
        return RechargeConfig.get_solo().rate_label


class RechargeConfig(models.Model):
    """会员充值折扣（单例），后台维护，下单时按此折扣计算实付金额"""

    NO_DISCOUNT = Decimal('10.00')

    discount_rate = models.DecimalField(
        '充值折扣（折）', max_digits=4, decimal_places=2, default=NO_DISCOUNT,
        validators=[MinValueValidator(Decimal('0.01')), MaxValueValidator(Decimal('10.00'))],
        help_text='10 表示无折扣；9 表示 9 折（按原价的 90% 收取）；8.5 表示 85 折。取值范围 0.01～10。')

    class Meta:
        verbose_name = '会员充值折扣'
        verbose_name_plural = '会员充值折扣'

    def __str__(self):
        return f'会员充值折扣：{self.rate_label}'

    def save(self, *args, **kwargs):
        # 单例：固定主键为 1，避免后台出现多条配置
        self.pk = 1
        super().save(*args, **kwargs)

    @classmethod
    def get_solo(cls):
        """获取（不存在则创建）充值折扣配置单例"""
        return cls.objects.get_or_create(pk=1)[0]

    @property
    def effective_rate(self):
        """容错后的有效折扣率，限定在 0.01~10 之间"""
        rate = Decimal(self.discount_rate)
        return min(max(rate, Decimal('0.01')), Decimal('10.00'))

    @property
    def is_discounted(self):
        return self.effective_rate < self.NO_DISCOUNT

    @property
    def rate_label(self):
        """折扣文案，如「9 折」「8.5 折」"""
        text = f'{self.effective_rate:.2f}'.rstrip('0').rstrip('.')
        return f'{text} 折'

    @property
    def display_label(self):
        """前台展示文案：折扣中显示「x 折」，否则显示「无折扣」"""
        return self.rate_label if self.is_discounted else '无折扣'


class Order(models.Model):
    """会员订单"""

    STATUS_PENDING = 'pending'
    STATUS_PAID = 'paid'
    STATUS_CLOSED = 'closed'
    STATUS_CHOICES = [
        (STATUS_PENDING, '待支付'),
        (STATUS_PAID, '已支付'),
        (STATUS_CLOSED, '已关闭'),
    ]

    NO_DISCOUNT_RATE = Decimal('10.00')

    order_no = models.CharField('商户订单号', max_length=32, unique=True)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='orders', verbose_name='用户')
    plan = models.ForeignKey(Plan, on_delete=models.PROTECT, related_name='orders', verbose_name='套餐')
    # 下单时快照金额，回调校验以此为准，避免套餐改价影响历史订单
    amount = models.DecimalField('订单金额', max_digits=8, decimal_places=2)
    # 下单时快照折扣率（单位：折，10=无折扣），后台事后改折扣不影响本单展示
    discount_rate = models.DecimalField(
        '下单折扣（折）', max_digits=4, decimal_places=2, default=NO_DISCOUNT_RATE,
        help_text='下单瞬间的充值折扣快照，10 表示无折扣')
    status = models.CharField('状态', max_length=10, choices=STATUS_CHOICES, default=STATUS_PENDING)
    trade_no = models.CharField('支付宝交易号', max_length=64, blank=True, default='')
    created_at = models.DateTimeField('创建时间', auto_now_add=True)
    paid_at = models.DateTimeField('支付时间', null=True, blank=True)

    class Meta:
        verbose_name = '会员订单'
        verbose_name_plural = '会员订单'
        ordering = ['-id']

    def __str__(self):
        return f'{self.order_no} - {self.get_status_display()}'

    @property
    def is_discounted(self):
        """本单是否使用了折扣（以下单折扣快照为准）"""
        return Decimal(self.discount_rate) < self.NO_DISCOUNT_RATE

    @property
    def discount_label(self):
        """本单折扣文案：折扣中显示「x 折」，否则显示「无折扣」"""
        if not self.is_discounted:
            return '无折扣'
        text = f'{Decimal(self.discount_rate):.2f}'.rstrip('0').rstrip('.')
        return f'{text} 折'

    @property
    def saved_amount(self):
        """本单优惠金额（元）"""
        return (Decimal(self.plan.price) - Decimal(self.amount)).quantize(Decimal('0.01'))

    def save(self, *args, **kwargs):
        if not self.order_no:
            self.order_no = self.generate_order_no()
        super().save(*args, **kwargs)

    @staticmethod
    def generate_order_no():
        return timezone.now().strftime('%Y%m%d%H%M%S') + uuid.uuid4().hex[:8].upper()

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
