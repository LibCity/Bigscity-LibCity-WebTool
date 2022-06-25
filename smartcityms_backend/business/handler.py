import os

from loguru import logger
from watchdog.events import FileSystemEventHandler

from business.models import Task


class logCreateHandler(FileSystemEventHandler):

    def on_created(self, event):
        logger.info('创建了新文件：{}', event.src_path)
        file_name_and_ext = os.path.split(event.src_path)[1]
        file_name, ext = os.path.splitext(file_name_and_ext)
        if ext == '.log':
            # file_name 根据 - 分割 选第一个就是 exp_id
            exp_id = file_name.split('-')[0]
            # 更新这个 exp_id 的日志字段
            log_name = event.src_path
            logger.info('set_log_file-日志文件名称: {}', log_name)
            Task.objects.filter(exp_id=exp_id).update(log_file_name=log_name)
        else:
            logger.info('不是日志文件：{}', event.src_path)
