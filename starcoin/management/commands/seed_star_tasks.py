"""初始化内置星币任务。

用法：python manage.py seed_star_tasks
已存在的任务不会被覆盖，管理员在后台的调整会保留。
"""

from django.core.management.base import BaseCommand

from starcoin.models import StarTask

DEFAULT_TASKS = [
    {
        'code': 'daily_login',
        'name': '每日登录',
        'description': '每天登录一次即可领取',
        'icon': '📅',
        'reward_coins': 5,
        'period': StarTask.PERIOD_DAILY,
        'daily_limit': 0,
        'threshold': 0,
        'sort_order': 10,
    },
    {
        'code': 'submit_paper',
        'name': '完成试卷',
        'description': '每天完成一份试卷',
        'icon': '📝',
        'reward_coins': 3,
        'period': StarTask.PERIOD_DAILY,
        'daily_limit': 0,
        'threshold': 0,
        'sort_order': 20,
    },
    {
        'code': 'pass_paper',
        'name': '试卷达标',
        'description': '试卷得分率达到 60% 以上',
        'icon': '🎯',
        'reward_coins': 10,
        'period': StarTask.PERIOD_DAILY,
        'daily_limit': 0,
        'threshold': 60,
        'sort_order': 30,
    },
    {
        'code': 'submit_assignment',
        'name': '完成班级作业',
        'description': '每天完成一份班级作业或考试',
        'icon': '📋',
        'reward_coins': 8,
        'period': StarTask.PERIOD_DAILY,
        'daily_limit': 0,
        'threshold': 0,
        'sort_order': 40,
    },
    {
        'code': 'conquer_question',
        'name': '斩题奖励',
        'description': '每答对一道此前未答对的题目',
        'icon': '🗡️',
        'reward_coins': 1,
        'period': StarTask.PERIOD_UNLIMITED,
        'daily_limit': 30,
        'threshold': 0,
        'sort_order': 50,
    },
    {
        'code': 'login_streak_7',
        'name': '连续登录 7 天',
        'description': '连续登录每满 7 天，额外奖励一次',
        'icon': '🔥',
        'reward_coins': 50,
        'period': StarTask.PERIOD_MILESTONE,
        'daily_limit': 0,
        'threshold': 0,
        'sort_order': 60,
    },
    {
        'code': 'login_streak_30',
        'name': '连续登录 30 天',
        'description': '连续登录每满 30 天，额外奖励一次',
        'icon': '🏅',
        'reward_coins': 300,
        'period': StarTask.PERIOD_MILESTONE,
        'daily_limit': 0,
        'threshold': 0,
        'sort_order': 70,
    },
    {
        'code': 'share_leaderboard',
        'name': '分享榜单',
        'description': '每天首次生成榜单分享图，奖励一次',
        'icon': '📤',
        'reward_coins': 5,
        'period': StarTask.PERIOD_DAILY,
        'daily_limit': 0,
        'threshold': 0,
        'sort_order': 80,
    },
]


class Command(BaseCommand):
    help = '初始化内置星币任务（已存在的任务不会覆盖）'

    def handle(self, *args, **options):
        created = 0
        for data in DEFAULT_TASKS:
            _task, is_new = StarTask.objects.get_or_create(
                code=data['code'], defaults=data)
            if is_new:
                created += 1
        self.stdout.write(self.style.SUCCESS(
            f'星币任务初始化完成：新增 {created} 个，已存在 {len(DEFAULT_TASKS) - created} 个'))
