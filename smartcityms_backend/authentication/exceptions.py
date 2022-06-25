from rest_framework.exceptions import APIException


class AuthenticationFailed(APIException):
    status_code = '401'
    default_detail = '账号或密码错误'

