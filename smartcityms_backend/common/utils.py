# coding=utf-8
import math

__all__ = ['pybyte']

import os
import smtplib
import subprocess
import time
import zipfile
from concurrent.futures import ThreadPoolExecutor
from email.mime.text import MIMEText
from smtplib import SMTP_SSL
from multiprocessing import cpu_count

import psutil
from django.conf import settings
from django.http import FileResponse
import random
from loguru import logger


def pybyte(size, dot=2):
    size = float(size)
    # 位 比特 bit
    if 0 <= size < 1:
        human_size = str(round(size / 0.125, dot)) + 'b'
    # 字节 字节 Byte
    elif 1 <= size < 1024:
        human_size = str(round(size, dot)) + 'B'
    # 千字节 千字节 Kilo Byte
    elif math.pow(1024, 1) <= size < math.pow(1024, 2):
        human_size = str(round(size / math.pow(1024, 1), dot)) + 'KB'
    # 兆字节 兆 Mega Byte
    elif math.pow(1024, 2) <= size < math.pow(1024, 3):
        human_size = str(round(size / math.pow(1024, 2), dot)) + 'MB'
    # 吉字节 吉 Giga Byte
    elif math.pow(1024, 3) <= size < math.pow(1024, 4):
        human_size = str(round(size / math.pow(1024, 3), dot)) + 'GB'
    # 太字节 太 Tera Byte
    elif math.pow(1024, 4) <= size < math.pow(1024, 5):
        human_size = str(round(size / math.pow(1024, 4), dot)) + 'TB'
    # 拍字节 拍 Peta Byte
    elif math.pow(1024, 5) <= size < math.pow(1024, 6):
        human_size = str(round(size / math.pow(1024, 5), dot)) + 'PB'
    # 艾字节 艾 Exa Byte
    elif math.pow(1024, 6) <= size < math.pow(1024, 7):
        human_size = str(round(size / math.pow(1024, 6), dot)) + 'EB'
    # 泽它字节 泽 Zetta Byte
    elif math.pow(1024, 7) <= size < math.pow(1024, 8):
        human_size = str(round(size / math.pow(1024, 7), dot)) + 'ZB'
    # 尧它字节 尧 Yotta Byte
    elif math.pow(1024, 8) <= size < math.pow(1024, 9):
        human_size = str(round(size / math.pow(1024, 8), dot)) + 'YB'
    # 千亿亿亿字节 Bront Byte
    elif math.pow(1024, 9) <= size < math.pow(1024, 10):
        human_size = str(round(size / math.pow(1024, 9), dot)) + 'BB'
    # 百万亿亿亿字节 Dogga Byte
    elif math.pow(1024, 10) <= size < math.pow(1024, 11):
        human_size = str(round(size / math.pow(1024, 10), dot)) + 'NB'
    # 十亿亿亿亿字节 Dogga Byte
    elif math.pow(1024, 11) <= size < math.pow(1024, 12):
        human_size = str(round(size / math.pow(1024, 11), dot)) + 'DB'
    # 万亿亿亿亿字节 Corydon Byte
    elif math.pow(1024, 12) <= size:
        human_size = str(round(size / math.pow(1024, 12), dot)) + 'CB'
    # 负数
    else:
        raise ValueError('{}() takes number than or equal to 0, but less than 0 given.'.format(pybyte.__name__))
    return human_size


def execute_cmd(cmd):
    """
    执行命令行命令（已弃用，请使用 ExecuteCmd 类）

    :param cmd: 命令内容
    :return: (status, output) status: 1 失败，0 成功
    """
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
    output, err = p.communicate()
    # 判断命令是否执行成功
    status = p.returncode
    if status == 0:
        logger.info('[SUCCESS] %s' % cmd)
    else:
        logger.error('[ERROR] command: %s; message: %s' % (cmd, err))
        return status, err
    return status, output


class ExecuteCmd:
    def __init__(self, cmd):
        self.terminate = False
        self.cmd = cmd

    def execute(self):
        p = subprocess.Popen(self.cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True, text=True)
        logger.info("命令执行进程启动，进程号: {}", p.pid)
        # 判断命令是否执行成功
        while True:
            status = p.poll()
            if status is not None:
                logger.info("实验已结束，状态码：{}", status)
                if self.terminate:
                    output = '主动中断实验'
                    errs = '主动中断实验'
                else:
                    output, errs = p.communicate()
                if status == 0:
                    logger.info('[SUCCESS] {}', self.cmd)
                    return status, output
                elif status == 1 or status == 15:
                    logger.error('[ERROR] command: {}; message: {}', self.cmd, errs)
                    return status, errs
                else:
                    logger.error('未知错误，状态码：{}', status)
                    return status, 'Unknown Error'
            else:
                if self.terminate:
                    kill(p.pid)
                    logger.info("用户主动结束实验进程，命令内容：{}", self.cmd)
            time.sleep(10)


