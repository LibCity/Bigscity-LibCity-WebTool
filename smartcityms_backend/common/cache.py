"""
基于内存缓存
使用 memory_cache 实例即可
"""
import time

from loguru import logger

from business.scheduler import task_execute_days


class Value:
    def __init__(self, value, put_time, expired):
        """
        缓存值对象

        :param value: 具体的值
        :param put_time: 放入缓存的时间
        :param expired: 缓存失效时间
        """
        self.value = value
        self.put_time = put_time
        self.expired = expired

    def __str__(self):
        return f"value: {self.value}  put_time: {self.put_time}  expired: {self.expired}"


class MemoryCache:

    def __init__(self):
        self.__cache = {}

    def set_value(self, k, v, expired):
        """
        将值放入缓存中

        :param k: 缓存的 key
        :param v: 缓存值
        :param expired: 缓存失效时间，单位秒(s)
        """
        current_timestamp = int(time.time())  # 获取当前时间戳 10 位 秒级
        value = Value(v, current_timestamp, expired)
        self.__cache[k] = value
        logger.info("已放入缓存, key: {} {}", k, value)

    def check_key(self, k):
        """
        检查缓存是否可用

        :param k: 缓存 key
        :return: True or False
        """
        current_timestamp = int(time.time())
        value = self.__cache.get(k, None)
        # 考虑k不存在的情况
        if value is None:
            return False
        differ = current_timestamp - value.put_time
        if differ > value.expired:
            del self.__cache[k]  # 证明缓存失效了，删除键值对
            logger.info("缓存已经失效, key: {}", k)
            return False
        return True

    def get_value(self, k):
        """
        通过缓存key获取值

        :param k: key
        :return: value
        """
        if self.check_key(k):
            return self.__cache[k].value
        return None

    def clean_cache(self):
        """
        清理缓存
        """
        for k in self.__cache.keys():
            self.check_key(k)
        logger.info("系统已将最近缓存内容清理")


memory_cache = MemoryCache()

task_execute_days(memory_cache.clean_cache, 10)
