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
    path('quiz/', include('quiz.urls')),
    path('', RedirectView.as_view(url='/quiz/test_paper_list/')),
    path('favicon.ico', favicon_view),
]

# 提供静态文件服务（Whitenoise/runserver/waitress 均适用）
urlpatterns += [
    re_path(r'^static/(?P<path>.*)$', static_serve, {'document_root': settings.STATIC_ROOT}),
]
