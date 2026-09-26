"""need_to_do URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include, re_path
from django.views.generic import RedirectView
from django.conf import settings
from django.views.static import serve as static_serve
from django.shortcuts import redirect

def favicon_view(request):
    """返回站点图标（指向静态目录中的 LOGO）"""
    return redirect(settings.STATIC_URL + 'quiz/images/logo-icon.png')

urlpatterns = [
    path('admin/', admin.site.urls),
    path('quiz/membership/', include('membership.urls')),
    path('quiz/star/', include('starcoin.urls')),
    path('quiz/', include('quiz.urls')),
    path('', RedirectView.as_view(url='/quiz/test_paper_list/')),
    path('favicon.ico', favicon_view),
]

# 静态文件兜底服务：仅开发模式（DEBUG=True）生效。
# 生产环境由 nginx 直接接管 /static/（见 nginx 配置），Django 只处理动态请求，
# 避免生产流量走 django.views.static（无缓存协商、占用 waitress 工作线程）。
if settings.DEBUG:
    urlpatterns += [
        re_path(r'^static/(?P<path>.*)$', static_serve, {'document_root': settings.STATIC_ROOT}),
    ]
