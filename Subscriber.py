from minimonkey import (send_data,
                        recv_data,
                        AUTH,
                        ENTER,
                        SUBSCRIBE)
from robot.api import logger
from threading import Thread, Lock
import socket
import time
from queue import Queue


class Subscriber(Thread):
    def __init__(self, host='localhost', token='', room='', tag=''):
        Thread.__init__(self)
        self.host = host
        self.token = token
        self.room = room
        self.tag = tag
        self.stop_thread = False
        self.messages = Queue()
        self.mutex = Lock()
        self.last_error = ''

    def pop(self, seconds=10):
        res = None

        for _ in range(seconds):
            time.sleep(1)
            seconds -= 1
            self.mutex.acquire()
            try:
                if not self.messages.empty():
                    res = self.messages.get()
                    break
                else:
                    pass
            finally:
                self.mutex.release()

        return res

    def log(self, msg):
        logger.error(msg)
        self.last_error = msg

    def stop(self):
        self.stop_thread = True

    def run(self):
        logger.warn('subscriber started')
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

        send_data(sock, SUBSCRIBE, self.tag)
        code, data = recv_data(sock)

        if not data == b'ok':
            self.log('failed to subscribe')
            return

        while not self.stop_thread:
            try:
                (enter, tag) = recv_data(sock)
                (publish, data) = recv_data(sock)

                self.mutex.acquire()
                try:
                    self.messages.put(data.decode())
                finally:
                    self.mutex.release()
            except socket.timeout:
                pass

            finally:
                pass
