"""初始化内置星币道具（商城可兑换的奖品）。

用法：python manage.py seed_star_items
已存在的同名道具不会被覆盖，管理员在后台的调整（价格 / 折扣 / 库存 / 上下架 / 限购）会保留。

这里的初始值以线上后台配置为准（价格 / 会员折扣 / 限购），只用于新环境部署初始化。
道具效果（effect_type）在各道具功能实现时逐个配置；未配置前统一走「后台人工核销」。
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
        'member_discount_rate': '6.00',
        'stock': -1,
        'per_user_limit': 0,
        'sort_order': 10,
        # 背包使用型：在星币中心背包「使用」，消耗 1 张改一次显示名
        'effect_type': 'rename_card',
        'effect_payload': {},
    },
    {
        'name': '回响之杖',
        'description': '错题组卷卡 · 将错题本一键生成专属练习卷',
        # 用通用性更好的 📜（Unicode 6.0）：🪄 属 Unicode 13.0，部分系统字体缺字形会显示成方框
        'icon': '📜',
        'category': '功能道具',
        'price_coins': 30,
        'member_discount_rate': '5.00',
        'stock': -1,
        'per_user_limit': 0,
        'sort_order': 20,
        # 背包使用型：错题本组卷超过免费题量时消耗 1 张解锁不限题量
        'effect_type': 'wrong_paper_card',
        'effect_payload': {},
    },
    {
        'name': '贤者的庇护',
        'description': '正确率重置卡 · 重置个人正确率统计重新开始',
        'icon': '🛡️',
        'category': '功能道具',
        'price_coins': 300,
        'member_discount_rate': '6.00',
        'stock': -1,
        'per_user_limit': 0,
        'sort_order': 30,
        # 即时生效：兑换即清空累计作答题次/答对题次
        'effect_type': 'accuracy_reset',
        'effect_payload': {},
    },
    {
        'name': '破晓·辉月',
        'description': '答案提示卡 · 答题时可查看一次题目提示',
        'icon': '🌙',
        'category': '功能道具',
        'price_coins': 30,
        'member_discount_rate': '5.00',
        'stock': -1,
        'per_user_limit': 0,
        'sort_order': 40,
        # 背包使用型：答题页消耗 1 张查看一次本题提示
        'effect_type': 'hint_card',
        'effect_payload': {},
    },
    {
        'name': '专属头像框',
        'description': '头像框 · 为个人头像添加专属展示边框',
        'icon': '🖼️',
        'category': '装扮道具',
        'price_coins': 888,
        'member_discount_rate': '10.00',
        'stock': -1,
        'per_user_limit': 1,
        'sort_order': 50,
        # 背包使用型：在星币中心背包「使用」，激活一个头像框样式
        'effect_type': 'avatar_frame',
        'effect_payload': {},
    },
    {
        'name': '斩题卡',
        'description': '斩题卡 · 直接补记一次斩题，助力冲击斩题榜',
        'icon': '⚔️',
        'category': '功能道具',
        'price_coins': 200,
        'member_discount_rate': '6.00',
        'stock': -1,
        'per_user_limit': 0,
        'sort_order': 60,
        # 即时生效：每次兑换补记 1 个斩题数（走 Profile.conquered_bonus）
        'effect_type': 'conquer_card',
        'effect_payload': {'count': 1},
    },
    {
        'name': '1天体验会员卡',
        'description': '会员卡 · 兑换 1 天会员时长，先体验再决定',
        'icon': '🎟️',
        'category': '特权道具',
        'price_coins': 100,
        # 会员类道具强制无折扣（模型 save 会再次锁定），避免会员低价自我续期
        'member_discount_rate': '10.00',
        'stock': -1,
        'per_user_limit': 3,
        'sort_order': 70,
        # 即时生效：兑换即延长 1 天会员
        'effect_type': 'member_card',
        'effect_payload': {'days': 1},
    },
    {
        'name': '7天体验会员卡',
        'description': '会员卡 · 兑换 7 天会员时长，短期体验首选',
        'icon': '🎫',
        'category': '特权道具',
        'price_coins': 800,
        'member_discount_rate': '10.00',
        'stock': -1,
        'per_user_limit': 3,
        'sort_order': 80,
        # 即时生效：兑换即延长 7 天会员
        'effect_type': 'member_card',
        'effect_payload': {'days': 7},
    },
    {
        'name': '月卡会员卡',
        'description': '会员卡 · 兑换 30 天（1 个月）会员时长',
        'icon': '💳',
        'category': '特权道具',
        'price_coins': 2000,
        'member_discount_rate': '10.00',
        'stock': -1,
        'per_user_limit': 0,
        'sort_order': 90,
        # 即时生效：兑换即延长 30 天会员
        'effect_type': 'member_card',
        'effect_payload': {'days': 30},
    },
    {
        'name': '年卡会员卡',
        'description': '会员卡 · 兑换 365 天（1 年）会员时长，长周期最划算',
        'icon': '👑',
        'category': '特权道具',
        'price_coins': 20000,
        'member_discount_rate': '10.00',
        'stock': -1,
        'per_user_limit': 0,
        'sort_order': 100,
        # 即时生效：兑换即延长 365 天会员
        'effect_type': 'member_card',
        'effect_payload': {'days': 365},
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
