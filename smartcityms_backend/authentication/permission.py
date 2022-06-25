from authentication.sql import query_permission


def get_permission_list(account):
    """
    获取指定账号的权限列表

    :param account: 账号account对象
    :return: permission code string list
    """
    perms_list = query_permission(account.id)
    return perms_list
