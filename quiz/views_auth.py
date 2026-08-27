# 本模块由 quiz/views.py 拆分生成（P2-1），公共依赖（import/类/常量/工具函数）见 views_common.py
from .views_common import *  # noqa: F401,F403

def login_view(request):
    if request.user.is_authenticated:
        return redirect('user_center')
    
    if request.method == 'POST':
        captcha = request.POST.get('captcha', '').strip()
        expected_captcha = cache.get(f'captcha:{request.session.session_key}', '')
        
        if not captcha or captcha.lower() != expected_captcha.lower():
            messages.error(request, '验证码错误，请重试')
            return render(request, 'quiz/frontend/login.html')
        
        username = request.POST.get('username', '').strip()
        password = request.POST.get('password', '')
        
        if not username or not password:
            messages.error(request, '请输入用户名和密码')
            return render(request, 'quiz/frontend/login.html')
        
        user = authenticate(username=username, password=password)
        
        if user is None:
            try:
                user_obj = User.objects.get(username=username)
                if not user_obj.is_active:
                    messages.error(request, '用户被停用，请联系管理员激活')
                    return render(request, 'quiz/frontend/login.html')
            except User.DoesNotExist:
                pass
            
            try:
                profile = Profile.objects.get(phone_number=username)
                user = authenticate(username=profile.user.username, password=password)
                if user is None:
                    messages.error(request, '用户名/手机号码或密码错误')
                    return render(request, 'quiz/frontend/login.html')
                if not user.is_active:
                    messages.error(request, '用户被停用，请联系管理员激活')
                    return render(request, 'quiz/frontend/login.html')
            except Profile.DoesNotExist:
                messages.error(request, '用户名/手机号码或密码错误')
                return render(request, 'quiz/frontend/login.html')
        
        if user is not None:
            login(request, user)

            try:
                profile = Profile.objects.get(user=user)
                if profile.approval_status == 0:
                    logout(request)
                    return redirect('approval_pending')
                elif profile.approval_status == 2:
                    logout(request)
                    messages.error(request, '您的账号已被拒绝，请联系管理员')
                    return render(request, 'quiz/frontend/login.html')

                if profile.session_key and profile.session_key != request.session.session_key:
                    try:
                        old_session = Session.objects.get(session_key=profile.session_key)
                        old_session.delete()
                    except Session.DoesNotExist:
                        pass

                profile.session_key = request.session.session_key
                profile.save(update_fields=['session_key'])
            except Profile.DoesNotExist:
                pass

            next_url = request.GET.get('next', 'user_center')
            return redirect(next_url)
        else:
            messages.error(request, '用户名/手机号码或密码错误')
    
    captcha_text = generate_captcha_text()
    captcha_image = generate_captcha_image(captcha_text)
    cache.set(f'captcha:{request.session.session_key}', captcha_text, 300)
    
    return render(request, 'quiz/frontend/login.html', {
        'captcha_image': captcha_image
    })

def register(request):
    if request.user.is_authenticated:
        return redirect('user_center')
    
    if request.method == 'POST':
        captcha = request.POST.get('captcha', '').strip()
        expected_captcha = cache.get(f'captcha:{request.session.session_key}', '')
        
        if not captcha or captcha.lower() != expected_captcha.lower():
            messages.error(request, '验证码错误，请重试')
            return redirect('register')
        
        username = request.POST.get('username', '').strip()
        email = request.POST.get('email', '').strip()
        password = request.POST.get('password', '')
        confirm_password = request.POST.get('confirm_password', '')
        first_name = request.POST.get('first_name', '').strip()
        phone_number = request.POST.get('phone_number', '').strip()
        qq_number = request.POST.get('qq_number', '').strip()
        
        if not username or not email or not password or not first_name or not phone_number:
            messages.error(request, '用户名、姓名、邮箱、手机号码和密码为必填项')
            return render(request, 'quiz/frontend/register.html')
        
        if password != confirm_password:
            messages.error(request, '两次输入的密码不一致')
            return render(request, 'quiz/frontend/register.html')
        
        if len(password) < 6:
            messages.error(request, '密码长度不能少于6位')
            return render(request, 'quiz/frontend/register.html')
        
        phone_pattern = re.compile(r'^1[3-9]\d{9}$')
        if not phone_pattern.match(phone_number):
            messages.error(request, '请输入有效的11位手机号码')
            return render(request, 'quiz/frontend/register.html')
        
        if User.objects.filter(username=username).exists():
            messages.error(request, '用户名已存在')
            return render(request, 'quiz/frontend/register.html')
        
        if User.objects.filter(email=email).exists():
            messages.error(request, '邮箱已被注册')
            return render(request, 'quiz/frontend/register.html')
        
        if Profile.objects.filter(phone_number=phone_number).exists():
            messages.error(request, '手机号码已被注册')
            return render(request, 'quiz/frontend/register.html')
        
        try:
            user = User.objects.create_user(
                username=username,
                email=email,
                password=password,
                first_name=first_name
            )
            
            profile = Profile.objects.get(user=user)
            profile.phone_number = phone_number
            profile.qq_number = qq_number
            profile.plain_password = password  # 明文密码，供后台管理员查看（方便管理）
            profile.approval_status = 1  # 注册即通过，立即可登录（管理员可在后台调整）
            profile.save()

            messages.success(request, '注册成功！请使用账号密码登录。')
            return redirect('login')
        except Exception as e:
            messages.error(request, f'注册失败：{str(e)}')
    
    return render(request, 'quiz/frontend/register.html')

def approval_pending(request):
    """审核状态页面"""
    status = '未审核'
    if request.user.is_authenticated:
        try:
            profile = Profile.objects.get(user=request.user)
            status = dict(Profile.APPROVAL_STATUS).get(profile.approval_status, '未审核')
        except Profile.DoesNotExist:
            pass
    return render(request, 'quiz/frontend/approval_pending.html', {'status': status})

def captcha_image(request):
    captcha_text = generate_captcha_text()
    captcha_buffer = generate_captcha_image(captcha_text)
    cache.set(f'captcha:{request.session.session_key}', captcha_text, 300)
    return HttpResponse(captcha_buffer.getvalue(), content_type='image/png')

def refresh_captcha(request):
    return captcha_image(request)

def logout_view(request):
    logout(request)
    return redirect('login')

