"""初始化内置星币道具（商城可兑换的奖品）。

用法：python manage.py seed_star_items
已存在的同名道具不会被覆盖，管理员在后台的调整（价格 / 库存 / 上下架）会保留。

说明：道具的具体功能（改名、错题组卷、正确率重置、答案提示、头像框）后续再扩展，
当前仅完成「上架 + 兑换 + 持有展示」，兑换后由管理员在后台人工核销发放。
"""

from django.core.management.base import BaseCommand

from starcoin.models import StarItem

DEFAULT_ITEMS = [
    {
        'name': '名刀·司命',
        'description': '改名卡 · 可修改一次个人显示名称',
        'icon': '🗡️',
        'category': '功能道具',
        'price_coins': 500,
        'stock': -1,
        'per_user_limit': 0,
        'sort_order': 10,
    },
    {
        'name': '回响之杖',
        'description': '错题组卷卡 · 将错题本一键生成专属练习卷',
        'icon': '🪄',
        'category': '功能道具',
        'price_coins': 200,
        'stock': -1,
        'per_user_limit': 0,
        'sort_order': 20,
    },
    {
        'name': '贤者的庇护',
        'description': '正确率重置卡 · 重置个人正确率统计重新开始',
        'icon': '🛡️',
        'category': '功能道具',
        'price_coins': 300,
        'stock': -1,
        'per_user_limit': 0,
        'sort_order': 30,
    },
    {
        'name': '破晓·辉月',
        'description': '答案提示卡 · 答题时可查看一次题目提示',
        'icon': '💡',
        'category': '功能道具',
        'price_coins': 100,
        'stock': -1,
        'per_user_limit': 0,
        'sort_order': 40,
    },
    {
        'name': '专属头像框',
        'description': '头像框 · 为个人头像添加专属展示边框',
        'icon': '🖼️',
        'category': '装扮道具',
        'price_coins': 800,
        'stock': -1,
        'per_user_limit': 1,
        'sort_order': 50,
    },
    {
        'name': '斩题卡',
        'description': '斩题卡 · 直接补记一次斩题，助力冲击斩题榜',
        'icon': '⚔️',
        'category': '功能道具',
        'price_coins': 150,
        'stock': -1,
        'per_user_limit': 0,
        'sort_order': 60,
    },
    {
        'name': '1天体验会员卡',
        'description': '会员卡 · 兑换 1 天会员时长，先体验再决定',
        'icon': '🎟️',
        'category': '特权道具',
        'price_coins': 10,
        'stock': -1,
        'per_user_limit': 0,
        'sort_order': 70,
    },
    {
        'name': '7天体验会员卡',
        'description': '会员卡 · 兑换 7 天会员时长，短期体验首选',
        'icon': '🎫',
        'category': '特权道具',
        'price_coins': 40,
        'stock': -1,
        'per_user_limit': 0,
        'sort_order': 80,
    },
    {
        'name': '月卡会员卡',
        'description': '会员卡 · 兑换 30 天（1 个月）会员时长',
        'icon': '💳',
        'category': '特权道具',
        'price_coins': 100,
        'stock': -1,
        'per_user_limit': 0,
        'sort_order': 90,
    },
    {
        'name': '年卡会员卡',
        'description': '会员卡 · 兑换 365 天（1 年）会员时长，长周期最划算',
        'icon': '👑',
        'category': '特权道具',
        'price_coins': 1000,
        'stock': -1,
        'per_user_limit': 0,
        'sort_order': 100,
    },
]


class Command(BaseCommand):
    help = '初始化内置星币道具（已存在的同名道具不会覆盖）'

    def handle(self, *args, **options):
        created = 0
        for data in DEFAULT_ITEMS:
            _item, is_new = StarItem.objects.get_or_create(
                name=data['name'], defaults=data)
            if is_new:
                created += 1
        self.stdout.write(self.style.SUCCESS(
            f'星币道具初始化完成：新增 {created} 个，已存在 {len(DEFAULT_ITEMS) - created} 个'))
