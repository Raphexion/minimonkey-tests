from Subscriber import Subscriber


def get_subscriber():
    return Subscriber()


def stop_subscriber(subscriber):
    subscriber.stop()


def start_subscriber(subscriber):
    subscriber.start()


def set_subscriber_host(subscriber, host):
    subscriber.host = host


def set_subscriber_token(subscriber, token):
    subscriber.token = token


def set_subscriber_room(subscriber, room):
    subscriber.room = room


def set_subscriber_tag(subscriber, tag):
    subscriber.tag = tag


def get_subscription_message(subscriber):
    return subscriber.recv()
