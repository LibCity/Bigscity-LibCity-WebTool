import hashlib

from django.contrib.auth.backends import ModelBackend
from django.contrib.auth import get_user_model
from django.contrib.auth.hashers import check_password
from loguru import logger
from rest_framework import exceptions
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from rest_framework_simplejwt.views import TokenObtainPairView

from authentication.exceptions import AuthenticationFailed
from authentication.models import Account

UserModel = get_user_model()


class MyTokenObtainPairSerializer(TokenObtainPairSerializer):
    """
    自定义登录认证，发放token
    """
    def validate(self, attrs):
        authenticate_kwargs = {
            self.username_field: attrs[self.username_field]}
        try:
            account = Account.objects.get(**authenticate_kwargs)
            if not check_password(attrs['password'], account.password):
                raise AuthenticationFailed
        except Exception as e:
            logger.error('账号登录异常：{}'.format(e))
            raise AuthenticationFailed

        refresh = self.get_token(account)

        data = {
            "accountId": account.id, "token": str(refresh.access_token), "refresh": str(refresh)}
        return data


class MyTokenObtainPairView(TokenObtainPairView):
    serializer_class = MyTokenObtainPairSerializer


class CustomizeBackend(ModelBackend):
    """
    自定义登录授权
    """
    def authenticate(self, request, username=None, password=None, **kwargs):
        if username is None:
            username = kwargs.get(UserModel.USERNAME_FIELD)
        if username is None or password is None:
            return
        try:
            account = Account.objects.get(account_number=username)
            if check_password(account.password, password):
                return account
        except Exception as e:
            raise exceptions.NotFound(e.args[0])
        return account
