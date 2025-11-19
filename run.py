from waitress import serve
from need_to_do.wsgi import application

if __name__ == '__main__':
    serve(app=application, host='192.168.1.188', port=8090)