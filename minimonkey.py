import struct
from robot.api import logger


protocol = '<BH'
max_size = 3 + 2**16

ERROR = 0
AUTH = 1
ENTER = 2
PUBLISH = 3
SUBSCRIBE = 4


def send_data(sock, code, data):
    header = struct.pack(protocol, code, len(data))
    sock.send(header)
    sock.send(data.encode())


def recv_data(sock, data_old=b''):
    data_new = sock.recv(max_size)
    data = data_old + data_new

    header = data[0:3]
    payload = data[3:]
    (code, size) = struct.unpack(protocol, header)

    if size > len(payload):
        return recv_data(sock, data)

    return code, payload[0:size], payload[size:]