def kill(proc_pid):
    """
    中断传入进程号的进程及其子进程

    :param proc_pid: 进程号
    """
    process = psutil.Process(proc_pid)
    for proc in process.children(recursive=True):
        proc.kill()
    process.kill()

def read_file_str(file_path):
    """
    将一个文件内容读取到字符串中，仅适用于小文件读取，编码格式：utf-8

    :param file_path: 文件具体路径
    :return: 文件内容字符串
    """
    # 判断路径文件存在
    if not os.path.isfile(file_path):
        raise TypeError(file_path + " does not exist")
    # 读取
    content = ''
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    return content


def generate_download_file(file_path):
    """
    通用生成下载文件的方法
    仅限于下载文件接口，接口方法需要用 @renderer_classes((PassthroughRenderer,))

    :param file_path: 文件路径
    :return: 响应的response
    """
    response_file = FileResponse(open(file_path, 'rb'))
    response_file['content_type'] = "application/octet-stream"
    response_file['Content-Disposition'] = 'attachment; filename=' + os.path.basename(file_path)
    return response_file


def get_code(pure_number=False):
    """
    随机生成六位字符串
    :param pure_number: 是否需要纯数字
    """
    code = ''
    if pure_number:
        for _ in range(6):
            add = random.choice([random.randrange(10)])
            code += str(add)
    else:
        for _ in range(6):
            add = random.choice([random.randrange(10), chr(random.randrange(65, 91)), chr(random.randrange(97, 123))])
            code += str(add)
    return code


def parentheses_escape(raw_string):
    """
    对字符串中的圆括号 '(' ')' 进行转义替换，替换为：'\\(' '\\)'

    :param raw_string: 原始字符串
    :return: 转义后字符串
    """
    return raw_string.replace('(', '\\(').replace(')', '\\)')


def str_is_empty(raw_string):
    """
    判断字符串是否为空

    :param raw_string: 字符串
    :return: 是否为空
    """
    return raw_string is None or raw_string == ''


def query_type(data):
    for ch in data:
        if ch == '{':
            return "dict"
        if ch == '[':
            return "list"
    return "value"


def get_geojson_properties(geojson):
    """
    获取geojson的所有properties的信息

    :param geojson: geojson json对象
    :return: properties dict
    """
    features = geojson.get('features', None)
    if features is not None and type(features) is list and len(features) > 0:
        properties = features[0].get('properties', None)
        if properties is not None:
            return properties
        else:
            logger.error('get_geojson_properties 没有 properties 属性')
            return None
    else:
        logger.error('get_geojson_properties features 为空')
        return None
    # return geojson['features'][0]['properties']


# feature_list = []  # 这里要保证有序，可以用有序字典，映射的时候可以用dict
#
#
# def get_json_features(json_path):
#     del feature_list[:]
#     # 这里要保证有序，可以用有序字典，映射的时候可以用dict
#     with open(json_path, 'r', encoding='UTF-8') as file_in:
#         data_str = file_in.read()
#     get_json_head(data_str)
#     return feature_list
#
#
# def get_json_head(data, loc=""):
#     data = str(data)  # 将数据转换成字符串
#     data_type = query_type(data)
#     if data_type == "value":  # 如果是元素
#         if loc[1:] not in feature_list:
#             feature_list.append(loc[1:])
#         return
#     if data_type == "dict":  # 如果是字典
#         data_dict = eval(data)  # 耗时
#         # 循环 + 递归 耗时
#         for key in data_dict:
#             get_json_head(data_dict[key], loc + "_" + key)
#         return
#     if data_type == "list":  # 如果是列表
#         data_list = list(eval(data))
#         for item in data_list:
#             get_json_head(item, loc)
#         return


def get_background_url(background_id):
    """
    获取folium地图底图展示url
    """
    if int(background_id) == 1:
        background_url = 'https://mt.google.com/vt/lyrs=m&x={x}&y={y}&z={z}'
    elif int(background_id) == 2:
        background_url = 'https://mt.google.com/vt/lyrs=s&x={x}&y={y}&z={z}'
    elif int(background_id) == 3:
        background_url = 'https://webrd02.is.autonavi.com/appmaptile?lang=zh_en&size=1&scale=1&style=8&x={' \
                         'x}&y={y}&z={z} '
    elif int(background_id) == 4:
        background_url = 'http://webst02.is.autonavi.com/appmaptile?style=6&x={x}&y={y}&z={z}'
    elif int(background_id) == 5:
        background_url = 'OpenStreetMap'
    elif int(background_id) == 6:
        background_url = 'https://tileserver.memomaps.de/tilegen/{z}/{x}/{y}.png'
    elif int(background_id) == 7:
        background_url = 'https://stamen-tiles-{s}.a.ssl.fastly.net/toner-hybrid/{z}/{x}/{y}{r}.png'
    else:
        background_url = 'https://mt.google.com/vt/lyrs=m&x={x}&y={y}&z={z}'
    return background_url


