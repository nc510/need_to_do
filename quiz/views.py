# ============================================================
# quiz/views 聚合入口（P2-1 拆分后保留）
# 原 2700 行 views.py 按功能拆分为：
#   views_common / views_paper / views_auth / views_user /
#   views_class / views_admin
# 此处仅聚合导出，urls.py 的 from . import views 保持不变。
# ============================================================
from .views_common import *  # noqa: F401,F403
from .views_paper import *   # noqa: F401,F403
from .views_auth import *    # noqa: F401,F403
from .views_user import *    # noqa: F401,F403
from .views_class import *   # noqa: F401,F403
from .views_admin import *   # noqa: F401,F403
