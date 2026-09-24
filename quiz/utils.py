from django.core.paginator import Paginator, PageNotAnInteger, EmptyPage
from django.http import HttpResponse
from django.conf import settings
from functools import lru_cache
from openpyxl.utils import get_column_letter
import logging
import openpyxl
from openpyxl.styles import Font, Alignment, PatternFill, Border, Side
from openpyxl.utils.exceptions import InvalidFileException
import io
import json

logger = logging.getLogger(__name__)

def parse_options(options_str):
    """解析选项字段，如果是字符串则尝试JSON解析"""
    if isinstance(options_str, str):
        try:
            return json.loads(options_str)
        except (json.JSONDecodeError, ValueError):
            return {}
    return options_str or {}

def paginate_queryset(queryset, page_num, items_per_page=9):
    paginator = Paginator(queryset, items_per_page)
    try:
        paginated_items = paginator.page(page_num)
    except PageNotAnInteger:
        paginated_items = paginator.page(1)
    except EmptyPage:
        paginated_items = paginator.page(paginator.num_pages)
    return paginated_items

# 判断题答案映射，将各种表示统一为标准值
TRUE_VALUES = {'对', '正确', '是', 't', 'true', '1', 'yes', 'y'}
FALSE_VALUES = {'错', '错误', '否', 'f', 'false', '0', 'no', 'n'}

def normalize_judge_answer(answer):
    """标准化判断题答案"""
    if answer is None:
        return None
    answer = str(answer).strip().lower()
    if answer in TRUE_VALUES:
        return 'true'
    elif answer in FALSE_VALUES:
        return 'false'
    return answer

def compare_answers(user_answer, correct_answer):
    if user_answer is None:
        return False
    
    # 尝试判断题特殊处理
    normalized_user = normalize_judge_answer(user_answer)
    normalized_correct = normalize_judge_answer(correct_answer)
    
    # 如果是判断题答案（已标准化），使用标准化后的值比较
    if normalized_user in ('true', 'false') and normalized_correct in ('true', 'false'):
        return normalized_user == normalized_correct
    
    # 默认使用精确匹配
    return user_answer.strip().lower() == correct_answer.strip().lower()

def calculate_score(questions, user_answers):
    """计算本次答题得分与各状态题数。

    未作答的题既不算对也不算错：不计入正确率分母、不进错题本、不计入 wrong_count，
    仅在结果里标记为「未答」（question_results[].result）。
    """
    score = 0
    correct_count = 0
    wrong_count = 0
    question_results = []

    for question in questions:
        # views 用 int key，优先 int 查找；fallback str key 兼容（避免每次两次 dict get）
        user_answer = user_answers.get(question.id)
        if user_answer is None:
            user_answer = user_answers.get(str(question.id))
        is_correct = compare_answers(user_answer, question.correct_answer)

        if is_correct:
            score += question.score
            correct_count += 1
            result = '正确'
        elif user_answer is None:
            result = '未答'
        else:
            wrong_count += 1
            result = '错误'

        question_results.append({
            'question': question,
            'user_answer': user_answer,
            'correct_answer': question.correct_answer,
            'result': result,
            'score': question.score,
            'is_correct': is_correct
        })

    total_count = len(question_results)

    return score, correct_count, wrong_count, total_count, question_results

def parse_datetime_local(datetime_str):
    """解析本地时间字符串，返回 aware datetime（带时区）。
    避免 Django 发出 naive datetime 警告，且与 timezone.now() 比较时类型一致。
    """
    from django.utils import timezone
    import datetime
    datetime_clean = datetime_str.replace('T', ' ')
    naive = datetime.datetime.strptime(datetime_clean, '%Y-%m-%d %H:%M')
    # USE_TZ=True 时，将 naive 转为 aware；USE_TZ=False 时直接返回 naive
    if settings.USE_TZ:
        return timezone.make_aware(naive)
    return naive

