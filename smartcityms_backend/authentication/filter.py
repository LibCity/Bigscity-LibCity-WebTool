import django_filters
from django_filters.rest_framework import FilterSet

from authentication.models import Account, Role, Permission


class AccountFilter(FilterSet):
    """
    账号查询条件过滤
    """
    # 创建时间区间查询
    begin = django_filters.DateTimeFilter(field_name='create_time', lookup_expr='gte')
    end = django_filters.DateTimeFilter(field_name='create_time', lookup_expr='lte')
    # account_number模糊查询
    account_number = django_filters.CharFilter(field_name='account_number', lookup_expr='icontains')
    # 所属角色
    roles = django_filters.ModelMultipleChoiceFilter(queryset=Role.objects.all())

    class Meta:
        model = Account
        fields = ['begin', 'end', 'account_number', 'roles']


class RoleFilter(FilterSet):
    """
    角色条件查询过滤
    """
    # 创建时间区间查询
    begin = django_filters.DateTimeFilter(field_name='create_time', lookup_expr='gte')
    end = django_filters.DateTimeFilter(field_name='create_time', lookup_expr='lte')
    # name 模糊查询
    name = django_filters.CharFilter(field_name='name', lookup_expr='icontains')
    # description 模糊查询
    description = django_filters.CharFilter(field_name='description', lookup_expr='icontains')

    class Meta:
        model = Role
        fields = ['begin', 'end', 'name', 'description']


class PermissionFilter(FilterSet):
    """
    权限条件查询过滤
    """
    # 创建时间区间查询
    begin = django_filters.DateTimeFilter(field_name='create_time', lookup_expr='gte')
    end = django_filters.DateTimeFilter(field_name='create_time', lookup_expr='lte')
    # name 模糊查询
    name = django_filters.CharFilter(field_name='name', lookup_expr='icontains')
    # type 精确查询
    type = django_filters.CharFilter(field_name='type')

    class Meta:
        model = Permission
        fields = ['begin', 'end', 'name', 'type']