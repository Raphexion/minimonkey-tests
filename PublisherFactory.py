from Publisher import Publisher


def get_publisher():
    return Publisher()


def stop_publisher(publisher):
    publisher.stop()


def start_publisher(publisher):
    publisher.start()


def set_publisher_host(publisher, host):
    publisher.host = host


def set_publisher_token(publisher, token):
    publisher.token = token


def set_publisher_room(publisher, room):
    publisher.room = room


def publish_message(publisher, msg):
    publisher.publish(msg)
