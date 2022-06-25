from django.contrib.auth.base_user import AbstractBaseUser
from django.contrib.auth.hashers import make_password
from django.db import models

# Create your models here.
from common.models import BaseModel


class Permission(BaseModel):
    """
    权限表
    """
    permission_type_choices = (
        ('menu', '菜单'),
        ('interface', '接口')
    )

    name = models.CharField('权限名', max_length=20)
    type = models.CharField('权限类型', max_length=10,
                            choices=permission_type_choices, default='interface')
    code = models.CharField('权限标识', max_length=30)
    parent = models.ForeignKey('self', null=True, blank=True,
                               on_delete=models.SET_NULL, verbose_name='父功能', db_constraint=False)

    class Meta:
        verbose_name = '权限'
        verbose_name_plural = verbose_name
        db_table = 'tb_permission'

    def __str__(self):
        return self.name


class Role(BaseModel):
    """
    角色表
    """
    name = models.CharField('角色名', max_length=20, unique=True)
    description = models.CharField('角色描述', max_length=50, null=True)
    # 角色权限多对多
    permissions = models.ManyToManyField(Permission, blank=True,
                                         verbose_name='功能权限', db_constraint=False)

    class Meta:
        verbose_name = '角色'
        verbose_name_plural = verbose_name
        db_table = 'tb_role'

    def __str__(self):
        return self.name


class Account(AbstractBaseUser, BaseModel):
    """
    账号表
    """
    account_number = models.CharField('账号', max_length=20, unique=True)
    password = models.CharField('密码', max_length=128, null=True)
    mail = models.CharField('邮箱', max_length=128, null=True, unique=True)
    # 账户角色多对多
    roles = models.ManyToManyField(Role, blank=True, verbose_name='角色', db_constraint=False)

    USERNAME_FIELD = 'account_number'
    REQUIRED_FIELDS = []

    class Meta:
        verbose_name = '账号'
        verbose_name_plural = verbose_name
        ordering = ['id']
        db_table = 'tb_account'
