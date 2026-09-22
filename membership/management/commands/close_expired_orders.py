from datetime import timedelta

from django.conf import settings
from django.core.management.base import BaseCommand
from django.utils import timezone

from membership.models import Order


class Command(BaseCommand):
    help = '关闭超过支付时限仍未支付的订单，建议用计划任务定期执行'

    def handle(self, *args, **options):
        deadline = timezone.now() - timedelta(minutes=settings.ORDER_TIMEOUT_MINUTES)
        closed = Order.objects.filter(
            status=Order.STATUS_PENDING, created_at__lt=deadline
        ).update(status=Order.STATUS_CLOSED)
        self.stdout.write(self.style.SUCCESS(f'已关闭 {closed} 笔超时未支付订单'))
