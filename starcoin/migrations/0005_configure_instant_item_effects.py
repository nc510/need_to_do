"""为即时生效型道具配置 effect_type / effect_payload（P1：会员卡 / 正确率重置卡 / 斩题卡）。

仅在 effect_type 为空时写入，管理员已手工配置过的道具不会被覆盖。
"""

from django.db import migrations

# 道具名 -> (效果类型, 效果参数)
ITEM_EFFECTS = {
    '贤者的庇护': ('accuracy_reset', {}),
    '斩题卡': ('conquer_card', {'count': 1}),
    '1天体验会员卡': ('member_card', {'days': 1}),
    '7天体验会员卡': ('member_card', {'days': 7}),
    '月卡会员卡': ('member_card', {'days': 30}),
    '年卡会员卡': ('member_card', {'days': 365}),
}


def configure_effects(apps, schema_editor):
    star_item = apps.get_model('starcoin', 'StarItem')
    for name, (effect_type, payload) in ITEM_EFFECTS.items():
        star_item.objects.filter(name=name, effect_type='').update(
            effect_type=effect_type, effect_payload=payload)


def unconfigure_effects(apps, schema_editor):
    star_item = apps.get_model('starcoin', 'StarItem')
    star_item.objects.filter(name__in=list(ITEM_EFFECTS)).update(
        effect_type='', effect_payload={})


class Migration(migrations.Migration):

    dependencies = [
        ('starcoin', '0004_auto_20260924_2216'),
    ]

    operations = [
        migrations.RunPython(configure_effects, unconfigure_effects),
    ]
