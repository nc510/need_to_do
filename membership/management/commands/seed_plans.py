from django.core.management.base import BaseCommand
from django.db import transaction

from membership.models import Plan

# 按套餐名幂等写入，重复执行不会产生重复数据
PLANS = [
    {'name': '月会员', 'price': '9.90', 'duration_days': 30, 'sort_order': 1},
    {'name': '年会员', 'price': '99.00', 'duration_days': 365, 'sort_order': 2},
]


class Command(BaseCommand):
    help = '初始化会员套餐（月会员 / 年会员），可重复执行'

    @transaction.atomic
    def handle(self, *args, **options):
        for item in PLANS:
            plan, created = Plan.objects.update_or_create(
                name=item['name'],
                defaults={
                    'price': item['price'],
                    'duration_days': item['duration_days'],
                    'sort_order': item['sort_order'],
                    'is_active': True,
                },
            )
            action = '创建' if created else '更新'
            self.stdout.write(self.style.SUCCESS(f'{action}套餐：{plan}'))