class ExcelImporter:
    HEADER_ALIASES = {
        'content': ['content', '题目', '题目内容', 'question', '题干'],
        'type': ['type', '题型', '题目类型', '类别'],
        'option_a': ['option_a', '选项A', 'A', '选项a'],
        'option_b': ['option_b', '选项B', 'B', '选项b'],
        'option_c': ['option_c', '选项C', 'C', '选项c'],
        'option_d': ['option_d', '选项D', 'D', '选项d'],
        'options': ['options', '选项', '所有选项'],
        'correct_answer': ['correct_answer', '答案', '正确答案', '参考答案', 'answer'],
        'score': ['score', '分值', '分数', '得分'],
        'explanation': ['explanation', '解析', '答案解析', '解析说明'],
        'subject': ['subject', '学科', '科目', '所属学科', '学科名称'],
        'chapter': ['chapter', '章节', '所属章节', '章', '章节名称'],
        'section': ['section', '小节', '所属小节', '节', '小节名称'],
        'knowledge_points': ['knowledge_points', '知识点', '知识要点', '关联知识点', 'kp'],
    }

    TYPE_MAPPING = {
        '3': 3, '判断题': 3, '判断': 3, 'judge': 3,
        '2': 2, '多选题': 2, '多选': 2, 'multiple': 2,
        '1': 1, '单选题': 1, '单选': 1, 'single': 1, '选择题': 1, '选择': 1, 'choice': 1
    }

    def __init__(self, worksheet, required_keys=None):
        self.ws = worksheet
        self.errors = []
        self.warnings = []
        self.header_map = {}
        if required_keys is None:
            required_keys = ['content', 'correct_answer', 'score']
        self.required_keys = required_keys

    def parse_headers(self):
        headers = [cell.value for cell in self.ws[1]]
        for idx, header in enumerate(headers):
            if header:
                header_str = str(header).strip()
                header_lower = header_str.lower()
                for key, aliases in self.HEADER_ALIASES.items():
                    if header_lower in aliases or header_str in aliases:
                        self.header_map[key] = idx
                        break
        missing = [k for k in self.required_keys if k not in self.header_map]
        return missing

    def parse_row(self, row, row_idx):
        try:
            content = str(row[self.header_map['content']].value or '').strip()
            if not content:
                return None

            q_type = 1
            if 'type' in self.header_map:
                type_val = row[self.header_map['type']].value
                if type_val is not None:
                    type_str = str(type_val).strip()
                    q_type = self.TYPE_MAPPING.get(type_str, 1)

            options = self._parse_options(row)
            correct_answer = str(row[self.header_map['correct_answer']].value or '').strip()
            score = self._parse_score(row)
            explanation = ''
            if 'explanation' in self.header_map:
                explanation = str(row[self.header_map['explanation']].value or '').strip()

            subject_name = ''
            if 'subject' in self.header_map:
                subject_val = row[self.header_map['subject']].value
                if subject_val:
                    subject_name = str(subject_val).strip()

            chapter_title = ''
            if 'chapter' in self.header_map:
                chapter_val = row[self.header_map['chapter']].value
                if chapter_val:
                    chapter_title = str(chapter_val).strip()

            section_title = ''
            if 'section' in self.header_map:
                section_val = row[self.header_map['section']].value
                if section_val:
                    section_title = str(section_val).strip()

            knowledge_points_str = ''
            if 'knowledge_points' in self.header_map:
                kp_val = row[self.header_map['knowledge_points']].value
                if kp_val:
                    knowledge_points_str = str(kp_val).strip()

            has_error = not correct_answer or (not score and score != 0)
            if not correct_answer:
                self.errors.append(f'第{row_idx}行：正确答案为空')
            if not score and score != 0:
                self.errors.append(f'第{row_idx}行：分值格式错误')

            return {
                'content': content,
                'type': q_type,
                'options': options,
                'correct_answer': correct_answer,
                'score': score,
                'explanation': explanation,
                'subject_name': subject_name,
                'chapter_title': chapter_title,
                'section_title': section_title,
                'knowledge_points_str': knowledge_points_str,
                'row': row_idx,
                'has_error': has_error
            }
        except Exception as e:
            self.errors.append(f'第{row_idx}行：{str(e)}')
            return None

    def _parse_options(self, row):
        options = {}
        option_cols = ['option_a', 'option_b', 'option_c', 'option_d']
        option_letters = ['A', 'B', 'C', 'D']

        for col_key, letter in zip(option_cols, option_letters):
            if col_key in self.header_map:
                val = row[self.header_map[col_key]].value
                if val and str(val).strip():
                    options[letter] = str(val).strip()

        if not options and 'options' in self.header_map:
            options_str = str(row[self.header_map['options']].value or '').strip()
            if options_str:
                for item in options_str.split(','):
                    item = item.strip()
                    if item and len(item) >= 2:
                        letter = item[0].upper()
                        if letter in ['A', 'B', 'C', 'D']:
                            options[letter] = item[1:].strip()

        return options

    def _parse_score(self, row):
        try:
            score = int(row[self.header_map['score']].value or 0)
            return score if score > 0 else ''
        except:
            return ''

    def parse_all(self):
        questions_data = []
        for row_idx, row in enumerate(self.ws.iter_rows(min_row=2), start=2):
            parsed = self.parse_row(row, row_idx)
            if parsed:
                questions_data.append(parsed)
        return questions_data

