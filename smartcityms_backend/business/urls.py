import os

from django.conf import settings
from django.urls import path, include
from loguru import logger
from rest_framework import routers
from watchdog.observers import Observer


from business import views
from business.handler import logCreateHandler

router = routers.DefaultRouter()
router.register('file', views.FileViewSet)
router.register('task', views.TaskViewSet)
router.register('evaluate', views.TrafficStateEtaViewSet)
router.register('map_matching', views.MapMatchingViewSet)
router.register('traj_loc', views.TrajLocPredViewSet)

urlpatterns = [
    path('', include(router.urls)),
]

logger.info('Start to watch log file')
# 判断目录是否存在，不存在则创建
LOG_PATH = settings.LOG_PATH
if not os.path.isdir(LOG_PATH):
    logger.info('日志目录不存在，正在创建: {}', LOG_PATH)
    os.makedirs(LOG_PATH)   # 可生成多层目录

# 监控libcity的log目录
observer = Observer()
observer.schedule(logCreateHandler(), LOG_PATH)
observer.start()
logger.info('LOG_PATH监控线程已启动，LOG_PATH: {}', LOG_PATH)
