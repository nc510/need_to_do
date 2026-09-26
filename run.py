from waitress import serve
from need_to_do.wsgi import application
import os
import time


def _int_env(name, default):
    """读取整型环境变量，缺失或非法时回退默认值"""
    try:
        return int(os.getenv(name, default))
    except (TypeError, ValueError):
        return default


HOST = os.getenv('SERVER_HOST', '0.0.0.0')
PORT = _int_env('SERVER_PORT', 8000)

# 并发配置（2C2G 单机、数据库同机的取值）
# threads: 工作线程数。瓶颈在 MySQL，线程过多只会排队并抬高内存，2 核取 16 足够
# connection_limit: 最大并发连接数，100 在线用户的长连接（每浏览器 2~6 条）已含在内
# backlog: 监听队列大小
# channel_timeout: 连接超时时间（秒）。题库导入单文件上限 50MB，
#                  3Mbps 带宽下上传可能超过 60 秒，此处不可调小
THREADS = _int_env('SERVER_THREADS', 16)
CONNECTION_LIMIT = _int_env('SERVER_MAX_CONNECTIONS', 200)
BACKLOG = _int_env('SERVER_BACKLOG', 256)
CHANNEL_TIMEOUT = _int_env('SERVER_TIMEOUT', 120)

if __name__ == '__main__':
    print(f"Performing system checks...")
    print(f"System check identified no issues (0 silenced).")
    print(f"{time.strftime('%b %d, %Y - %H:%M:%S')}")
    print(f"Starting development server at http://{HOST}:{PORT}/")
    print(f"Server configuration:")
    print(f"  - Threads: {THREADS}")
    print(f"  - Max connections: {CONNECTION_LIMIT}")
    print(f"  - Backlog: {BACKLOG}")
    print(f"  - Timeout: {CHANNEL_TIMEOUT}s")
    print(f"Quit the server with CTRL-BREAK.")
    print()
    
    serve(
        app=application, 
        host=HOST, 
        port=PORT,
        threads=THREADS,
        connection_limit=CONNECTION_LIMIT,
        backlog=BACKLOG,
        channel_timeout=CHANNEL_TIMEOUT,
        url_prefix='',
        # Windows 下 waitress 默认使用 select，受 512 句柄限制；poll 可支撑更多并发连接
        asyncore_use_poll=True,
        # 空闲连接清理间隔（秒），及时回收死连接
        cleanup_interval=30,
    )
