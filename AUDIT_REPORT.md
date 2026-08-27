# 项目全面检查报告

> 生成日期：2026-08-26  
> 检查范围：`quiz/` 应用全量代码（models / views / middleware / utils / admin / urls / settings / 模板层）  
> 检查方式：只读静态分析，未运行时插桩  
> 状态：**参考文档，待用户决定是否执行修复**

---

## 一、问题总览

| 等级 | 数量 | 说明 |
|------|------|------|
| 🔴 P0 严重 Bug | 5 类（含 6+18 处） | 影响功能正确性，部分会触发 500/页面渲染异常 |
| 🟠 P1 逻辑/性能 | 7 类 | 语义错误、N+1、事务缺失、安全装饰器缺失 |
| 🟡 P2 可维护性 | 12 类 | 代码组织、重复逻辑、配置风险 |

修复建议优先级：**P0 全部 → P1-1/P1-2/P1-5 → P2 拆分与去重**。

---

## 二、🔴 P0 严重 Bug（建议立即修复）

### P0-1：模板跨行 `{{ }}` 变量未渲染（6 处）

**根因**：Django 3.2 lexer 的变量正则不带 `re.DOTALL`，跨行的 `{{ ... }}` 会被当作普通文本字面输出（与之前修复过的跨行 `{% %}` 同源问题，但 `{{ }}` 漏网）。

