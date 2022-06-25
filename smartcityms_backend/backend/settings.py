"""
Django settings for backend project.

Generated by 'django-admin startproject' using Django 3.2.9.

For more information on this file, see
https://docs.djangoproject.com/en/3.2/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/3.2/ref/settings/
"""

from datetime import timedelta
from pathlib import Path

# Build paths inside the project like this: BASE_DIR / 'subdir'.
from loguru import logger


import os


BASE_DIR = Path(__file__).resolve().parent.parent.parent

# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/3.2/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = 'django-insecure-=x0^^6q)zc_n2mfn3_l=rc+rui2zwu5^^75plio^7y34+r^5ks'

# Application definition

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'authentication',  # 权限app
    'business',  # 业务app
    'rest_framework',  # Django Rest Framework
    'django_filters',  # 过滤器
    'drf_yasg',  # 接口文档
    'corsheaders',  # 跨域问题
    'rest_framework_simplejwt.token_blacklist',  # 拉黑token
    # 'channels' # websocket
]

# asgi支持wsgi、更多协议
# ASGI_APPLICATION = 'socketpro.asgi.application'

MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',  # 跨域问题
    'django.middleware.locale.LocaleMiddleware',  # 国际化
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'backend.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [BASE_DIR / 'templates']
        ,
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'backend.wsgi.application'


# Password validation
# https://docs.djangoproject.com/en/3.2/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.authentication.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.authentication.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.authentication.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.authentication.password_validation.NumericPasswordValidator',
    },
]

# Internationalization
# https://docs.djangoproject.com/en/3.2/topics/i18n/

LANGUAGE_CODE = 'en-us'
# 语言使用中文
# LANGUAGE_CODE = 'zh-hans'
# 识别cookie的名称，cookie存储语言信息
LANGUAGE_COOKIE_NAME = 'language'
# TIME_ZONE = 'UTC'
# 时区必须更改，不然自动生成的时间是UTC的
TIME_ZONE = 'Asia/Shanghai'

USE_I18N = True

USE_L10N = True

USE_TZ = True

# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/3.2/howto/static-files/

STATIC_URL = '/static/'

# Default primary key field type
# https://docs.djangoproject.com/en/3.2/ref/settings/#default-auto-field

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

# rest framework配置
REST_FRAMEWORK = {
    # 默认分页器
    'DEFAULT_PAGINATION_CLASS': 'common.pagination.CustomizePagination',
    'PAGE_SIZE': 10,
    # 默认过滤器
    'DEFAULT_FILTER_BACKENDS': ['django_filters.rest_framework.DjangoFilterBackend'],
    # 登录认证，不加这个token就无法使用
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework_simplejwt.authentication.JWTAuthentication',
        'rest_framework.authentication.BasicAuthentication',
        'rest_framework.authentication.SessionAuthentication',
    ),
    # 默认返回结果渲染
    'DEFAULT_RENDERER_CLASSES': ('common.response.FitJSONRenderer',),
    # 返回时间格式化处理
    'DATETIME_FORMAT': '%Y-%m-%d %H:%M:%S',
    'DATE_FORMAT': '%Y-%m-%d',
}

# 登录认证配置
AUTH_USER_MODEL = 'authentication.Account'
AUTHENTICATION_BACKENDS = (
    'authentication.auth.CustomizeBackend',
)

# simplejwt配置
SIMPLE_JWT = {
    'ACCESS_TOKEN_LIFETIME': timedelta(days=7),
}

# 日志配置
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {
        'console': {
            'level': 'DEBUG',
            'class': 'logging.StreamHandler',
        },
    },
    'loggers': {
        'django.db.backends': {
            'handlers': ['console'],
            'propagate': True,
            'level': 'DEBUG',
        },
    }
}

# 自定义任务序列
IN_PROGRESS = []
COMPLETED = []

# 日志记录
logger.add("./log/file_{time}.log", rotation="10 MB", encoding="utf-8")
logger.info("base.py settings loading")

# 邮件发送相关
# 邮件发送者邮箱地址
SENDER_ADDRESS = ''
# 邮箱授权码
SENDER_AUTHORIZATION_CODE = ''
# SMTP 服务器地址
SMTP_SERVER_ADDRESS = ''
# SMTP 服务器端口
SMTP_SERVER_PORT = 0

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = False

ALLOWED_HOSTS = ['?']

# 数据库
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'django',  # 指定的数据库名
        'USER': 'root',  # 数据库登录的用户名
        'PASSWORD': '?',  # 登录数据库的密码
        'HOST': '127.0.0.1',
        'PORT': '3306',
    }
}

# 跨域设置
# 单个配置
CORS_ORIGIN_WHITELIST = (
    'http://?:8000',
)

# 允许携带cookie
CORS_ALLOW_CREDENTIALS = True

# 允许所有主机跨域
# CORS_ORIGIN_ALLOW_ALL = True

# libcity库程序相关
# libcity程序目录
LIBCITY_PATH = '/home/houge/Bigscity-LibCity-WebTool/Bigscity-LibCity'
# 指标文件目录
EVALUATE_PATH_PREFIX = LIBCITY_PATH + os.sep +'libcity' + os.sep + 'cache' + os.sep
EVALUATE_PATH_SUFFIX = os.sep + 'evaluate_cache' + os.sep
# run_model.py脚本文件位置
RUN_MODEL_PATH = 'run_model.py'
# 激活libcity库虚拟环境命令
ACTIVE_VENV = None
# libcity的log目录
LOG_PATH = LIBCITY_PATH + os.sep + 'libcity' + os.sep + 'log' + os.sep
# libcity的 任务-模型 对应关系配置信息目录
TASK_MODEL_PATH = LIBCITY_PATH + os.sep + 'libcity' + os.sep + 'config' + os.sep + 'model'

# 数据集文件上传路径
DATASET_PATH = LIBCITY_PATH + os.sep + 'raw_data' + os.sep
# 任务参数json文件上传路径
TASK_PARAM_PATH = LIBCITY_PATH + os.sep

# 样例文件相关
# 数据集样例文件
DATASET_EXAMPLE_PATH = '/home/houge/Bigscity-LibCity-WebTool/smartcityms_backend/sample/T_DRIVE_SMALL.zip'
TASK_PARAM_EXAMPLE_PATH = '/home/houge/Bigscity-LibCity-WebTool/smartcityms_backend/sample/config.json'
ADMIN_FRONT_HTML_PATH = "/home/houge/Bigscity-LibCity-WebTool/smartcityms_front/dist/"
