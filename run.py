from waitress import serve
from need_to_do.wsgi import application

if __name__ == '__main__':
<<<<<<< HEAD
    serve(app=application, host='192.168.1.188', port=8090)
=======
    serve(app=application, host='127.0.0.1', port=8090)
>>>>>>> 4d41d1f72897db4e189e3cbbf9a2f8cfbd2db80f
