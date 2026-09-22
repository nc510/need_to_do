from decimal import Decimal, InvalidOperation

from django import template

register = template.Library()


@register.filter
def money(value):
    """金额展示：去掉无意义的尾零。

    9.90 -> 9.9，99.00 -> 99，89.10 -> 89.1，0.99 -> 0.99。
    非数值原样返回，避免模板渲染报错。
    """
    try:
        text = f'{Decimal(str(value)):.2f}'
    except (InvalidOperation, TypeError, ValueError):
        return value
    return text.rstrip('0').rstrip('.')
