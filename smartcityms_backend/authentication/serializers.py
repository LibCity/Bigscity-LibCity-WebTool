from rest_framework import serializers

from authentication.models import Account, Role, Permission


class AccountSerializer(serializers.ModelSerializer):
    """
    创建、更新序列化
    """
    class Meta:
        model = Account
        fields = "__all__"


class AccountListSerializer(serializers.ModelSerializer):
    """
    查询结果返回序列化 列表查询
    """
    roles = serializers.StringRelatedField(many=True)

    class Meta:
        model = Account
        fields = ['id', 'account_number', 'mail', 'roles', 'create_time', 'update_time']


class AccountSelectSerializer(serializers.ModelSerializer):
    """
    查询结果返回序列化 单个查询
    """
    class Meta:
        model = Account
        fields = ['id', 'account_number', 'mail', 'roles', 'create_time', 'update_time']


class PermissionSerializer(serializers.ModelSerializer):

    type = serializers.ChoiceField(choices=Permission.permission_type_choices, default='interface')

    parent = serializers.StringRelatedField()

    class Meta:
        model = Permission
        fields = "__all__"


class PermissionCreateSerializer(serializers.ModelSerializer):

    type = serializers.ChoiceField(choices=Permission.permission_type_choices, default='interface')

    class Meta:
        model = Permission
        fields = "__all__"


class RoleSerializer(serializers.ModelSerializer):

    class Meta:
        model = Role
        fields = "__all__"



