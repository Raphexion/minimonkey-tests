from MiniMonkey import MiniMonkey
from robot.api import logger
import time


class Publisher:
    def __init__(self, host='localhost', token='', room=''):
        self.minimonkey = MiniMonkey(host)
        self.token = token
        self.room = room

    def publish(self, msg):
        self.minimonkey.publish(msg)

    def log(self, msg):
        logger.error(msg)
        self.last_error = msg

    def recv(self, seconds=5):
        code, payload = None, None
        for _ in range(seconds*10):
            time.sleep(0.1)
            code, payload = self.minimonkey.recv()

            if code:
                break

        return code, payload

    def stop(self):
        self.minimonkey.stop()

    def start(self):
        logger.debug('publisher started')
        self.minimonkey.start()

        # Authenticate
        self.minimonkey.auth(self.token)
        code, data = self.recv()
        if not data == b'logged in':
            self.log('failed to log in')
            return

        # Enter Room
        self.minimonkey.enter(self.room)
        code, data = self.recv()
        if not data == b'ok':
            self.log('failed to enter room')
            return