| 文件 | 行号 | 跨行变量 | 实际显示 |
|------|------|----------|----------|
| [test_paper_detail.html](file:///d:/0_TG/code2026/need_to_do/quiz/templates/quiz/frontend/test_paper_detail.html#L317-L318) | 317-318 | `{{ test_paper.created_at\|date:"Y-m-d H:i" }}` | "创建时间: {{ test_paper.created_at..." 字面量 |
| [test_paper_detail.html](file:///d:/0_TG/code2026/need_to_do/quiz/templates/quiz/frontend/test_paper_detail.html#L337-L338) | 337-338 | `{{ test_paper.max_attempts }}` | "已答 0/{{ test_paper.max_attempts }} 次" 字面量 |
| [test_paper_detail.html](file:///d:/0_TG/code2026/need_to_do/quiz/templates/quiz/frontend/test_paper_detail.html#L339-L340) | 339-340 | `{{ test_paper.start_time\|date:"m-d H:i" }}` | 开放时间显示字面量 |
| [test_paper_detail.html](file:///d:/0_TG/code2026/need_to_do/quiz/templates/quiz/frontend/test_paper_detail.html#L341-L342) | 341-342 | `{{ test_paper.end_time\|date:"m-d H:i" }}` | 截止时间显示字面量 |
| [user_center.html](file:///d:/0_TG/code2026/need_to_do/quiz/templates/quiz/frontend/user_center.html#L637-L638) | 637-638 | `{{ seg.pct }}` | 复习状态百分比显示字面量 |
| [user_center.html](file:///d:/0_TG/code2026/need_to_do/quiz/templates/quiz/frontend/user_center.html#L651-L652) | 651-652 | `{{ kp.count }}` | 薄弱知识点题数显示字面量 |

**修复方案**：将每个跨行变量合并为单行（IDE 必须关闭自动换行或该行加 `# fmt: off` 类标记）。

---

### P0-2：`reverse` 未导入导致 NameError

**位置**：[views.py:2147](file:///d:/0_TG/code2026/need_to_do/quiz/views.py#L2147)

```python
return redirect(f'{reverse("student_class_assignments")}?t={int(timezone.now().timestamp())}')
```

**根因**：`views.py` 顶部和中部 import 均无 `from django.urls import reverse`（已通过 grep 验证全文仅此一处使用 reverse）。

**触发条件**：学生从 `do_class_assignment` 的 POST 分支提交作业成功后重定向时。

**注**：前端如改走 AJAX 的 `submit_class_assignment`（urls.py:71）则绕过此分支，故此前 P2-3 验证未暴露。

**修复方案**：在 `views.py` 中部 import 区追加 `from django.urls import reverse`；或直接用 `redirect('student_class_assignments')` + querystring 拼接，免去 reverse。

---

### P0-3：`q.answer` 属性不存在导致 AttributeError

**位置**：[views.py:2190](file:///d:/0_TG/code2026/need_to_do/quiz/views.py#L2190)

```python
for q in test_paper.questions.all():
    AnswerRecord.objects.create(
        ...
        correct_answer=q.answer,   # ❌ Question 模型字段是 correct_answer
        ...
    )
```

**根因**：[models.py:85](file:///d:/0_TG/code2026/need_to_do/quiz/models.py#L85) 中 `Question` 字段名为 `correct_answer`，无 `answer` 字段。

**触发条件**：班级考试超时自动提交（do_class_assignment GET 时检测超时，2165-2198 行）走此分支。

**影响**：超时学生访问考试页时抛 500。

**修复方案**：`q.answer` → `q.correct_answer`。

---

### P0-4：注册审核状态与提示信息矛盾

**位置**：[views.py:705-708](file:///d:/0_TG/code2026/need_to_do/quiz/views.py#L705-L708)

```python
profile.approval_status = 1   # 1 = 已通过
profile.save()
messages.success(request, '注册成功！您的账号正在等待管理员审核通过。')  # 矛盾
return redirect('login')
```

**根因**：`approval_status=1` 表示已通过可立即登录，但 message 却说"等待审核"，用户认知错乱。

**修复方案**（二选一）：
- 若开放注册免审核：message 改为"注册成功，请直接登录"；
- 若需审核：`approval_status=0`（未审核），并让用户走 approval_pending 流程。

建议结合 `Profile.ROLE_CHOICES` 与产品定位决定，参考 project_memory"用户角色必须显式定义"。

---

### P0-5：超长单行模板标签（18 处，潜在 P0）

**根因**：项目记忆已记录"IDE auto-formatter hook 会把 >80 字符的单行 `{% %}`/`{{ }}` 折行变成跨行，触发 P0-1 同类 bug"。下列 18 处当前为单行但长度 81-103 字符，下次任意保存即可能被折行：

| 文件 | 行号 | 长度 | 标签摘要 |
|------|------|------|----------|
| class_assignments.html | 230 | 85 | `{% url 'class_assignment_detail' ... %}` |
| class_assignments.html | 232 | 86 | `{% url 'publish_class_assignment' ... %}` |
| class_assignment_detail.html | 280 | 86 | `{% url 'publish_class_assignment' ... %}` |
| class_assignment_detail.html | 297 | 85 | `{% url 'delete_class_assignment' ... %}` |
| class_detail.html | 253 | 83 | `{% url 'approve_application' ... %}` |
| class_detail.html | 255 | 82 | `{% url 'reject_application' ... %}` |
| my_test_papers.html | 459 | 83 | `{% if paper.duration or paper.max_attempts or ... %}` |
| my_test_papers.html | 500 | 83 | `{% elif num >= ...|add:'-2' and num <= ...|add:'2' %}` |
| reset_exam_status.html | 119 | 85 | `{% url 'class_assignment_detail' ... %}` |
| test_history.html | 268 | 81 | `{% elif i >= ...|add:'-2' and ... %}` |
| test_history_detail.html | 230 | 85 | `{% with q_content=...|default:question.content %}` |
| test_history_detail.html | 233 | 88 | `{% with q_explanation=...|default:... %}` |
| test_paper_detail.html | 334 | 103 | `{% if test_paper.duration or test_paper.max_attempts or ... %}` |
| test_paper_list.html | 652 | 83 | `{% elif num >= ...|add:'-2' and ... %}` |
| wrong_question_notebook.html | 576 | 92 | `{% if key == ... and key != ... %}` |
| wrong_question_notebook.html | 593 | 96 | `{% if key in ... and key not in ... %}` |
| wrong_question_notebook.html | 608 | 92 | `{% if '对' == ... and '对' != ... %}` |
| wrong_question_notebook.html | 617 | 92 | `{% if '错' == ... and '错' != ... %}` |
| wrong_question_notebook.html | 682 | 87 | `{% elif i >= ...|add:'-2' and ... %}` |

**修复方案**：
- `{% url %}` 类：用 `{% url 'name' cid=... aid=... as var %}` 拆到多行变量赋值再引用；
- `{% if %}` 多条件：提取为视图层布尔变量传入（如 `is_exam_controlled`），模板只 `{% if is_exam_controlled %}`；
- 分页 `{% elif %}`：封装为 inclusion tag 或 `{% include 'pagination.html' %}`。

---

## 三、🟠 P1 逻辑/性能问题

### P1-1：do_class_assignment GET 每次刷新创建新记录

**位置**：[views.py:2152-2163](file:///d:/0_TG/code2026/need_to_do/quiz/views.py#L2152-L2163)

考试模式下 `if not latest_record or latest_record.is_submitted` → 每次刷新页面（已提交后再次进入）都会创建新的 `ClassAssignmentRecord`，attempt 持续 +1，污染数据库。

**修复方案**：考试模式已提交后直接 redirect 不再进入答题页；未提交的复用 latest_record，不新建。

---

### P1-2：admin_import_questions 缺少事务保护

**位置**：[views.py:2371-2447](file:///d:/0_TG/code2026/need_to_do/quiz/views.py#L2371-L2447)

`BaseTestPaperImporter.process_confirm_import` 用了 `@transaction.atomic`，但 `admin_import_questions` 的 `'questions_json'` 分支逐题 `Question.objects.create(...)` 无事务，中途异常留下部分题目。

**修复方案**：用 `@transaction.atomic` 包裹整个 for 循环，异常 `set_rollback(True)`。

---

### P1-3：`_imported_files_cache` 多 worker 失效

**位置**：[views.py:252](file:///d:/0_TG/code2026/need_to_do/quiz/views.py#L252)

```python
_imported_files_cache = {}  # 进程内存字典
```

waitress 多 worker 部署时各进程缓存独立，防重复导入功能完全失效；注释虽已说明"重启后失效"，但未提及多 worker 场景。

**修复方案**：改用 `cache.set/get`（ LocMem 或 Redis），key 用 file_hash。

---

### P1-4：`Profile.accuracy_rate` 字段语义错误且冗余

**位置**：[views.py:488-493](file:///d:/0_TG/code2026/need_to_do/quiz/views.py#L488-L493)

```python
Profile.objects.filter(pk=profile.pk).update(
    ...
    accuracy_rate=accuracy,   # 本次答题正确率，而非历史累计
)
```

但 [user_center](file:///d:/0_TG/code2026/need_to_do/quiz/views.py#L757-L763) 实时从 `AnswerRecord` 聚合计算正确率，从不读 `Profile.accuracy_rate`。该字段在 admin 列表（[admin.py](file:///d:/0_TG/code2026/need_to_do/quiz/admin.py) 未列）也未被使用，属冗余写入且语义误导。

**修复方案**：移除 `Profile.accuracy_rate` 字段及其 update 逻辑，或改为真正的累计正确率（需要聚合计算后写入）。

---

### P1-5：N+1 查询残留

| 位置 | 问题 | 修复 |
|------|------|------|
| [views.py:2493-2500](file:///d:/0_TG/code2026/need_to_do/quiz/views.py#L2493-L2500) admin_create_testpaper | `for q_id in split(','): Question.objects.get(id=q_id)` | `Question.objects.filter(id__in=ids)` 一次查 + dict 映射 |
| [views.py:1861-1865](file:///d:/0_TG/code2026/need_to_do/quiz/views.py#L1861-L1865) publish_class_assignment | `for student: ClassAssignmentRecord.objects.get_or_create(...)` | `bulk_create` 缺失记录 |
| [views.py:1962-1966](file:///d:/0_TG/code2026/need_to_do/quiz/views.py#L1962-L1966) delete_class_assignment | `for record: record.test_record.delete()` | `TestRecord.objects.filter(pk__in=...).delete()` 批量 |

---

### P1-6：`apply_to_class` 缺少 `@login_required`

**位置**：[views.py:1578](file:///d:/0_TG/code2026/need_to_do/quiz/views.py#L1578)

视图内直接 `request.user`，匿名用户 POST 会触发 `AnonymousUser` 不可保存错误。虽然反爬中间件可能拦截，但应显式加装饰器。

**修复方案**：函数上加 `@login_required`。

---

### P1-7：`parse_datetime_local` 返回 naive datetime

**位置**：[utils.py:92-95](file:///d:/0_TG/code2026/need_to_do/quiz/utils.py#L92-L95)

```python
def parse_datetime_local(datetime_str):
    datetime_clean = datetime_str.replace('T', ' ')
    return datetime.datetime.strptime(datetime_clean, '%Y-%m-%d %H:%M')  # naive
```

`settings.USE_TZ=True` 下存入 `ClassAssignment.deadline` 会触发 Django 警告（naive datetime saved to aware field）。被 [create_class_assignment](file:///d:/0_TG/code2026/need_to_do/quiz/views.py#L1808) 使用。

**修复方案**：`timezone.make_aware` 包裹返回值（参考 create_test_paper 中的 `_parse_dt` 已做 make_aware，可提取为公共函数复用）。

---

## 四、🟡 P2 可维护性/规范

### P2-1：`views.py` 单文件 2568 行 / 110KB

严重违反单一职责。建议拆分：
- `views/accounts.py`：login/register/logout/approval/captcha
- `views/papers.py`：test_paper_list/detail/submit/my_test_papers/create/edit/delete/publish
- `views/wrong.py`：wrong_question_notebook/review/create_paper/submit
- `views/classes.py`：class CRUD/applications
- `views/assignments.py`：class_assignment CRUD/do/submit
- `views/admin_views.py`：admin_import/create/preview
- `views/imports.py`：BaseTestPaperImporter 及子类

### P2-2：答题提交逻辑重复 4 处

`submit_test_paper`、`submit_wrong_question_paper`、`do_class_assignment` POST、`submit_class_assignment` 都重复"收集答案→calculate_score→创建 TestRecord→创建 AnswerRecord"流程。建议提取为 `submit_answers(user, test_paper, questions, user_answers, is_wrong_paper=False)` 公共函数。

### P2-3：import 语句散落函数内（20+ 处）

`from django.db.models import Count/F/Q/Sum` 等在函数内重复 import，应集中到模块顶部。

### P2-4：test_paper_list Hero 统计每次查全表 count

[views.py:332-335](file:///d:/0_TG/code2026/need_to_do/quiz/views.py#L332-L335) 每次列表页都 `TestPaper.objects.filter(...).count()` + `Question.objects.filter(...).count()`，可用 `cache.get_or_set('hero_stats', lambda: ..., 300)` 缓存 5 分钟。

### P2-5：`_paper_editor_context` 加载所有题目到 JSON

[views.py:1185-1197](file:///d:/0_TG/code2026/need_to_do/quiz/views.py#L1185-L1197) 把全部题目序列化为 JSON 注入前端，题目超 1000 道时性能与内存堪忧。建议改前端按学科/章节懒加载或分页。

### P2-6：admin_create_testpaper 加载 `Question.objects.all()`

[views.py:2469](file:///d:/0_TG/code2026/need_to_do/quiz/views.py#L2469) 同 P2-5，无分页。

### P2-7：my_test_papers stats 5 次独立 count

[views.py:1086-1095](file:///d:/0_TG/code2026/need_to_do/quiz/views.py#L1086-L1095) 可合并为 1 个 `aggregate(total=Count('id'), published=Count('id', filter=Q(...)), ...)`。

### P2-8：wrong_question_notebook review_stats 6 次查询

[views.py:884-892](file:///d:/0_TG/code2026/need_to_do/quiz/views.py#L884-L892) 可合并为 1 个 `aggregate` with conditional `Count`。

### P2-9：SECRET_KEY / DB_PASSWORD 默认值硬编码

[settings.py:28](file:///d:/0_TG/code2026/need_to_do/quiz/../../need_to_do/settings.py#L28) 默认 SECRET_KEY 为真实 insecure 串；[settings.py:97](file:///d:/0_TG/code2026/need_to_do/need_to_do/settings.py#L97) 默认 DB_PASSWORD 为真实密码 `Netsky121666880!`。即使有 `os.getenv`，默认值已进入 git 历史，应改为 `os.environ['KEY']` 强制要求或占位符 `'change-me'`。

### P2-10：captcha 字体依赖系统 arial.ttf

[captcha.py:33](file:///d:/0_TG/code2026/need_to_do/quiz/captcha.py#L33) Linux 服务器通常无 arial.ttf，会 fallback 到默认位图字体，验证码不美观且易识别。建议在 `static/` 下打包字体文件并指定绝对路径。

### P2-11：`get_visible_questions` + `_paper_editor_context` 重复扫描

两处都遍历题目做 `parse_options`，可复用同一查询。

### P2-12：`ClassAssignment.get_status_display` / `get_type_display` 重写 Django 内置方法

[models.py:358-362](file:///d:/0_TG/code2026/need_to_do/quiz/models.py#L358-L362) Django 对 `choices` 字段会自动生成 `get_FOO_display`，手动重写虽行为一致但冗余，且未来改 choices 易遗漏。

---

## 五、✅ 已确认良好的部分

为避免重复劳动，以下检查结果良好，无需处理：

- **跨行 `{% %}` 标签**：全文扫描为 0（之前修复过的批次未复发）
- **block / endblock 配对**：所有模板配对正确，无未闭合块（过去导致 HTML 结构泄漏的问题已根治）
- **m2m_changed 信号**：TestPaper.total_score 由信号 + `update()` 维护，避免了 save 递归
- **反爬中间件**：限流用 `cache.add` + `cache.incr` 不重置 TTL；cookie 用 HMAC 签名防伪造；逻辑正确
- **submit_test_paper 并发**：用 `F()` 表达式更新 Profile 统计，避免读-改-写竞态
- **bulk_create 优化**：AnswerRecord 批量插入、Notification.notify_many 已使用
- **select_related / annotate**：test_history、user_center、class_detail 等已避免 N+1

---

## 六、建议执行顺序

如决定修复，建议按以下顺序分批进行（每批可独立验证）：

1. **第一批（P0 模板类，约 30 分钟）**：P0-1（6 处跨行 `{{ }}`）+ P0-5（18 处超长标签重构）  
   务必一次性完成，否则下次保存文件又会被格式化器折回。
2. **第二批（P0 代码类，约 20 分钟）**：P0-2（reverse import）+ P0-3（q.answer）+ P0-4（注册审核）
3. **第三批（P1 高价值，约 40 分钟）**：P1-1（do_class_assignment 记录污染）+ P1-2（事务）+ P1-5（N+1）+ P1-6（login_required）+ P1-7（naive datetime）
4. **第四批（P1 次要 + P2 配置，约 30 分钟）**：P1-3（缓存迁移）+ P1-4（accuracy_rate）+ P2-9（密钥）+ P2-10（字体）
5. **第五批（P2 重构，按需）**：P2-1 拆分 views.py + P2-2 提取公共函数 + P2-7/P2-8 聚合优化

**验证方式建议**：
- 模板类：浏览器访问 test_paper_detail / user_center / wrong_question_notebook 等页面，确认字面量消失、数值显示正常
- 代码类：`manage.py check` + Django test client 模拟提交作业/注册流程
- 性能类：Django Debug Toolbar 查看查询数

---

*本报告为只读分析结果，未对任何文件做修改。请审阅后告知是否执行修复及执行范围。*
