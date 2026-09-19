# 按源表重算 Profile 的榜单冗余计数（幂等，可重复执行）。
# 榜单与个人正确率都实时读 Profile 上的这些字段，一旦某个答题入口漏更新，或历史数据本就
# 不一致，就会与实际答题记录对不上。本命令以 AnswerRecord / ConqueredQuestion / TestRecord
# 为准做全量重算，用于修复脏数据。
from django.core.management.base import BaseCommand
from django.db.models import Count, Q, Sum

from quiz.models import AnswerRecord, ConqueredQuestion, Profile, TestRecord

# 需要重算的字段
STATS_FIELDS = ['answered_total', 'answered_correct', 'conquered_count', 'tests_taken', 'total_score']


class Command(BaseCommand):
    help = '按 AnswerRecord / ConqueredQuestion / TestRecord 重算 Profile 的榜单统计字段'

    def handle(self, *args, **options):
        # 作答题次 / 答对题次：只统计实际作答的题，未作答的题不计入正确率分母
        # 注意：AnswerRecord.Meta.ordering 会被带进 SELECT，必须先 order_by() 清空排序
        answered = {
            row['test_record__user_id']: row
            for row in AnswerRecord.objects.order_by().values('test_record__user_id').annotate(
                total=Count('id', filter=Q(user_answer__isnull=False) & ~Q(user_answer='')),
                correct=Count('id', filter=Q(is_correct=True)),
            )
        }
        # 斩题数：答对且去重的题目数
        conquered = {
            row['user_id']: row['cnt']
            for row in ConqueredQuestion.objects.order_by()
            .values('user_id').annotate(cnt=Count('id'))
        }
        # 答题次数 / 累计得分：按答题记录累计（与 submit_paper_records 的累加口径一致）
        tests = {
            row['user_id']: row
            for row in TestRecord.objects.order_by().values('user_id').annotate(
                cnt=Count('id'), total=Sum('score'))
        }

        updates = []
        profile_count = 0
        for profile in Profile.objects.all().iterator(chunk_size=500):
            profile_count += 1
            row = answered.get(profile.user_id) or {}
            test_row = tests.get(profile.user_id) or {}
            profile.answered_total = row.get('total', 0)
            profile.answered_correct = row.get('correct', 0)
            profile.conquered_count = conquered.get(profile.user_id, 0)
            profile.tests_taken = test_row.get('cnt', 0)
            profile.total_score = test_row.get('total') or 0
            updates.append(profile)
            if len(updates) >= 500:
                Profile.objects.bulk_update(updates, STATS_FIELDS)
                updates = []
        if updates:
            Profile.objects.bulk_update(updates, STATS_FIELDS)

        self.stdout.write(self.style.SUCCESS(
            f'榜单统计重算完成，共处理 {profile_count} 个会员'))
