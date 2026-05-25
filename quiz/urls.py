from django.urls import path
from . import views

urlpatterns = [
    # 后台管理功能
    path('admin/import_questions/', views.admin_import_questions, name='admin_import_questions'),  # 后台导入试题
    path('admin/import_questions/template/', views.admin_export_template, name='admin_export_template'),  # 后台下载模板
    path('admin/create_testpaper/', views.admin_create_testpaper, name='admin_create_testpaper'),  # 后台组卷
    path('admin/import_testpaper/', views.admin_import_testpaper, name='admin_import_testpaper'),  # 后台导入试卷
    path('admin/preview_testpaper/<int:paper_id>/', views.admin_preview_testpaper, name='admin_preview_testpaper'),  # 后台试卷预览
    
    path('test_paper_list/', views.test_paper_list, name='test_paper_list'),  # 试卷列表
    
    path('question/<int:question_id>/', views.question_detail, name='question_detail'),
    path('paper/<int:paper_id>/', views.test_paper_detail, name='test_paper_detail'),  # 试卷详情
    path('paper/<int:paper_id>/submit/', views.submit_test_paper, name='submit_test_paper'),  # 试卷提交
    
    path('register/', views.register, name='register'),  # 注册
    path('login/', views.login_view, name='login'),  # 登录
    path('logout/', views.logout_view, name='logout'),  # 退出登录
    path('test_history/', views.test_history, name='test_history'),  # 答题历史
    path('test_history/<int:record_id>/', views.test_history_detail, name='test_history_detail'),  # 答题历史详情
    path('user_center/', views.user_center, name='user_center'),  # 用户中心
    path('wrong_question_notebook/', views.wrong_question_notebook, name='wrong_question_notebook'),  # 错题本
    path('create_wrong_question_paper/', views.create_wrong_question_paper, name='create_wrong_question_paper'),  # 错题本组卷
    path('submit_wrong_question_paper/', views.submit_wrong_question_paper, name='submit_wrong_question_paper'),  # 错题本试卷提交
    path('delete_wrong_question/<int:wrong_question_id>/', views.delete_wrong_question, name='delete_wrong_question'),  # 删除错题
    path('my_test_papers/', views.my_test_papers, name='my_test_papers'),  # 我的试卷
    path('my_test_papers/create/', views.create_test_paper, name='create_test_paper'),  # 创建试卷
    path('my_test_papers/import/', views.import_test_paper, name='import_test_paper'),  # 导入试卷
    path('my_test_papers/import/template/', views.download_import_template, name='download_import_template'),  # 下载导入模板
    path('my_test_papers/<int:paper_id>/publish/', views.publish_test_paper, name='publish_test_paper'),  # 发布试卷
    path('my_test_papers/<int:paper_id>/delete/', views.delete_test_paper, name='delete_test_paper'),  # 删除试卷
    
    # 班级管理
    path('class_list/', views.class_list, name='class_list'),  # 班级列表
    path('class/<int:class_id>/', views.class_detail, name='class_detail'),  # 班级详情
    path('class/create/', views.create_class, name='create_class'),  # 创建班级
    path('class/<int:class_id>/edit/', views.edit_class, name='edit_class'),  # 编辑班级
    path('class/<int:class_id>/delete/', views.delete_class, name='delete_class'),  # 删除班级
    path('class/<int:class_id>/add_admin/', views.add_class_admin, name='add_class_admin'),  # 添加班级管理员
    path('class/<int:class_id>/remove_admin/<int:admin_id>/', views.remove_class_admin, name='remove_class_admin'),  # 移除班级管理员
    path('class/<int:class_id>/assign_student/', views.assign_student_to_class, name='assign_student'),  # 分配学生
    path('class/<int:class_id>/remove_student/<int:user_id>/', views.remove_student_from_class, name='remove_student'),  # 移除学生
    
    # 班级申请
    path('apply_to_class/', views.apply_to_class, name='apply_to_class'),  # 申请加入班级
    path('my_applications/', views.my_applications, name='my_applications'),  # 我的申请记录
    path('class/<int:class_id>/applications/', views.class_applications, name='class_applications'),  # 班级申请列表
    path('class/<int:class_id>/approve/<int:application_id>/', views.approve_application, name='approve_application'),  # 审核通过
    path('class/<int:class_id>/reject/<int:application_id>/', views.reject_application, name='reject_application'),  # 审核拒绝
    
    # 班级作业/考试
    path('class/<int:class_id>/assignments/', views.class_assignments, name='class_assignments'),  # 班级作业列表
    path('class/<int:class_id>/assignments/create/', views.create_class_assignment, name='create_class_assignment'),  # 创建班级作业
    path('class/<int:class_id>/assignments/<int:assignment_id>/', views.class_assignment_detail, name='class_assignment_detail'),  # 作业详情
    path('class/<int:class_id>/assignments/<int:assignment_id>/publish/', views.publish_class_assignment, name='publish_class_assignment'),  # 发布作业
    path('student/assignments/', views.student_class_assignments, name='student_class_assignments'),  # 学生作业列表
    path('student/assignments/<int:assignment_id>/', views.do_class_assignment, name='do_class_assignment'),  # 完成作业
    path('student/assignments/<int:assignment_id>/submit/', views.submit_class_assignment, name='submit_class_assignment'),  # 提交作业
]