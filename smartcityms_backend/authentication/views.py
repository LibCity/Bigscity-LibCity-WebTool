from django.contrib.auth.hashers import make_password, check_password
from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema
from loguru import logger
from rest_framework import status
from rest_framework.decorators import action
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.viewsets import ModelViewSet

from authentication.filter import AccountFilter, RoleFilter, PermissionFilter
from authentication.models import Account, Role, Permission
from authentication.permission import get_permission_list
from authentication.serializers import AccountSerializer, RoleSerializer, PermissionSerializer, AccountSelectSerializer, \
    AccountListSerializer, PermissionCreateSerializer
from authentication.utils import get_tree
from common import utils
from common.cache import memory_cache
from common.utils import get_code


class AccountViewSet(ModelViewSet):
    queryset = Account.objects.prefetch_related('roles').all()
    # 条件过滤器
    filter_class = AccountFilter

    def get_serializer_class(self):
        if self.action == 'list':
            return AccountListSerializer
        elif self.action == 'retrieve':
            return AccountSelectSerializer
        return AccountSerializer

    @action(methods=['post'], detail=False)
    def exists(self, request):
        """
        检测账号是否存在
        """
        account_number = request.data.get('account_number')
        accounts = Account.objects.filter(account_number=account_number).all()
        if len(accounts) == 0:
            return Response(status=status.HTTP_200_OK)
        else:
            return Response(data={'msg': '角色已存在！', 'id': accounts[0].id}, status=status.HTTP_400_BAD_REQUEST)

    @action(methods=['get'], detail=False)
    def list_all(self, request, *args, **kwargs):
        """
        查询所有账户，只返回账号和id两列
        """
        account_list = Account.objects.values("id", "account_number")
        return Response(account_list)

    @action(methods=['post'], detail=False)
    def send_code(self, request, *args, **kwargs):
        """
        发送验证码
        """
        mail = request.data.get('mail', None)
        if mail:
            # 邮箱重复性校验
            accounts = Account.objects.filter(mail=mail).all()
            if len(accounts) != 0:
                return Response(status=status.HTTP_409_CONFLICT)
            code = get_code(pure_number=True)
            memory_cache.set_value(mail, code, 60 * 5)
            subject = 'LibCity实验管理系统'
            content = f'欢迎注册LibCity实验管理系统！您的验证码为：{code}  验证码五分钟有效，请不要告诉任何人！'
            utils.thread_pool.submit(utils.send_mail, subject, content, mail)
            return Response(status=status.HTTP_200_OK)
        return Response(data={'detail': '邮箱不能为空'}, status=status.HTTP_400_BAD_REQUEST)

    @action(methods=['post'], detail=True)
    def bind_mail(self, request, *args, **kwargs):
        """
        绑定邮箱
        """
        account = self.get_object()
        mail = request.data.get('mail', None)
        code = request.data.get('code', None)
        # 确定验证码是否有效
        if not mail:
            return Response(data={'detail': '邮箱不能为空'}, status=status.HTTP_400_BAD_REQUEST)
        cache_code = memory_cache.get_value(mail)
        if cache_code != code:
            logger.info('验证码错误，缓存中的验证码为：{}，输入的验证码为：{}'.format(cache_code, code))
            return Response(data={'detail': '验证码不正确'}, status=status.HTTP_400_BAD_REQUEST)
        account.mail = mail
        account.save()
        return Response(status=status.HTTP_200_OK)

    def create(self, request, *args, **kwargs):
        """
        创建账户
        """
        password = request.data.get('password', None)
        if password:
            # 用户自行注册
            mail = request.data.get('mail', None)
            code = request.data.get('code', None)
            # 邮箱校验
            if not mail:
                return Response(data={'detail': '邮箱不能为空'}, status=status.HTTP_400_BAD_REQUEST)
            cache_code = memory_cache.get_value(mail)
            if cache_code != code:
                logger.info('验证码错误，缓存中的验证码为：{}，输入的验证码为：{}'.format(cache_code, code))
                return Response(data={'detail': '验证码不正确'}, status=status.HTTP_400_BAD_REQUEST)
            # 密码加密
            password = make_password(password)
            # 保存用户信息
            serializer = self.get_serializer(data=request.data)
            serializer.is_valid(raise_exception=True)
            # 设置默认角色 普通用户 注意：12号 id 角色是系统保护角色，角色名为普通用户
            serializer.save(password=password, roles=[12])
            return Response(status=status.HTTP_200_OK)
        else:
            # 管理员手动添加
            raw_password = get_code()
            logger.debug('随机生成密码为：' + raw_password)
            password = make_password(raw_password)
            serializer = self.get_serializer(data=request.data)
            serializer.is_valid(raise_exception=True)
            serializer.save(password=password)
            data = {'raw_password': raw_password}
            return Response(data)

    def update(self, request, *args, **kwargs):
        password = None
        if 'password' in request.data.keys():
            password = make_password(request.data['password'])
        partial = kwargs.pop('partial', False)
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=partial)
        serializer.is_valid(raise_exception=True)
        if password:
            serializer.save(password=password)
        else:
            serializer.save()

        if getattr(instance, '_prefetched_objects_cache', None):
            instance._prefetched_objects_cache = {}

        return Response(serializer.data)

    @action(methods=['get'], detail=True)
    def delete(self, request, *args, **kwargs):
        return self.destroy(request, *args, **kwargs)

    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()
        # 检查是否是系统保留账户，系统保留账户不可删除
        protected_account_id = 3
        if instance.id == protected_account_id:
            return Response(status=status.HTTP_400_BAD_REQUEST)
        self.perform_destroy(instance)
        return Response(status=status.HTTP_204_NO_CONTENT)

    @action(methods=['get'], detail=False, url_name='account_info', permission_classes=[IsAuthenticated],
            pagination_class=None)
    def info(self, request, pk=None):
        """
        获取账号信息，包括权限
        """
        account = request.user
        permission_list = get_permission_list(account)
        roles = account.roles.all()
        role_names = []
        for role in roles:
            role_names.append(role.name)
        data = {
            'id': account.id,
            'accountNumber': account.account_number,
            'roles': role_names,
            'permissions': permission_list
        }
        return Response(data)

    @swagger_auto_schema(methods=['post'], request_body=openapi.Schema(
        type=openapi.TYPE_OBJECT,
        required=['old_password', 'new_password', 'new_password_repeat'],
        properties={'old_password': openapi.Schema(type=openapi.TYPE_STRING),
                    'new_password': openapi.Schema(type=openapi.TYPE_STRING),
                    'new_password_repeat': openapi.Schema(type=openapi.TYPE_STRING)}
    ))
    @action(methods=['post'], detail=False, permission_classes=[IsAuthenticated], url_name='change_password')
    def password(self, request):
        """
        修改密码
        """
        account = request.user
        old_password = request.data['old_password']
        new_password = request.data['new_password']
        new_password_repeat = request.data['new_password_repeat']
        if check_password(old_password, account.password):
            if new_password == new_password_repeat:
                account.password = make_password(new_password)
                account.save()
                return Response('密码修改成功！', status=status.HTTP_200_OK)
            else:
                return Response(data={'detail': '密码修改失败！两次密码输入不一致'}, status=status.HTTP_400_BAD_REQUEST)
        else:
            return Response(data={'detail': '旧密码错误！'}, status=status.HTTP_400_BAD_REQUEST)


