from django.urls import path

from . import views

app_name = 'starcoin'

urlpatterns = [
    path('', views.center, name='center'),
    path('tasks/', views.tasks, name='tasks'),
    path('leaderboard/', views.leaderboard, name='leaderboard'),
    path('leaderboard/share/', views.leaderboard_share, name='leaderboard_share'),
    path('mall/', views.mall, name='mall'),
    path('mall/redeem/<int:item_id>/', views.redeem, name='redeem'),
    path('items/<int:item_id>/use/', views.use_item, name='use_item'),
    path('items/hint/', views.use_hint_card, name='use_hint_card'),
    path('recharge/', views.recharge, name='recharge'),
    path('recharge/card/redeem/', views.redeem_card, name='redeem_card'),
    path('recharge/buy/<int:package_id>/', views.buy, name='buy'),
    path('pay/<str:order_no>/', views.pay, name='pay'),
    path('alipay/return/', views.alipay_return, name='alipay_return'),
    path('alipay/notify/', views.alipay_notify, name='alipay_notify'),
    path('records/', views.records, name='records'),
]
