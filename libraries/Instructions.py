from Admin import Admin
from Publisher import Publisher
from Subscriber import Subscriber


def link_rooms(src_room, dst_room, token):
    admin = Admin(room=src_room, token=token)
    admin.start()
    admin.link_rooms(src_room, dst_room)
    admin.stop()


def publish(msg, room, token):
    publisher = Publisher(room=room, token=token)
    publisher.start()
    publisher.publish(msg)
    _, data = publisher.recv()
    assert data == b'publish successful'
    publisher.stop()


def subscribe_promise(room, tag, token):
    subscriber = Subscriber(room=room, tag=tag, token=token)
    subscriber.start()
    def promise(stop=True):
        msg = subscriber.recv()
        if stop:
            subscriber.stop()
        return msg
    return promise


def subscribe_get(promise, stop=True):
    return promise(stop)
