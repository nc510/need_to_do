# ==============================================================================
# 验证码生成工具
# ==============================================================================

import random
import string
from PIL import Image, ImageDraw, ImageFont
import io

# 验证码字符集
CHAR_SET = string.ascii_letters + string.digits

# 验证码配置
CAPTCHA_WIDTH = 120
CAPTCHA_HEIGHT = 40
CAPTCHA_LENGTH = 4
CAPTCHA_FONT_SIZE = 28


def generate_captcha_text(length=CAPTCHA_LENGTH):
    """生成随机验证码文本"""
    return ''.join(random.sample(CHAR_SET, length))


def generate_captcha_image(text):
    """生成验证码图片"""
    # 创建图片对象
    image = Image.new('RGB', (CAPTCHA_WIDTH, CAPTCHA_HEIGHT), (255, 255, 255))
    draw = ImageDraw.Draw(image)
    
    # P2-10：字体查找改为多路径尝试，兼容 Windows arial.ttf 与 Linux DejaVu
    # Linux 服务器无 arial.ttf，原代码总是 fallback 到 load_default()，验证码难看
    font = None
    for fp in ('arial.ttf', 'DejaVuSans.ttf',
               '/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf',
               '/usr/share/fonts/dejavu/DejaVuSans.ttf'):
        try:
            font = ImageFont.truetype(fp, CAPTCHA_FONT_SIZE)
            break
        except (IOError, OSError):
            continue
    if font is None:
        font = ImageFont.load_default()
    
    # 绘制验证码字符
    char_width = CAPTCHA_WIDTH // len(text)
    for i, char in enumerate(text):
        x = i * char_width + random.randint(2, 6)
        y = random.randint(2, CAPTCHA_HEIGHT - CAPTCHA_FONT_SIZE - 2)
        color = (
            random.randint(30, 100),
            random.randint(30, 100),
            random.randint(30, 100)
        )
        draw.text((x, y), char, font=font, fill=color)
    
    # 添加干扰线
    for _ in range(random.randint(3, 5)):
        start_x = random.randint(0, CAPTCHA_WIDTH - 1)
        start_y = random.randint(0, CAPTCHA_HEIGHT - 1)
        end_x = random.randint(0, CAPTCHA_WIDTH - 1)
        end_y = random.randint(0, CAPTCHA_HEIGHT - 1)
        color = (
            random.randint(100, 200),
            random.randint(100, 200),
            random.randint(100, 200)
        )
        draw.line((start_x, start_y, end_x, end_y), fill=color, width=1)
    
    # 添加干扰点
    for _ in range(random.randint(20, 40)):
        x = random.randint(0, CAPTCHA_WIDTH - 1)
        y = random.randint(0, CAPTCHA_HEIGHT - 1)
        color = (
            random.randint(150, 255),
            random.randint(150, 255),
            random.randint(150, 255)
        )
        draw.point((x, y), fill=color)
    
    # 添加噪点背景
    for _ in range(random.randint(50, 100)):
        x = random.randint(0, CAPTCHA_WIDTH - 1)
        y = random.randint(0, CAPTCHA_HEIGHT - 1)
        image.putpixel((x, y), (
            random.randint(200, 255),
            random.randint(200, 255),
            random.randint(200, 255)
        ))
    
    # 保存到内存
    buffer = io.BytesIO()
    image.save(buffer, format='PNG')
    buffer.seek(0)
    
    return buffer