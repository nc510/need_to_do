"""星币活跃奖励事件钩子。

供登录、交卷、交作业、斩题等主流程单行调用。
钩子内部吞掉异常并记录日志：星币发放失败绝不阻断答题等主流程。
"""

import logging

from django.utils import timezone

from .models import StarTask
from .services import (
    grant_login_gift,
    grant_task_reward,
    record_login,
    streak_milestone_key,
)

logger = logging.getLogger(__name__)

# 连续登录里程碑：任务 code → 需要的连续天数（与模型定义同源）
STREAK_MILESTONES = StarTask.MILESTONE_CYCLES

# session 标记：记录「赠礼已在本日检查/发放过」，避免每次访问都查库
DAILY_GIFT_SESSION_KEY = 'star_daily_gift_checked'


def _grant(code, user, **kwargs):
    try:
        return grant_task_reward(user, code, **kwargs)
    except Exception:
        logger.exception('星币奖励发放异常：code=%s user=%s', code, getattr(user, 'id', None))
        return None


def on_login(user):
    """登录成功：每日登录奖励 + 连续登录里程碑奖励（7 天 / 30 天，按轮次循环）。

    返回当日登录赠礼的提示文案（同一天第二次登录起返回 ''，赠礼当天只发一次），
    由调用方展示给用户。
    """
    _grant('daily_login', user)
    try:
        streak, _is_first_today = record_login(user)
    except Exception:
        logger.exception('连续登录记录失败：user=%s', getattr(user, 'id', None))
        return ''
    for code, cycle_days in STREAK_MILESTONES:
        if streak.current_days >= cycle_days:
            _grant(code, user, period_key=streak_milestone_key(streak, cycle_days))
    try:
        return grant_login_gift(user)
    except Exception:
        logger.exception('每日登录赠礼发放失败：user=%s', getattr(user, 'id', None))
        return ''


def on_page_view(request):
    """当天首次访问任意页面时补发每日登录赠礼。

    赠礼原先只挂在「登录」动作上：登录后长期不退出登录（session 一直有效）的用户
    当天拿不到赠礼。这里按「本地自然日」判定，当天第一次打开页面时补发；
    发放本身由 services.grant_login_gift 保证幂等，登录时已发过的不会重复发。

    返回赠礼提示文案（本日已检查过 / 已发过时返回 ''），调用方负责展示。
    """
    user = getattr(request, 'user', None)
    if user is None or not user.is_authenticated:
        return ''
    today = timezone.localdate().isoformat()
    if request.session.get(DAILY_GIFT_SESSION_KEY) == today:
        return ''
    # 先落 session 标记：即使本次发放异常，也不要在接下来每次访问都重试
    request.session[DAILY_GIFT_SESSION_KEY] = today
    try:
        return grant_login_gift(user)
    except Exception:
        logger.exception('每日登录赠礼补发失败：user=%s', getattr(user, 'id', None))
        return ''


def on_leaderboard_shared(user):
    """分享榜单（生成分享图片）：每日一次奖励"""
    return _grant('share_leaderboard', user)


def on_paper_submitted(user, score_percent=None):
    """提交试卷：完成试卷奖励 + 达标奖励（按得分百分比判定阈值）"""
    _grant('submit_paper', user)
    if score_percent is not None:
        _grant('pass_paper', user, score_percent=score_percent)


def on_assignment_submitted(user):
    """提交班级作业/考试"""
    return _grant('submit_assignment', user)


def on_questions_conquered(user, count):
    """本次新斩获的题：按新增数量逐次发放（对应「每次触发」型任务）"""
    for _ in range(int(count or 0)):
        _grant('conquer_question', user)
