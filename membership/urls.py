from django.urls import path

from . import views

app_name = 'membership'

urlpatterns = [
    path('', views.plans, name='plans'),
    path('card/redeem/', views.redeem_card, name='redeem_card'),
    path('buy/<int:plan_id>/', views.buy, name='buy'),
    path('pay/<str:order_no>/', views.pay, name='pay'),
    path('alipay/return/', views.alipay_return, name='alipay_return'),
    path('alipay/notify/', views.alipay_notify, name='alipay_notify'),
]
