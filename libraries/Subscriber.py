from MiniMonkey import MiniMonkey
from robot.api import logger
import time


class Subscriber:
    def __init__(self, host='localhost', token='', room='', tag=''):
        self.minimonkey = MiniMonkey(host)
        self.token = token
        self.room = room
        self.tag = tag
        self.stop_thread = False
        self.last_error = ''

    def _recv(self, seconds=5):
        code, payload = None, None
        for _ in range(seconds*10):
            time.sleep(0.1)
            code, payload = self.minimonkey.recv()

            if code:
                break

        return code, payload

    def recv(self):
        _code1, _tag = self._recv()
        _code2, msg = self._recv()

        return msg

    def log(self, msg):
        logger.error(msg)
        self.last_error = msg

    def stop(self):
        self.minimonkey.stop()

    def start(self):
        logger.debug('subscriber started')
        self.minimonkey.start()

        # Authenticate
        self.minimonkey.auth(self.token)
        code, data = self._recv()
        if not data == b'login successful':
            self.log(data)
            self.log('failed to log in (subscriber)')
            return

        # Enter Room
        self.minimonkey.enter(self.room)
        code, data = self._recv()
        if not data == b'enter successful':
            self.log(data)
            self.log('failed to enter room (subscriber)')
            return

        # Subscribe to messages
        self.minimonkey.subscribe(self.tag)
        code, data = self._recv()
        if not data == b'subscribe successful':
            self.log(data)
            self.log('failed to subscribe')
            return
