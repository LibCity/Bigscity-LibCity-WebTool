from django.db import models

# Create your models here.
from django.utils import timezone


class BaseModel(models.Model):
    """
    所有表，通用字段
    """
    create_time = models.DateTimeField(
        default=timezone.now, verbose_name='创建时间', help_text='创建时间')
    update_time = models.DateTimeField(
        auto_now=True, verbose_name='修改时间', help_text='修改时间')

    class Meta:
        abstract = True
