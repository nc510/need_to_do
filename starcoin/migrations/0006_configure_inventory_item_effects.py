"""为背包使用型道具配置 effect_type / effect_payload（P2：改名卡 / 组卷卡 / 提示卡 / 头像框）。

仅在 effect_type 为空时写入，管理员已手工配置过的道具不会被覆盖。
"""

from django.db import migrations

# 道具名 -> (效果类型, 效果参数)
ITEM_EFFECTS = {
    '名刀·司命': ('rename_card', {}),
    '回响之杖': ('wrong_paper_card', {}),
    '破晓·辉月': ('hint_card', {}),
    '专属头像框': ('avatar_frame', {}),
}


def configure_effects(apps, schema_editor):
    star_item = apps.get_model('starcoin', 'StarItem')
    for name, (effect_type, payload) in ITEM_EFFECTS.items():
        star_item.objects.filter(name=name, effect_type='').update(
            effect_type=effect_type, effect_payload=payload)


def unconfigure_effects(apps, schema_editor):
    star_item = apps.get_model('starcoin', 'StarItem')
    star_item.objects.filter(name__in=list(ITEM_EFFECTS), effect_type__in=[
        effect_type for effect_type, _payload in ITEM_EFFECTS.values()]).update(
        effect_type='', effect_payload={})


class Migration(migrations.Migration):

    dependencies = [
        ('starcoin', '0005_configure_instant_item_effects'),
    ]

    operations = [
        migrations.RunPython(configure_effects, unconfigure_effects),
    ]
