from django.core.management.base import BaseCommand

from membership.services import (
    STATE_AMOUNT_MISMATCH,
    STATE_PAID,
    STATE_UNKNOWN,
    STATE_UNPAID,
    sync_pending_orders,
)


class Command(BaseCommand):
    help = '兜底补单：对未支付订单主动查单，确认已支付则开通会员（建议用计划任务定期执行）'

    def add_arguments(self, parser):
        parser.add_argument('--limit', type=int, default=None, help='本次最多处理多少笔订单')

    def handle(self, *args, **options):
        counts = sync_pending_orders(limit=options.get('limit'))
        self.stdout.write(self.style.SUCCESS(
            f'共检查 {counts["total"]} 笔待支付订单：'
            f'补单成功 {counts[STATE_PAID]} 笔，'
            f'未支付 {counts[STATE_UNPAID]} 笔，'
            f'金额不符 {counts[STATE_AMOUNT_MISMATCH]} 笔，'
            f'查询失败 {counts[STATE_UNKNOWN]} 笔'
        ))
