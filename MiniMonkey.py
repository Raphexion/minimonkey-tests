import struct
from threading import Thread, Lock
from queue import Queue
import socket


protocol = '<BH'
max_size = 3 + 2**16

ERROR = 0
AUTH = 1
ENTER = 2
PUBLISH = 3
SUBSCRIBE = 4

ADD_ADMIN = 10
REVOKE_ADMIN = 11
ADD_PUBLISH = 12
REVOKE_PUBLISH = 13
ADD_SUBSCRIBE = 14
REVOKE_SUBSCRIBE = 15


class MiniMonkey(Thread):
    def __init__(self, host='localhost'):
        Thread.__init__(self)
        self.host = host
        self.sock = None
        self.inbuffer = b''
        self.incoming = Queue()
        self.outgoing = Queue()
        self.in_mutex = Lock()
        self.out_mutex = Lock()
        self.should_run = True

    def auth(self, token):
        self.send(AUTH, token)

    def enter(self, room):
        self.send(ENTER, room)

    def publish(self, payload):
        self.send(PUBLISH, payload)

    def subscribe(self, tag):
        self.send(SUBSCRIBE, tag)

    def add_admin(self, token):
        self.send(ADD_ADMIN, tag)

    def revoke_admin(self, token):
        self.send(REVOKE_ADMIN, tag)

    def add_publish(self, token):
        self.send(ADD_PUBLISH, tag)

    def revoke_publish(self, token):
        self.send(REVOKE_PUBLISH, tag)

    def add_subscribe(self, token):
        self.send(ADD_SUBSCRIBE, tag)

    def revoke_subscribe(self, token):
        self.send(REVOKE_SUBSCRIBE, tag)

    def send(self, code, payload):
        self.out_mutex.acquire()
        try:
            self.outgoing.put((code, payload))
        finally:
            self.out_mutex.release()

    def recv(self):
        code = None
        payload = None

        self.in_mutex.acquire()
        try:
            if not self.incoming.empty():
                code, payload = self.incoming.get()
        finally:
            self.in_mutex.release()

        return code, payload

    def _send(self):
        self.out_mutex.acquire()
        try:
            if self.outgoing.empty():
                pass
            else:
                code, payload = self.outgoing.get()
                header = struct.pack(protocol, code, len(payload))
                self.sock.send(header)
                self.sock.send(payload.encode())
        finally:
            self.out_mutex.release()

    def _recv(self):
        try:
            new_data = self.sock.recv(max_size)
        except socket.timeout:
            new_data = b''

        self.inbuffer += new_data

        if len(self.inbuffer) < 3:
            return

        header = self.inbuffer[0:3]
        payload = self.inbuffer[3:]
        (code, size) = struct.unpack(protocol, header)

        if size <= len(payload):
            self.in_mutex.acquire()
            try:
                self.incoming.put((code, payload[0:size]))
                self.inbuffer = payload[size:]
            finally:
                self.in_mutex.release()

    def stop(self):
        self.should_run = False

    def run(self):
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.sock.connect((self.host, 1773))
        self.sock.settimeout(0.01)

        while self.should_run:
            self._send()
            self._recv()
