from django.urls import path
from . import views

urlpatterns = [
    path('test_paper_list/', views.test_paper_list, name='test_paper_list'),  # 试卷列表
    path('question_list/', views.question_list, name='question_list'),  # 保留题目列表功能
    path('question/<int:question_id>/', views.question_detail, name='question_detail'),
    path('paper/<int:paper_id>/', views.test_paper_detail, name='test_paper_detail'),  # 试卷详情
    path('paper/<int:paper_id>/submit/', views.submit_test_paper, name='submit_test_paper'),  # 试卷提交
    path('import/', views.import_questions, name='import_questions'),
]