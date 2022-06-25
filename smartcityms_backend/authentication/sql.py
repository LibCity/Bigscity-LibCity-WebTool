from django.db import connection


def query_permission(account_id):
    """
    根据账户id查询账户拥有的权限

    :param account_id: 账户id
    :return: 账户拥有的权限code列表
    """
    query_sql = '''
                SELECT tp.code
                FROM tb_account a
                    LEFT JOIN tb_account_roles tar ON a.id = tar.account_id
                    LEFT JOIN tb_role_permissions trp ON tar.role_id = trp.role_id
                    LEFT JOIN tb_permission tp ON trp.permission_id = tp.id
                WHERE a.id = %s
                '''
    with connection.cursor() as cursor:
        cursor.execute(query_sql, [account_id])
        rows = cursor.fetchall()
    result_set = set()
    if len(rows) == 1 and rows[0][0] is None:
        return []
    for row in rows:
        result_set.add(row[0])
    return list(result_set)
