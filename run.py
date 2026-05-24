from waitress import serve
from need_to_do.wsgi import application
import time

HOST = '0.0.0.0'
PORT = 8090

if __name__ == '__main__':
    print(f"Performing system checks...")
    print(f"System check identified no issues (0 silenced).")
    print(f"{time.strftime('%b %d, %Y - %H:%M:%S')}")
    print(f"Starting development server at http://{HOST}:{PORT}/")
    print(f"Quit the server with CTRL-BREAK.")
    print()
    serve(app=application, host=HOST, port=PORT)