def return_location(geo_json):
    """
    获取geojson的初始坐标点，返回符合folium的location的坐标点
    """
    # 不再取第一个值
    # block = geo_json['features'][0]
    block = geo_json['features'][return_middle(geo_json['features'])]
    location = None
    if len(block['geometry']['coordinates']) > 0:
        if type(block['geometry']['coordinates'][0]) is not list:
            location = block['geometry']['coordinates']
        else:
            one_middle = return_middle(block['geometry']['coordinates'])
            if type(block['geometry']['coordinates'][0][0]) is not list:
                location = block['geometry']['coordinates'][one_middle]
            else:
                two_middle = return_middle(block['geometry']['coordinates'][one_middle])
                if type(block['geometry']['coordinates'][0][0][0]) is not list:
                    location = block['geometry']['coordinates'][one_middle][two_middle]
                else:
                    end_middle = return_middle(block['geometry']['coordinates'][one_middle][two_middle])
                    location = block['geometry']['coordinates'][one_middle][two_middle][end_middle]
    # reverse方法会影响原来json数据的坐标顺序
    # location.reverse()
    res_location = location[::-1]
    logger.info('地图location: {}', location)
    return res_location


def return_middle(data_list):
    return int(len(data_list) / 2)


def red_style(feature):
    """
    folium的style_function 红色
    """
    return {'fillOpacity': 0.4,
            'weight': 2,
            'fillColor': 'red',
            'color': 'red'
            }


def random_style(feature):
    """
    返回一个随机颜色的style
    """
    color = ["#" + ''.join([random.choice('0123456789ABCDEF') for j in range(6)])]
    return {'fillOpacity': 1,
            'weight': 3,
            'fillColor': color,
            'color': color
            }


def send_mail(subject, message, to_address):
    """
    发送邮件

    :param subject: 邮件主题描述
    :param message: 邮件内容
    :param to_address: 收件人
    """
    # 填写真实的发邮件服务器用户名、密码
    user = settings.SENDER_ADDRESS
    password = settings.SENDER_AUTHORIZATION_CODE
    # 邮件内容
    msg = MIMEText(message, 'plain', _charset="utf-8")
    # 邮件主题描述
    msg["Subject"] = subject
    try:
        with SMTP_SSL(host=settings.SMTP_SERVER_ADDRESS, port=settings.SMTP_SERVER_PORT) as smtp:
            # 登录发邮件服务器
            smtp.login(user=user, password=password)
            # 实际发送、接收邮件配置
            smtp.sendmail(from_addr=user, to_addrs=to_address.split(','), msg=msg.as_string())
            logger.info("邮件发送成功！目标邮箱：{}", to_address)
    except smtplib.SMTPException as ex:
        logger.error("发送邮件异常，目标邮箱：{}  异常信息：{}", to_address, ex)


def extract_without_folder(arc_name, full_item_name, folder, file_prefix=None):
    """
    解压压缩包中的指定文件到指定目录

    :param arc_name: 压缩包文件
    :param full_item_name: 压缩包中指定文件的全路径，相对压缩包的相对路径
    :param folder: 解压的目标目录，绝对路径
    """
    with zipfile.ZipFile(arc_name) as zf:
        file_data = zf.read(full_item_name)
    # 中文乱码解决
    full_item_name = full_item_name.encode('cp437').decode('gbk')
    original_file_name, ext = os.path.splitext(os.path.basename(full_item_name))
    if ext != '.json' and file_prefix is not None:
        original_file_name = file_prefix + '_' + original_file_name + ext
    else:
        original_file_name = original_file_name + ext
    with open(os.path.join(folder, original_file_name), "wb") as file_out:
        file_out.write(file_data)


# ------------------------------
#           全局变量区
# ------------------------------
# 全局线程池 线程数默认为 cpu 核心数 * 2
thread_pool = ThreadPoolExecutor(max_workers=cpu_count() * 2)
# 全局实验执行字典，key: 实验id value: ExecuteCmd 对象
exp_cmd_map = {}