def create_import_template():
    wb = openpyxl.Workbook()
    ws = wb.active
    ws.title = "题目导入模板"

    header_font = Font(bold=True, color="FFFFFF", size=11)
    header_fill = PatternFill(start_color="667EEA", end_color="764BA2", fill_type="solid")
    header_alignment = Alignment(horizontal="center", vertical="center", wrap_text=True)
    thin_border = Border(
        left=Side(style='thin'), right=Side(style='thin'),
        top=Side(style='thin'), bottom=Side(style='thin')
    )

    headers = ['题目内容', '题型', '选项A', '选项B', '选项C', '选项D', '正确答案', '分值', '解析', '学科', '章节', '小节', '知识点']
    for col_idx, header in enumerate(headers, start=1):
        cell = ws.cell(row=1, column=col_idx, value=header)
        cell.font = header_font
        cell.fill = header_fill
        cell.alignment = header_alignment
        cell.border = thin_border

    example_data = [
        ['以下哪个是Python的关键字？', '单选题', 'and', 'or', 'true', 'false', 'A', 5, 'and是Python的关键字', '计算机', '第一章 基础语法', '1.1 关键字', '关键字,标识符'],
        ['下列哪些是Python的数据类型？', '多选题', 'int', 'str', 'list', 'dict', 'ABCD', 10, 'Python支持多种数据类型', '计算机', '第一章 基础语法', '1.2 数据类型', '数据类型,int,str'],
        ['Python是一种编程语言', '判断题', '', '', '', '', '正确', 3, 'Python确实是编程语言', '计算机', '第一章 基础语法', '1.1 关键字', '编程语言'],
    ]

    for row_idx, row_data in enumerate(example_data, start=2):
        for col_idx, value in enumerate(row_data, start=1):
            cell = ws.cell(row=row_idx, column=col_idx, value=value)
            cell.alignment = Alignment(vertical="center", wrap_text=True)
            cell.border = thin_border

    ws.column_dimensions['A'].width = 30
    ws.column_dimensions['B'].width = 8
    ws.column_dimensions['C'].width = 12
    ws.column_dimensions['D'].width = 12
    ws.column_dimensions['E'].width = 12
    ws.column_dimensions['F'].width = 12
    ws.column_dimensions['G'].width = 10
    ws.column_dimensions['H'].width = 8
    ws.column_dimensions['I'].width = 20
    ws.column_dimensions['J'].width = 12
    ws.column_dimensions['K'].width = 18
    ws.column_dimensions['L'].width = 15
    ws.column_dimensions['M'].width = 25
    ws.freeze_panes = 'A2'

    return wb

