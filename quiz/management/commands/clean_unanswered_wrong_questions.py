# 一次性数据修复：清理「未作答被当成答错」时期误写入错题本的脏数据。
# 判定依据：WrongQuestion.user_answer 为空（NULL 或空串），且该用户对这道题从未真正答错过。
# 正常答错时 user_answer 一定会写入用户答案（单选/多选/判断的答案都不可能是空串），
# 所以空值只可能来自那条错误的老逻辑。但老逻辑在「跳过不答」时是覆盖写入，
# 会把之前记录的错误答案抹成空 —— 因此还要排除掉「AnswerRecord 里有非空答错记录」的题，
# 那些是真错题，不能删。
# 删除后若用户以后真的答错，会自动重新入错题本。
from django.core.management.base import BaseCommand
from django.db.models import Exists, OuterRef, Q

from quiz.models import AnswerRecord, WrongQuestion


class Command(BaseCommand):
    help = '清理错题本中由「未作答」误写入的脏数据（user_answer 为空且从未真正答错的错题）'

    def add_arguments(self, parser):
        parser.add_argument('--dry-run', action='store_true', help='只统计数量，不删除')

    def handle(self, *args, **options):
        answered_wrong = AnswerRecord.objects.filter(
            test_record__user_id=OuterRef('user_id'),
            question_id=OuterRef('question_id'),
            is_correct=False,
        ).exclude(Q(user_answer__isnull=True) | Q(user_answer=''))

        polluted = (
            WrongQuestion.objects
            .filter(Q(user_answer__isnull=True) | Q(user_answer=''))
            .annotate(ever_answered_wrong=Exists(answered_wrong))
            .filter(ever_answered_wrong=False)
        )
        # 先取出主键再删，避免带 annotate/Exists 的 queryset 直接 delete 带来意外
        ids = list(polluted.values_list('pk', flat=True))
        if options['dry_run']:
            self.stdout.write(f'匹配到 {len(ids)} 条从未被真正答错的错题（--dry-run，未删除）')
            return
        deleted, _details = WrongQuestion.objects.filter(pk__in=ids).delete()
        self.stdout.write(self.style.SUCCESS(f'已清理 {deleted} 条错题本脏数据'))
