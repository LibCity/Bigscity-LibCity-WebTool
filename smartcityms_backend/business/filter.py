import django_filters
from django_filters.rest_framework import FilterSet

from authentication.models import Account
from business.models import File, Task, TrafficStatePredAndEta


class FileFilter(FilterSet):
    """
    文件查询条件过滤
    """
    # 创建时间区间查询
    begin = django_filters.DateTimeFilter(field_name='create_time', lookup_expr='gte')
    end = django_filters.DateTimeFilter(field_name='create_time', lookup_expr='lte')
    # 文件名模糊查询
    file_name = django_filters.CharFilter(field_name='file_original_name', lookup_expr='icontains')
    # 创建者精确查询
    # creator = django_filters.ModelChoiceFilter(queryset=Account.objects.all())
    # 私有 或 公开查询
    # visibility = django_filters.NumberFilter(field_name='visibility')

    class Meta:
        model = File
        fields = ['begin', 'end', 'file_name']


class TaskFilter(FilterSet):
    """
    任务查询条件过滤
    """
    # 创建时间区间查询
    begin = django_filters.DateTimeFilter(field_name='create_time', lookup_expr='gte')
    end = django_filters.DateTimeFilter(field_name='create_time', lookup_expr='lte')
    # 任务名模糊查询
    task_name = django_filters.CharFilter(field_name='task_name_show', lookup_expr='icontains')
    # 任务类型精确查询
    task = django_filters.CharFilter(field_name='task')
    # 任务状态精确查询
    task_status = django_filters.CharFilter(field_name='task_status')
    # 数据集模糊查询
    dataset = django_filters.CharFilter(field_name='dataset', lookup_expr='icontains')

    class Meta:
        model = Task
        fields = ['begin', 'end', 'task_name', 'task', 'task_status', 'dataset']
