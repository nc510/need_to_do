# 本模块由 quiz/views.py 拆分生成（P2-1），公共依赖（import/类/常量/工具函数）见 views_common.py
from .views_common import *  # noqa: F401,F403
# 后台组卷复用前端手工组卷的选题上下文（学科/章节/知识点级联筛选 + 分页 + 随机选题）
from .views_paper import _paper_editor_context  # noqa: E402

class QuestionImporter:
    """后台导入题库 - 只导入题目到共享题库，可选一键生成试卷"""
    
    def __init__(self, request):
        self.request = request
        self.template_name = 'quiz/admin/import_questions.html'
    
    def handle(self):
        """主处理函数"""
        request = self.request
        if request.method == 'POST':
            if 'questions_json' in request.POST:
                return self.process_confirm_import()
            elif request.FILES.get('file'):
                return self.process_file_upload()
        return render(request, self.template_name, {'step': 1})
    
    def process_file_upload(self):
        """处理文件上传"""
        request = self.request
        file = request.FILES['file']
        file_content = file.read()
        file.seek(0)
        
        is_dup, prev_count, import_time = is_duplicate_import(file_content)
        if is_dup:
            messages.error(request,
                f'检测到重复导入！该文件已于 {import_time.strftime("%Y-%m-%d %H:%M")} 导入，'
                f'共导入 {prev_count} 道题目。如需重新导入，请等待24小时或修改文件内容后重试。')
            return render(request, self.template_name, {'step': 1})
        
        questions_data, stats, errors = import_questions_from_excel(file)
        
        if errors:
            messages.error(request, errors[0])
            return render(request, self.template_name, {'step': 1})
        
        for idx, q in enumerate(questions_data):
            q['row'] = idx + 2
            q['has_error'] = not (q.get('correct_answer') and q.get('score'))
        
        request.session['import_file_hash'] = generate_file_hash(file_content)
        request.session['import_questions_data'] = questions_data
        
        return render(request, self.template_name, {
            'step': 2,
            'questions_data': questions_data,
            'questions_json': json.dumps(questions_data, ensure_ascii=False),
            'total_score': stats['total_score'],
            'valid_count': stats['valid_count'],
            'missing_count': stats['missing_count'],
            'errors': stats['errors']
        })
    
    def process_confirm_import(self):
        """处理确认导入（复用公共建题函数；可选一键成卷）"""
        request = self.request
        questions_json = request.POST.get('questions_json', '')
        
        if not questions_json:
            messages.error(request, '没有题目数据，请重新上传文件')
            return render(request, self.template_name, {'step': 1})
        
        try:
            questions_data = json.loads(questions_json)
            create_paper = request.POST.get('create_paper') == '1'
            title = request.POST.get('title', '').strip() or '导入试卷'
            description = request.POST.get('description', '')
            
            with transaction.atomic():
                paper = None
                if create_paper:
                    paper = TestPaper.objects.create(
                        title=title,
                        description=description,
                        created_by='admin',
                        is_published=False,
                    )
                questions = []
                for q_data in questions_data:
                    question = create_question_from_data(
                        q_data, is_public=True, created_by='admin')
                    if question:
                        questions.append(question)
                if paper:
                    paper.questions.set(questions)
                    paper.total_score = sum(q.score for q in questions)
                    paper.save()
            
            imported_count = len(questions)
            if 'import_file_hash' in request.session:
                file_hash = request.session.pop('import_file_hash', None)
                if file_hash:
                    mark_imported(file_hash, imported_count)
                request.session.pop('import_questions_data', None)
            
            if paper:
                messages.success(request,
                    f'试卷 "{paper.title}" 创建成功！共导入 {imported_count} 道题目并加入共享题库，总分 {paper.total_score} 分。')
                return redirect('admin_preview_testpaper', paper_id=paper.id)
            return render(request, self.template_name, {'step': 3, 'imported_count': imported_count})
        except Exception as e:
            messages.error(request, f'导入失败：{str(e)}')
            return render(request, self.template_name, {'step': 1})


@staff_member_required
def admin_import_questions(request):
    """后台导入试题 - 导入题目到共享题库（统一导入器）"""
    importer = QuestionImporter(request)
    return importer.handle()

from django.http import JsonResponse

@staff_member_required
def admin_export_template(request):
    """下载后台导入模板"""
    return download_template_response()

def download_import_template(request):
    """下载前台导入模板"""
    return download_template_response()

@staff_member_required
def admin_create_testpaper(request):
    """后台组卷"""
    if request.method == 'POST':
        title = request.POST.get('title')
        description = request.POST.get('description')
        is_published = request.POST.get('is_published') == 'on'
        selected_questions = request.POST.get('selected_questions')
        # 与前端手工组卷一致：JS 隐藏域为空时回退到复选框 name="questions"
        if not selected_questions:
            selected_questions = ','.join(request.POST.getlist('questions'))
        
        if not title:
            messages.error(request, '请输入试卷标题')
            return redirect('admin_create_testpaper')
        
        if not selected_questions:
            messages.error(request, '请选择至少一道题目')
            return redirect('admin_create_testpaper')
        
        test_paper = TestPaper.objects.create(
            title=title,
            description=description,
            created_by='admin',
            is_published=is_published
        )
        
        # P1-5：避免逐题 Question.objects.get 触发 N+1，改为一次 filter + in_bulk
        raw_ids = selected_questions.split(',')
        valid_ids = []
        for q_id in raw_ids:
            q_id = q_id.strip()
            if not q_id:
                continue
            try:
                valid_ids.append(int(q_id))
            except (ValueError, TypeError):
                messages.warning(request, f'无效的题目ID: {q_id}')
        questions_by_id = Question.objects.filter(id__in=valid_ids).in_bulk()
        found_ids = set(questions_by_id.keys())
        for q_id in valid_ids:
            if q_id not in found_ids:
                messages.warning(request, f'题目ID {q_id} 不存在，已跳过')
        questions = list(questions_by_id.values())
        if questions:
            test_paper.questions.set(questions)
        total_score = sum(q.score for q in questions)
        
        test_paper.total_score = total_score
        test_paper.save()
        
        messages.success(request, f'试卷 "{title}" 创建成功！')
        return redirect('admin_preview_testpaper', paper_id=test_paper.id)
    
    # ===== 复用前端手工组卷的选题体验（学科/章节/知识点级联筛选 + 分页 + 随机选题）=====
    context = _paper_editor_context(request)
    if context.get('redirect_url'):
        return redirect(request.path + context['redirect_url'])
    return render(request, 'quiz/admin/create_testpaper.html', context)

@staff_member_required
def admin_preview_testpaper(request, paper_id):
    test_paper = get_object_or_404(TestPaper, pk=paper_id)
    questions = list(test_paper.questions.all())
    
    for idx, q in enumerate(questions):
        q.options = parse_options(q.options)
        q.seq = idx + 1  # 题目序号
        # 设置 type_name 用于模板显示
        type_map = dict(Question.TYPE_CHOICE)
        q.type_name = type_map.get(q.type, '')
    
    total_score = sum(q.score for q in questions)
    
    return render(request, 'quiz/admin/preview_testpaper.html', {
        'test_paper': test_paper,
        'questions': questions,
        'total_questions': len(questions),
        'total_score': total_score,
    })

@staff_member_required
def admin_import_testpaper(request):
    """后台导入试卷 - 使用导入器类"""
    importer = AdminTestPaperImporter(request)
    return importer.handle()


