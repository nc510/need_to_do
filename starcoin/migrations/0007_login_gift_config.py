"""每日登录赠礼配置表（后台「登录赠礼」可设置每天首次登录赠送的道具与张数）。

初始值 = 改造前代码里的硬编码规则（提示卡 / 组卷卡：免费 1 张、会员 2 张），
保证上线后赠礼行为与之前完全一致，之后再在后台按需调整。
"""

import django.db.models.deletion
from django.db import migrations, models

# (道具名, 免费档张数, 会员档张数)：顺序即默认展示顺序
DEFAULT_GIFTS = (
    ('破晓·辉月', 1, 2),
    ('回响之杖', 1, 2),
)


def seed_gifts(apps, schema_editor):
    star_item = apps.get_model('starcoin', 'StarItem')
    login_gift = apps.get_model('starcoin', 'StarLoginGift')
    for index, (name, quantity_free, quantity_member) in enumerate(DEFAULT_GIFTS):
        item = star_item.objects.filter(name=name).first()
        if item is None:
            continue
        login_gift.objects.get_or_create(
            item=item,
            defaults={'quantity_free': quantity_free,
                      'quantity_member': quantity_member,
                      'sort_order': (index + 1) * 10})


def unseed_gifts(apps, schema_editor):
    star_item = apps.get_model('starcoin', 'StarItem')
    login_gift = apps.get_model('starcoin', 'StarLoginGift')
    names = [name for name, _free, _member in DEFAULT_GIFTS]
    login_gift.objects.filter(item__name__in=names).delete()


class Migration(migrations.Migration):

    dependencies = [
        ('starcoin', '0006_configure_inventory_item_effects'),
    ]

    operations = [
        migrations.CreateModel(
            name='StarLoginGift',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('quantity_free', models.PositiveIntegerField(default=1, verbose_name='免费用户张数')),
                ('quantity_member', models.PositiveIntegerField(default=2, verbose_name='会员张数')),
                ('is_active', models.BooleanField(default=True, verbose_name='是否启用')),
                ('sort_order', models.IntegerField(default=0, verbose_name='排序')),
                ('updated_at', models.DateTimeField(auto_now=True, verbose_name='更新时间')),
                ('item', models.ForeignKey(limit_choices_to={'effect_type__in': ('rename_card', 'wrong_paper_card', 'hint_card', 'avatar_frame')}, on_delete=django.db.models.deletion.CASCADE, related_name='login_gifts', to='starcoin.staritem', verbose_name='赠送道具')),
            ],
            options={
                'verbose_name': '每日登录赠礼',
                'verbose_name_plural': '每日登录赠礼',
                'ordering': ['sort_order', 'id'],
            },
        ),
        migrations.AddConstraint(
            model_name='starlogingift',
            constraint=models.UniqueConstraint(fields=('item',), name='uniq_login_gift_item'),
        ),
        migrations.RunPython(seed_gifts, unseed_gifts),
    ]