class LogOutView(APIView):
    """
    退出登录
    """
    def get(self, request, *args, **kwargs):
        return Response(status=status.HTTP_200_OK)


class RoleViewSet(ModelViewSet):
    queryset = Role.objects.prefetch_related('permissions').all()
    serializer_class = RoleSerializer
    # 条件过滤器
    filter_class = RoleFilter

    @action(methods=['post'], detail=False)
    def exists(self, request):
        """
        检测角色是否存在
        """
        role_name = request.data.get('role_name')
        roles = Role.objects.filter(name=role_name).all()
        if len(roles) == 0:
            return Response(status=status.HTTP_200_OK)
        else:
            return Response(data={'msg': '角色已存在！', 'id': roles[0].id}, status=status.HTTP_400_BAD_REQUEST)

    @action(methods=['get'], detail=True)
    def delete(self, request, *args, **kwargs):
        return self.destroy(request, *args, **kwargs)

    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()
        # 执行删除时检查是否是系统保留角色
        protected_role_ids = [6, 12]
        if instance.id in protected_role_ids:
            return Response(status=status.HTTP_400_BAD_REQUEST)
        # 执行删除
        self.perform_destroy(instance)
        return Response(status=status.HTTP_204_NO_CONTENT)


class PermissionViewSet(ModelViewSet):
    queryset = Permission.objects.select_related('parent__parent').all()
    serializer_class = PermissionSerializer
    # 条件过滤器
    filter_class = PermissionFilter

    def get_serializer_class(self):
        if self.action == 'create':
            return PermissionCreateSerializer
        return PermissionSerializer

    @action(methods=['get'], detail=False, url_name='permission_tree',
            pagination_class=None)
    def tree(self, request):
        """
        返回所有权限树形结构数据
        """
        permissions = Permission.objects.all().values()
        tree_list = get_tree(permissions)
        return Response(tree_list)
