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
def role_greeting(role, is_staff):
    """根据用户角色返回问候语后缀，替代模板里超长跨行 if/elif/else。

    用法：
        <span>{{ user.username }}</span>{% role_greeting role user.is_staff %}
    """
    if role == 'student' and not is_staff:
        return '，继续加油学习吧！'
    if role == 'teacher':
        return '，欢迎管理您的班级！'
    return '，欢迎回来管理员！'