def download_template_response(filename='题目导入模板.xlsx'):
    wb = create_import_template()
    response = HttpResponse(content_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
    response['Content-Disposition'] = f'attachment; filename={filename}'
    wb.save(response)
    return response

def import_questions_from_excel(file, subject_map=None, chapter_map=None, section_map=None, knowledge_point_map=None):
    try:
        wb = openpyxl.load_workbook(file)
        ws = wb.active
        importer = ExcelImporter(ws)
        missing = importer.parse_headers()
        if missing:
            return None, None, [f'缺少必需列：{", ".join(missing)}']
        questions_data = importer.parse_all()
        if not questions_data:
            return None, None, importer.errors[:5] if importer.errors else ['文件中没有有效的题目数据']
        valid_count = sum(1 for q in questions_data if q.get('correct_answer') and q.get('score'))
        missing_count = len(questions_data) - valid_count
        total_score = sum(q['score'] if isinstance(q['score'], int) else 0 for q in questions_data)
        return questions_data, {
            'total_score': total_score,
            'valid_count': valid_count,
            'missing_count': missing_count,
            'errors': importer.errors[:10]
        }, None
    except InvalidFileException:
        return None, None, ['文件格式不正确，请上传 .xlsx 格式的 Excel 文件']
    except Exception as e:
        return None, None, [f'读取文件失败：{str(e)}']


# ===== 榜单分享图片（服务端 PIL 绘制 + 网站二维码）=====

def share_site_url(request):
    """分享图二维码指向的网站地址：取当前访问域名，兼容 nginx 反向代理"""
    return request.build_absolute_uri('/')


SHARE_IMAGE_WIDTH = 880
_SHARE_PAD = 36
_SHARE_ROW_H = 62
_SHARE_HEADER_H = 142
_SHARE_FOOTER_H = 208

# 中文字体候选（Windows 优先，Linux 兜底），与 quiz/captcha.py 的多路径探测保持一致
_SHARE_FONT_CANDIDATES = (
    ('C:/Windows/Fonts/msyh.ttc', 'C:/Windows/Fonts/msyhbd.ttc'),
    ('C:/Windows/Fonts/simhei.ttf', 'C:/Windows/Fonts/simhei.ttf'),
    ('/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc',
     '/usr/share/fonts/opentype/noto/NotoSansCJK-Bold.ttc'),
    ('/usr/share/fonts/truetype/wqy/wqy-zenhei.ttc',
     '/usr/share/fonts/truetype/wqy/wqy-zenhei.ttc'),
    ('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf',
     '/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf'),
)

_RANK_BADGE_COLORS = {1: ('#ffd76e', '#7a5200'), 2: ('#d9dde6', '#5a6473'), 3: ('#f0c39a', '#7a4b17')}


@lru_cache(maxsize=64)
def _share_font(size, bold=False):
    """加载分享图字体（带缓存，找不到任何中文字体时退回 Pillow 默认字体）"""
    from PIL import ImageFont
    for regular, bold_path in _SHARE_FONT_CANDIDATES:
        try:
            return ImageFont.truetype(bold_path if bold else regular, size)
        except (IOError, OSError):
            continue
    return ImageFont.load_default()


def _gradient_color(ratio):
    """标题区渐变色：紫 #6a11cb → 蓝 #2575fc"""
    start, end = (0x6a, 0x11, 0xcb), (0x25, 0x75, 0xfc)
    ratio = min(max(ratio, 0.0), 1.0)
    return tuple(int(s + (e - s) * ratio) for s, e in zip(start, end))


def _make_qr_image(url, box_size=6, border=1):
    """生成网站二维码（依赖 qrcode 库）"""
    import qrcode
    qr = qrcode.QRCode(error_correction=qrcode.constants.ERROR_CORRECT_M,
                       box_size=box_size, border=border)
    qr.add_data(url)
    qr.make(fit=True)
    return qr.make_image(fill_color='#1a1a1a', back_color='#ffffff').convert('RGB')


def _draw_share_row(draw, top, row):
    """绘制一行榜单：名次徽章 + 姓名/副信息 + 主数值"""
    center_y = top + _SHARE_ROW_H / 2
    badge_x = _SHARE_PAD + 18
    badge_fill, badge_text = _RANK_BADGE_COLORS.get(row.get('rank'), ('#eef0f6', '#666666'))
    draw.ellipse([badge_x - 17, center_y - 17, badge_x + 17, center_y + 17], fill=badge_fill)
    draw.text((badge_x, center_y), str(row.get('rank') or '—'),
              font=_share_font(16, bold=True), fill=badge_text, anchor='mm')

    text_x = _SHARE_PAD + 52
    # 名字/副信息右侧需给主数值留出空间，超长时截断，避免与数值重叠
    name_width = SHARE_IMAGE_WIDTH - text_x - _SHARE_PAD - 180
    name_font = _share_font(20, bold=True)
    draw.text((text_x, center_y - 15),
              _fit_text(draw, row.get('name') or '匿名用户', name_font, name_width),
              font=name_font, fill='#2c3e50', anchor='lm')
    if row.get('sub'):
        sub_font = _share_font(13)
        draw.text((text_x, center_y + 16), _fit_text(draw, row['sub'], sub_font, name_width),
                  font=sub_font, fill='#95a5a6', anchor='lm')
    draw.text((SHARE_IMAGE_WIDTH - _SHARE_PAD, center_y), str(row.get('value') or ''),
              font=_share_font(22, bold=True), fill='#6a11cb', anchor='rm')
    draw.line([(_SHARE_PAD, top + _SHARE_ROW_H), (SHARE_IMAGE_WIDTH - _SHARE_PAD, top + _SHARE_ROW_H)],
              fill='#f0f2f6')


def _draw_share_footer(draw, image, top, site_url):
    """绘制底部二维码区"""
    draw.line([(_SHARE_PAD, top), (SHARE_IMAGE_WIDTH - _SHARE_PAD, top)], fill='#e6e8ee')
    qr_size, qr_left, qr_top = 132, _SHARE_PAD, top + 38
    try:
        qr_image = _make_qr_image(site_url)
        image.paste(qr_image.resize((qr_size, qr_size)), (qr_left, qr_top))
    except Exception:
        logger.exception('榜单分享图二维码生成失败：%s', site_url)
        draw.rectangle([qr_left, qr_top, qr_left + qr_size, qr_top + qr_size], outline='#e6e8ee')
        draw.text((qr_left + qr_size / 2, qr_top + qr_size / 2), '二维码不可用',
                  font=_share_font(13), fill='#b6bcc8', anchor='mm')

    text_x = qr_left + qr_size + 28
    draw.text((text_x, qr_top + 22), '扫码进入 来斩题',
              font=_share_font(22, bold=True), fill='#2c3e50', anchor='lm')
    draw.text((text_x, qr_top + 58), '和同学一起 PK 榜单',
              font=_share_font(15), fill='#7f8c8d', anchor='lm')
    draw.text((text_x, qr_top + 88), site_url,
              font=_share_font(13), fill='#b6bcc8', anchor='lm')


def _fit_text(draw, text, font, max_width):
    """按像素宽度截断文本，避免过长的榜单标题溢出画布"""
    text = str(text or '')
    if draw.textlength(text, font=font) <= max_width:
        return text
    while text and draw.textlength(text + '…', font=font) > max_width:
        text = text[:-1]
    return text + '…'


def render_leaderboard_share_image(title, subtitle, rows, site_url):
    """把榜单渲染成一张带网站二维码的 PNG，返回 BytesIO。

    rows: [{'rank': 1, 'name': '张三', 'sub': '初二3班', 'value': '128 题'}, ...]
    """
    from PIL import Image, ImageDraw

    row_count = max(len(rows), 1)
    height = _SHARE_HEADER_H + row_count * _SHARE_ROW_H + _SHARE_FOOTER_H
    image = Image.new('RGB', (SHARE_IMAGE_WIDTH, height), '#ffffff')
    draw = ImageDraw.Draw(image)

    for offset in range(_SHARE_HEADER_H):
        draw.line([(0, offset), (SHARE_IMAGE_WIDTH, offset)],
                  fill=_gradient_color(offset / _SHARE_HEADER_H))
    max_text_width = SHARE_IMAGE_WIDTH - _SHARE_PAD * 2
    draw.text((_SHARE_PAD, 36), _fit_text(draw, title, _share_font(34, bold=True), max_text_width),
              font=_share_font(34, bold=True), fill='#ffffff')
    draw.text((_SHARE_PAD, 92), _fit_text(draw, subtitle, _share_font(16), max_text_width),
              font=_share_font(16), fill='#e8e2ff')

    top = _SHARE_HEADER_H
    if not rows:
        draw.text((SHARE_IMAGE_WIDTH / 2, top + _SHARE_ROW_H / 2), '暂无上榜数据',
                  font=_share_font(18), fill='#b6bcc8', anchor='mm')
    for row in rows:
        _draw_share_row(draw, top, row)
        top += _SHARE_ROW_H

    _draw_share_footer(draw, image, top, site_url)
    buffer = io.BytesIO()
    image.save(buffer, format='PNG')
    buffer.seek(0)
    return buffer


def leaderboard_share_response(buffer, filename='leaderboard.png'):
    """榜单分享图响应：inline 便于浏览器直接展示 / 长按保存"""
    response = HttpResponse(buffer.getvalue(), content_type='image/png')
    response['Content-Disposition'] = f'inline; filename={filename}'
    response['Cache-Control'] = 'no-store'
    return response


# ===== Excel 导出 =====

def xlsx_download_response(workbook, filename):
    """Excel 下载响应：按 RFC 5987 编码中文文件名，兼容各浏览器"""
    from urllib.parse import quote
    response = HttpResponse(
        content_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
    quoted = quote(filename)
    response['Content-Disposition'] = (
        f"attachment; filename={quoted}; filename*=UTF-8''{quoted}")
    workbook.save(response)
    return response


def make_excel_sheet(ws, headers, rows, widths=None, freeze_panes='A2'):
    """统一风格的 Excel 工作表填充：表头样式 + 全表边框 + 冻结首行"""
    header_font = Font(bold=True, color='FFFFFF', size=11)
    header_fill = PatternFill(start_color='667EEA', end_color='764BA2', fill_type='solid')
    thin = Border(left=Side(style='thin'), right=Side(style='thin'),
                  top=Side(style='thin'), bottom=Side(style='thin'))
    for col_idx, header in enumerate(headers, start=1):
        cell = ws.cell(row=1, column=col_idx, value=header)
        cell.font = header_font
        cell.fill = header_fill
        cell.alignment = Alignment(horizontal='center', vertical='center', wrap_text=True)
        cell.border = thin
    for row_idx, row in enumerate(rows, start=2):
        for col_idx, value in enumerate(row, start=1):
            cell = ws.cell(row=row_idx, column=col_idx, value=value)
            cell.alignment = Alignment(vertical='center', wrap_text=True)
            cell.border = thin
    for col_idx, width in enumerate(widths or []):
        ws.column_dimensions[get_column_letter(col_idx + 1)].width = width
    if freeze_panes:
        ws.freeze_panes = freeze_panes
