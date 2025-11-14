from django.contrib.auth.models import User
user = User.objects.get(username='sky510')  # 获取用户名
user.set_password('123456')  # 设置新密码
user.save()  # 保存修改