from minimonkey import (send_data,
                        recv_data,
                        AUTH,
                        ENTER,
                        PUBLISH)
from robot.api import logger
from threading import Thread, Lock
import socket
import time
from queue import Queue


class Publisher(Thread):
    def __init__(self, host='localhost', token='', room=''):
        Thread.__init__(self)
        self.host = host
        self.token = token
        self.room = room
        self.stop_thread = False
        self.messages = []
        self.mutex = Lock()
        self.last_error = ''
        self.messages = Queue()

    def set_host(self, host):
        self.host = host

    def set_token(self, token):
        self.token = token

    def set_room(self, room):
        self.room = room

    def publish(self, msg):
        self.mutex.acquire()
        try:
            self.messages.put((PUBLISH, msg))
        finally:
            self.mutex.release()

    def log(self, msg):
        logger.error(msg)
        self.last_error = msg

    def stop(self):
        self.stop_thread = True

    def run(self):
        logger.warn('publisher started')
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.connect((self.host, 1773))
        sock.settimeout(1)

        send_data(sock, AUTH, self.token)
        code, data = recv_data(sock)

        if not data == b'logged in':
            self.log('failed to log in')
            return

        send_data(sock, ENTER, self.room)
        code, data = recv_data(sock)

        if not data == b'ok':
            self.log('failed to enter room')
            return

        while not self.stop_thread:
            time.sleep(1)
            self.mutex.acquire()
            try:
                if self.messages.empty():
                    pass
                else:
                    code, payload = self.messages.get()
                    logger.warn("publish {}".format(payload))
                    send_data(sock, code, payload)
                    recv_data(sock)

            finally:
                self.mutex.release()
