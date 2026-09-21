"""quiz 应用自定义模板标签。

主要用途：把过去写在 HTML class 属性里的超长 `{% if %}` 表达式
（如判断某选项是否为正确答案/用户答案）收敛为一个短标签，
避免模板标签跨行/超长触发 Django 3.2 lexer 问题。
"""
from django import template

register = template.Library()


@register.simple_tag
def option_class(key, correct_answer, user_answer, multi=False):
    """返回 option-item 的 class 字符串。

    用法（单选/判断题）：
        {% with ca=wq.question.correct_answer ua=wq.user_answer %}
        <div class="{% option_class key ca ua %}"> ... </div>
        {% endwith %}

    用法（多选题，传 True 开启子串匹配）：
        <div class="{% option_class key ca ua True %}">

    判断 key 是否为正确答案 / 用户错答，组合 'correct'/'wrong' class。
    """
    if multi:
        is_correct = key in (correct_answer or '')
        is_wrong = key in (user_answer or '') and key not in (correct_answer or '')
    else:
        is_correct = key == correct_answer
        is_wrong = key == user_answer and key != correct_answer
    cls = 'option-item'
    if is_correct:
        cls += ' correct'
    if is_wrong:
        cls += ' wrong'
    return cls


@register.simple_tag
def selected_attr(value, current):
    """下拉框选中态：值相等返回 'selected'，否则返回空串。

    用法：
        <option value="{{ opt.key }}" {% selected_attr opt.key author %}>

    收敛模板里的 `==` 比较：IDE 自动格式化会删掉比较运算符两侧空格
    （`{% if author == opt.key %}` 变成 `{% if author==opt.key %}`），
    Django 3.2 的 smartif 无法解析这种写法。
    """
    return 'selected' if str(value) == str(current) else ''


@register.simple_tag
def rank_medal(rank):
    """名次徽标：前三名返回奖牌，其余返回名次数字。

    用法：
        <div class="lb-rank">{% rank_medal row.rank %}</div>

    收敛模板里 `{% if row.rank == 1 %}🥇{% elif ... %}` 这种超长 if/elif 链：
    它超过 80 字符后会被 IDE 自动格式化折行，而 Django 的标签正则不跨行匹配，
    折行后的 `{{` / `}}` 会被当成普通文本直接输出到页面上。
    """
    return {1: '🥇', 2: '🥈', 3: '🥉'}.get(rank, str(rank))


@register.simple_tag
def role_greeting(role):
    """根据用户角色返回问候语后缀，替代模板里超长跨行 if/elif/else。

    判定只看角色，不看 is_staff：班级管理员常由学生担任，
    他们拥有后台权限但仍是学生，与榜单排名口径保持一致。

    用法：
        <span>{{ user.username }}</span>{% role_greeting role %}
    """
    if role == 'student':
        return '，继续加油学习吧！'
    if role == 'teacher':
        return '，欢迎管理您的班级！'
    return '，欢迎回来管理员！'
