
def get_tree(permissions, parent_id=None):
    """
    通过权限列表解析为权限树形结构

    :param permissions: 权限列表数据
    :param parent_id: 父id
    :return: [ {id, label, children[{id, label} ]} ]
    """
    tree_list = []
    for permission in permissions:
        if parent_id == permission['parent_id']:
            perm = {'id': permission['id'], 'label': permission['name'], 'code': permission['code'],
                    'children': get_tree(permissions, permission['id'])}
            tree_list.append(perm)
    return tree_list
