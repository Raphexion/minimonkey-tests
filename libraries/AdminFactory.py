from Admin import Admin


def get_admin():
    return Admin()


def stop_admin(admin):
    admin.stop()


def start_admin(admin):
    admin.start()


def set_admin_host(admin, host):
    admin.host = host


def set_admin_token(admin, token):
    admin.token = token


def set_admin_room(admin, room):
    admin.room = room


def link_room(admin, room):
    admin.link_room(room)


def last_admin_error(admin):
    return admin.last_error
