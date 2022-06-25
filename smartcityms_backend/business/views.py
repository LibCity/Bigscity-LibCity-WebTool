import datetime
import json
import os
import random
import shutil
import tempfile
import time
import zipfile
from string import Template
from urllib.parse import quote

from django.conf import settings
from django.core.files.uploadedfile import TemporaryUploadedFile
from django.db.models import Q
from django.http import FileResponse

# Create your views here.
from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema
from loguru import logger
from rest_framework import status
from rest_framework.decorators import action, renderer_classes
from rest_framework.mixins import CreateModelMixin, DestroyModelMixin, RetrieveModelMixin, ListModelMixin
from rest_framework.parsers import MultiPartParser, JSONParser
from rest_framework.response import Response
from rest_framework.viewsets import ModelViewSet, GenericViewSet

from business.enums import TaskStatusEnum, DatasetStatusEnum, TaskEnum
from business.filter import FileFilter, TaskFilter
from business.models import TrafficStatePredAndEta, MapMatching, TrajLocPred
from business.models import File, Task
from business.scheduler import task_execute_at, task_is_exists, remove_task
from business.serializers import TrafficStateEtaSerializer, MapMatchingSerializer, TrajLocPredSerializer
from business.serializers import FileSerializer, TaskSerializer, TaskListSerializer, FileListSerializer
from business.show.task_show import generate_result_map
from business.threads import ExecuteGeojsonThread, ExecuteGeoViewThread
from common import utils
from common.response import PassthroughRenderer
from common.utils import read_file_str, generate_download_file, str_is_empty


class FileViewSet(CreateModelMixin, DestroyModelMixin, RetrieveModelMixin, ListModelMixin, GenericViewSet):
    queryset = File.objects.all().order_by('-create_time')
    serializer_class = FileSerializer
    parser_classes = [MultiPartParser, JSONParser]
    filter_class = FileFilter

    def get_serializer_class(self):
        """
        根据查询的动作返回响应的序列化类
        """
        if self.action == 'list':
            return FileListSerializer
        else:
            return FileSerializer

    def create(self, request, *args, **kwargs):
        """
        新建数据集
        """
        serializer = self.get_serializer(data=request.data)
        is_public = request.data.get('isPublic', None)  # 数据集是否公开
        serializer.is_valid(raise_exception=True)
        # 有些zip当中存在其他类型文件（如.grid），需要核实
        atomic_file_ext = ['.geo', '.usr', '.rel', '.dyna', '.ext', '.json', '.grid', '.gridod', '.od']
        my_file = self.request.FILES.get('dataset', None)
        if not my_file:
            return Response(data={'detail': '未检测到文件！'}, status=status.HTTP_400_BAD_REQUEST)
        if 'zip' not in my_file.content_type:
            return Response(data={'detail': '请上传zip类型的文件！'}, status=status.HTTP_400_BAD_REQUEST)
        # 数据包文件格式检查
        zip_file = zipfile.ZipFile(my_file)
        zip_list = zip_file.namelist()
        for e in zip_list:
            file_name, ext = os.path.splitext(e)
            if (ext != "" or len(ext) != 0) and ext not in atomic_file_ext:
                return Response(data={'detail': '数据包中文件格式不正确，请上传原子文件'}, status=status.HTTP_400_BAD_REQUEST)
        self.is_public = is_public
        enable = self.perform_create(serializer)
        if not enable:
            return Response(status=status.HTTP_409_CONFLICT)
        headers = self.get_success_headers(serializer.data)
        return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)

    def perform_create(self, serializer):
        """
        数据集文件上传处理

        :return: 是否处理成功
        """
        start = time.time()
        my_file = self.request.FILES.get('dataset', None)
        logger.info('已接受到文件，正在进行处理，文件名: ' + my_file.name)
        path = settings.DATASET_PATH
        # 目录不存在则新建目录
        if not os.path.isdir(path):
            os.makedirs(path)
        file_size = my_file.size
        # 检验是否重复
        original_file_name, ext = os.path.splitext(my_file.name)
        original_file_name = str(self.request.user.id) + '_' + original_file_name
        enable, file_path = dataset_duplication_handle(original_file_name, ext, path)  # zip文件路径
        if not enable:
            return False
        # 没有重复，就求出解压目录 extract_path 的值
        path, file_name_and_ext = os.path.split(file_path)
        file_name, ext = os.path.splitext(file_name_and_ext)
        extract_path = os.path.join(path, file_name)  # 解压目录，解压到zip文件名下的文件夹目录
        zip_path = os.path.join(path, file_name_and_ext)  # zip文件路径
        # 创建解压目录
        if not os.path.isdir(extract_path):
            os.makedirs(extract_path)
        # 大文件就直接把临时文件 copy 到 raw_data_path
        if type(my_file) == TemporaryUploadedFile:
            temporary_file_path = my_file.file.name
            logger.info("存储到服务器上的临时文件路径：{} 正在把此文件复制到 raw_data 目录中：{}", temporary_file_path, zip_path)
            shutil.copyfile(temporary_file_path, file_path)
        else:
            # 对于小文件，直接在这处理了
            with open(os.path.join(path, file_name_and_ext), 'wb+') as f:
                for chunk in my_file.chunks():
                    f.write(chunk)
        account = self.request.user  # 上传的时候添加创建者
        is_public = 1 if self.is_public == 'true' else 0
        serializer.save(file_name=file_name, file_original_name=my_file.name, file_path=file_path, file_size=file_size, creator=account,
                        extract_path=extract_path, dataset_status=DatasetStatusEnum.CHECK.value,
                        visibility=is_public)
        logger.info('文件上传完毕，文件名: ' + file_name)
        # 创建一个空的html文件，后续可视化直接写入
        fp = open(settings.ADMIN_FRONT_HTML_PATH + file_name + ".html", "w+b")  # 打开一个文本文件
        fp.close()  # 关闭文件
        end = time.time()
        logger.info('上传文件初步处理运行时间: {} s；下面进行geojson文件的生成', end - start)
        # 启动执行任务线程，使用原子文件生成json
        ExecuteGeojsonThread(zip_path=zip_path, extract_path=extract_path, thread_name=file_name).start()
        return True

    def list(self, request, *args, **kwargs):
        """
        默认查询本人上传的数据集 或 公开的数据集
        """
        params_dict = self.request.query_params
        creator = params_dict.get('creator', None)
        visibility = params_dict.get('visibility', None)
        self.queryset = FileListSerializer.setup_eager_loading(self.queryset)
        # 默认行为：查询自己的上传的数据集 和 所有公开数据集
        # 只要不传 creator 参数的，一律认为是查询自己上传你的数据集 和 所有公开数据集
        if creator is None or creator == '':
            # 还有一种情况是只想查看公开的数据集
            if visibility is not None and visibility == '1':
                self.queryset = self.queryset.filter(visibility=1)
            else:
                self.queryset = self.queryset.filter(Q(creator=self.request.user) | Q(visibility=1))
        else:
            # 如果 creator 参数不为自己本人，默认添加 visibility = 1查询条件，因为想查别人的只能查公开数据集
            if int(creator) != self.request.user.id:
                self.queryset = self.queryset.filter(creator_id=creator, visibility=1)
            elif visibility is None or visibility == '' or visibility == '2':
                # 这里可以保证 creator 有值，且是本人
                self.queryset = self.queryset.filter(creator_id=creator)
            else:
                # 这里可以保证 creator 有值，且是本人 且 想要查询自己带可视条件的值
                self.queryset = self.queryset.filter(creator_id=creator, visibility=visibility)
        return super(FileViewSet, self).list(self, request, *args, **kwargs)

    @action(methods=['get'], detail=True)
    def generate_geo_json(self, *args, **kwargs):
        """
        传入dataset id, 生成 geojson 数据
        """
        dataset = self.get_object()
        ExecuteGeojsonThread(dataset.extract_path, dataset.file_name).start()
        return Response(status=status.HTTP_200_OK)

    @action(methods=['get'], detail=True)
    def update_visibility(self, request, *args, **kwargs):
        """
        根据 id 更新数据集权限状态 visibility
        """
        dataset = self.get_object()
        visibility = self.request.query_params['visibility']
        dataset.visibility = visibility
        dataset.save()
        return Response(status=status.HTTP_200_OK)

    @action(methods=['get'], detail=True)
    def delete(self, request, *args, **kwargs):
        return self.destroy(request, *args, **kwargs)

    def perform_destroy(self, instance):
        """
        执行删除数据集方法

        :param instance: 数据集文件对象实例
        """
        # 删除记录前先检查是否有实验正在使用此数据集，如果有就提示不能删除
        dataset = self.get_object()
        tasks = Task.objects.filter(dataset=dataset.file_name)
        if len(tasks) > 0:
            return False
        # 删除记录先删除对应文件
        if os.path.isfile(instance.file_path):
            os.remove(instance.file_path)
        if os.path.isdir(instance.extract_path):
            shutil.rmtree(instance.extract_path)
        if os.path.isdir(instance.extract_path + '_geo_json'):
            shutil.rmtree(instance.extract_path + '_geo_json')
        if os.path.isfile(settings.ADMIN_FRONT_HTML_PATH + instance.file_name + '.html'):
            os.remove(settings.ADMIN_FRONT_HTML_PATH + instance.file_name + '.html')
        instance.delete()
        return True

    def destroy(self, request, *args, **kwargs):
        """
        删除数据集接口
        """
        instance = self.get_object()
        result = self.perform_destroy(instance)
        if result:
            return Response(status=status.HTTP_204_NO_CONTENT)
        return Response(status=status.HTTP_400_BAD_REQUEST, data={'detail': '有实验正在使用此数据集，请删除实验后再删除数据集'})

    @renderer_classes((PassthroughRenderer,))
    @action(methods=['get'], detail=False)
    def download(self, request):
        """
        数据集样例文件下载
        """
        return generate_download_file(settings.DATASET_EXAMPLE_PATH)

    @renderer_classes((PassthroughRenderer,))
    @action(methods=['get'], detail=True)
    def download_by_id(self, request, *args, **kwargs):
        """
        根据数据集id下载数据集文件
        """
        dataset = self.get_object()
        return generate_download_file(dataset.file_path)

    @action(methods=['get'], detail=False, pagination_class=None)
    def get_all(self, request, *args, **kwargs):
        """
        查询所有数据集，不分页
        """
        return self.list(self, request, *args, **kwargs)

    @action(methods=['get'], detail=True)
    def get_gis_view(self, request, *args, **kwargs):
        """
        根据任务id获取geojson转化的gis图象地址
        """
        file = self.get_object()
        file_gis_path = str(file) + ".html"
        return file_gis_path

    @action(methods=['get'], detail=True)
    def generate_gis_view(self, request, *args, **kwargs):
        """
        根据任务id和背景图号生成geojson转化的gis图象或者使用原子文件生成描述性可视化
        """
        background_id = request.query_params.get('background')
        dataset = self.get_object()
        dataset.dataset_status = DatasetStatusEnum.PROCESSING.value
        # 设置background_id
        dataset.background_id = background_id
        dataset.save()
        # 启动执行任务线程，使用json生成folium的html展示页面
        ExecuteGeoViewThread(dataset.extract_path, dataset.file_name, background_id).start()
        return Response(status=status.HTTP_200_OK)

    @action(methods=['get'], detail=True)
    def get_file_status(self, request, *args, **kwargs):
        """
        前端轮询此接口，持续监控文件状态
        """
        dataset = self.get_object()
        cur_file_name = dataset.file_name
        original_file_name = dataset.file_original_name
        for file_name in settings.COMPLETED:
            if file_name == cur_file_name:
                # remove掉这一条记录
                settings.COMPLETED.remove(file_name)
                logger.debug('after remove completed: {}', settings.COMPLETED)
                res_data = {
                    "file_name": file_name,
                    "original_file_name": original_file_name,
                    'dataset_status': dataset.dataset_status
                }
                return Response(status=status.HTTP_200_OK, data=res_data)
        return Response(status=status.HTTP_202_ACCEPTED)


class TaskViewSet(ModelViewSet):
    queryset = Task.objects.all().order_by('-create_time')
    serializer_class = TaskSerializer
    filter_class = TaskFilter

    def get_serializer_class(self):
        """
        根据不同的请求操作使用不同的序列化类处理
        """
        if self.action == 'list':
            return TaskListSerializer
        else:
            return TaskSerializer

    def list(self, request, *args, **kwargs):
        """
        任务列表查询
        """
        params_dict = self.request.query_params
        creator = params_dict.get('creator', None)
        visibility = params_dict.get('visibility', None)
        self.queryset = TaskListSerializer.setup_eager_loading(self.queryset)
        # 默认行为：查询自己的上传的数据集 和 所有公开数据集
        # 只要不传 creator 参数的，一律认为是查询自己上传你的数据集 和 所有公开数据集
        if creator is None or creator == '':
            # 还有一种情况是只想查看公开的数据集
            if visibility is not None and visibility == '1':
                self.queryset = self.queryset.filter(visibility=1)
            else:
                self.queryset = self.queryset.filter(Q(creator=self.request.user) | Q(visibility=1))
        else:
            # 如果 creator 参数不为自己本人，默认添加 visibility = 1查询条件，因为想查别人的只能查公开数据集
            if int(creator) != self.request.user.id:
                self.queryset = self.queryset.filter(creator_id=creator, visibility=1)
            elif visibility is None or visibility == '' or visibility == '2':
                # 这里可以保证 creator 有值，且是本人
                self.queryset = self.queryset.filter(creator_id=creator)
            else:
                # 这里可以保证 creator 有值，且是本人 且 想要查询自己带可视条件的值
                self.queryset = self.queryset.filter(creator_id=creator, visibility=visibility)
        return super(TaskViewSet, self).list(self, request, *args, **kwargs)

    @action(methods=['get'], detail=True)
    def delete(self, request, *args, **kwargs):
        task = self.get_object()
        # 删除实验的时候把预约的实验也删了
        remove_task(str(task.id))
        return self.destroy(request, *args, **kwargs)

    @action(methods=['get'], detail=True)
    def test(self, *args, **kwargs):
        """
        测试接口，用于测试结果文件生成
        """
        generate_result_map(self.get_object())
        return Response(status=status.HTTP_200_OK)

    @action(methods=['get'], detail=True)
    def update_visibility(self, request, *args, **kwargs):
        """
        根据 id 更新数据集权限状态 visibility
        """
        task = self.get_object()
        visibility = self.request.query_params['visibility']
        task.visibility = visibility
        task.save()
        return Response(status=status.HTTP_200_OK)

    @action(methods=['get'], detail=True)
    def get_task_status(self, *args, **kwargs):
        """
        前端轮询此接口，返回任务状态
        """
        task = self.get_object()
        task_name = task.task_name
        cur_task_key = task.task_name + str(task.id)
        for task_key in settings.COMPLETED:
            if task_key == cur_task_key:
                # remove掉这一条记录
                settings.COMPLETED.remove(task_key)
                res_data = {
                    "task_name": task_name,
                    "task_status": task.task_status
                }
                return Response(status=status.HTTP_200_OK, data=res_data)
        return Response(status=status.HTTP_202_ACCEPTED)

    @action(methods=['get'], detail=True)
    def get_log(self, *args, **kwargs):
        """
        获取指定任务的运行日志
        1.正在执行（1），尝试读取log文件内容，返回
        2.执行出错（-1） or 已完成（2），读取executeMsg返回
        """
        task = self.get_object()
        if task.task_status == TaskStatusEnum.IN_PROGRESS.value:
            log_file = task.log_file_name
            if log_file is not None and os.path.isfile(log_file):
                log_content = read_file_str(log_file)
                return Response(log_content, status=status.HTTP_200_OK)
            else:
                return Response(data={'detail': '日志文件不存在！'}, status=status.HTTP_400_BAD_REQUEST)
        elif task.task_status == TaskStatusEnum.ERROR.value or task.task_status == TaskStatusEnum.COMPLETED.value:
            return Response(task.execute_msg, status=status.HTTP_200_OK)
        else:
            return Response(data={'detail': '任务未开始！'}, status=status.HTTP_400_BAD_REQUEST)

    @action(methods=['get'], detail=True)
    def get_config(self, *args, **kwargs):
        """
        获取指定任务的配置文件信息
        """
        task = self.get_object()
        config_content = read_file_str(task.config_file)
        return Response(config_content, status=status.HTTP_200_OK)

    @renderer_classes((PassthroughRenderer,))
    @action(methods=['get'], detail=True)
    def download_log(self, *args, **kwargs):
        """
        下载指定任务的日志文件
        """
        task = self.get_object()
        log_file = task.log_file_name
        logger.info('日志文件地址：{}', log_file)
        if log_file is not None and os.path.isfile(log_file):
            return generate_download_file(log_file)
        else:
            # 证明没有对应日志文件，直接生成文件返回
            file_obj = tempfile.NamedTemporaryFile()
            # 获取当前时间 yyyy-MM-dd hh:mm:ss
            now_time = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
            # 文件命名 实验号 + 实验名称 + 模型 + 数据集 + 时间
            file_obj.name = '{}_{}_{}_{}_{}.log'.format(task.exp_id, task.task_name, task.model, task.dataset, now_time)
            error_log_name = file_obj.name
            logger.info("生成的日志文件名：{}", error_log_name)
            if task.execute_msg is None:
                task.execute_msg = ''
            file_obj.write(task.execute_msg.encode('utf-8'))
            file_obj.seek(0)
            response_file = FileResponse(file_obj)
            response_file['content_type'] = "application/octet-stream"
            try:
                error_log_name.encode('ascii')
                file_expr = 'filename="{}"'.format(error_log_name)
            except UnicodeEncodeError:
                file_expr = "filename*=utf-8''{}".format(quote(error_log_name))
            response_file.headers['Content-Disposition'] = 'attachment; {}'.format(file_expr)
            return response_file

    @action(methods=['get'], detail=True)
    def execute(self, request, *args, **kwargs):
        """
        执行任务，需要传递execute_time参数为具体执行时间，如果不传参代表立即执行
        """
        execute_time = request.query_params.get('execute_time')
        task = self.get_object()
        # 检查任务是否可执行 未开始 和 错误 和 已选择预约时间 三种情况 可以继续往下走
        if task.task_status != TaskStatusEnum.NOT_STARTED.value and task.task_status != TaskStatusEnum.ERROR.value\
                and task.task_status != TaskStatusEnum.SELECTED_EXECUTE_TIME.value:
            return Response(data={'detail': '任务正在执行中或已完成，请勿重复执行！'}, status=status.HTTP_400_BAD_REQUEST)
        # 获取任务数据，组装命令
        task_param = ['task', 'model', 'dataset', 'config_file', 'saved_model', 'train', 'batch_size', 'train_rate',
                      'eval_rate', 'learning_rate', 'max_epoch', 'gpu', 'gpu_id']
        # 如果exp_id没传入，就随机生成
        if task.exp_id is None:
            task.exp_id = int(random.SystemRandom().random() * 100000)
            task.save()
        str_command = 'python ' + settings.RUN_MODEL_PATH + ' --exp_id ' + str(task.exp_id)
        for param in task_param:
            param_value = getattr(task, param)
            if param_value is not None:
                if param == 'config_file':
                    path, param_value = os.path.split(param_value)
                    param_value = os.path.splitext(param_value)[0]
                str_command += ' --' + param + ' ' + str(param_value)
        # 检查任务是否已经加入过队列中，如果已经存在，把之前的移除，以本次提交为准
        if task_is_exists(str(task.id)):
            remove_task(str(task.id))
        # 更新任务执行时间信息
        if execute_time:
            task.execute_time = execute_time
            task.task_status = TaskStatusEnum.SELECTED_EXECUTE_TIME.value
        else:
            task.execute_time = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime())
        # 如果是执行出错重新执行，需要把结束时间置空
        if task.task_status == TaskStatusEnum.ERROR.value or \
                task.task_status == TaskStatusEnum.SELECTED_EXECUTE_TIME.value:
            task.execute_end_time = None
        task.save()
        # 添加任务到执行队列中，不传execute_time就代表立即执行
        task_execute_at(task.task_name, str_command, execute_time, str(task.id))
        return Response(status=status.HTTP_200_OK)

    @action(methods=['get'], detail=True)
    def interrupt_exp(self, request, *args, **kwargs):
        """
        根据实验ID（task.id）中断实验
        """
        task = self.get_object()
        execute_cmd_obj = utils.exp_cmd_map.get(task.id, None)
        if execute_cmd_obj is None:
            return Response(status=status.HTTP_400_BAD_REQUEST)
        # 中断实验
        execute_cmd_obj.terminate = True
        return Response(status=status.HTTP_200_OK)

    @swagger_auto_schema(methods=['post'], request_body=openapi.Schema(
        type=openapi.TYPE_OBJECT,
        required=['task_name'],
        properties={'task_name': openapi.Schema(type=openapi.TYPE_STRING)}
    ))
    @action(methods=['post'], detail=False)
    def exists(self, request):
        """
        检测任务是否存在
        """
        task_name = request.data.get('task_name')
        tasks = Task.objects.filter(task_name=task_name).all()
        if len(tasks) == 0:
            return Response(status=status.HTTP_200_OK)
        else:
            return Response(data={'msg': '任务已存在！', 'id': tasks[0].id}, status=status.HTTP_400_BAD_REQUEST)

    @action(methods=['post'], detail=False)
    def upload(self, request):
        """
        任务配置文件上传，返回文件存储路径
        此配置文件应该放在AI项目根目录下，因为多任务，所以要根据配置文件名来区分
        """
        my_file = request.FILES.get('config', None)
        if not my_file:
            return Response(data={'detail': '未检测到文件！'}, status=status.HTTP_400_BAD_REQUEST)
        path = settings.TASK_PARAM_PATH
        # 目录不存在则新建目录
        if not os.path.isdir(path):
            os.makedirs(path)
        original_file_name, ext = os.path.splitext(my_file.name)
        file_path = file_duplication_handle(original_file_name, ext, path, 1)
        path, file_name_and_ext = os.path.split(file_path)
        with open(os.path.join(path, file_name_and_ext), 'wb+') as f:
            for chunk in my_file.chunks():
                f.write(chunk)
        # 返回文件存储路径
        return Response(file_path)

    def perform_create(self, serializer):
        """
        创建任务时添加任务创建者
        """
        account = self.request.user
        serializer.save(creator=account)

    @renderer_classes((PassthroughRenderer,))
    @action(methods=['get'], detail=False)
    def download_config(self, request):
        """
        参数配置文件样例文件下载
        """
        return generate_download_file(settings.TASK_PARAM_EXAMPLE_PATH)

    @renderer_classes((PassthroughRenderer,))
    @action(methods=['get'], detail=True)
    def download_task_config(self, request, *args, **kwargs):
        """
        指定任务配置文件下载
        """
        task = self.get_object()
        return generate_download_file(task.config_file)

    @renderer_classes((PassthroughRenderer,))
    @action(methods=['get'], detail=True)
    def download_task_model(self, request, *args, **kwargs):
        """
        下载任务模型
        """
        # 找到模型位置路径在exp_id / model_cache / *.m
        # 模型名称 model_dataset.m
        task = self.get_object()
        file_dir = settings.EVALUATE_PATH_PREFIX + str(task.exp_id) + os.sep + 'model_cache' + os.sep
        model_name = task.model + '_' + task.dataset + '.m'
        file_list = os.listdir(file_dir)
        model_file_path = None
        for file in file_list:
            if file == model_name:
                model_file_path = file_dir + file
        if model_file_path:
            return generate_download_file(model_file_path)
        return Response(status=status.HTTP_404_NOT_FOUND)

    @action(methods=['get'], detail=True)
    def get_result(self, request, *args, **kwargs):
        """
        根据任务id获取结果
        """
        task = self.get_object()
        # 变更任务状态
        if task.task_status != 2:
            return Response(data={'detail': '任务尚未输出结果'}, status=status.HTTP_400_BAD_REQUEST)
        file_id = task.pk  # wheather pk or exp_id
        file_path = settings.RESULT_PATH + str(file_id)
        return Response(file_path)

    @action(methods=['get'], detail=False)
    def get_task_model_dict(self, request, *args, **kwargs):
        src_path = settings.TASK_MODEL_PATH
        task_list = os.listdir(src_path)
        result_dict = {}
        # 遍历 task_list
        for task in task_list:
            cur_list = list(map(lambda x: os.path.splitext(x)[0], os.listdir(src_path + os.sep + task)))
            result_dict[task] = cur_list
        return Response(data=result_dict, status=status.HTTP_200_OK)


class TrafficStateEtaViewSet(ModelViewSet):
    """
    交通状态预测任务和到达时间估计任务评价指标查询
    """
    queryset = TrafficStatePredAndEta.objects.all()
    serializer_class = TrafficStateEtaSerializer
    filterset_fields = ['task']

    @action(methods=['get'], detail=False)
    def get_evaluate_mode(self, request, *args, **kwargs):
        """
        获取评估指标的模式

        :return: average or single
        """
        # 优先解析配置文件
        task_id = request.query_params.get('task')
        logger.info("param task id: " + task_id)
        task = Task.objects.get(id=task_id)
        config_file = task.config_file
        if config_file is not None:
            logger.info("evaluate config json file path: " + config_file)
            with open(config_file, 'r', encoding='UTF-8') as f:
                json_dict = json.load(f)
            for key in json_dict:
                if key == "mode":
                    res_data = {
                        "mode": json_dict[key]
                    }
                    return Response(data=res_data, status=status.HTTP_200_OK)
        else:
            logger.info("Evaluate no configuration json")
        # 解析默认json评估模式
        default_evaluate_config = settings.LIBCITY_PATH + os.sep + "libcity" + os.sep + "config" + os.sep + "evaluator" \
                                  + os.sep + "TrafficStateEvaluator.json"
        with open(default_evaluate_config, 'r', encoding='UTF-8') as f:
            json_dict = json.load(f)
        for key in json_dict:
            if key == "evaluator_mode":
                res_data = {
                    "mode": json_dict[key]
                }
                return Response(data=res_data, status=status.HTTP_200_OK)
        return Response(status=status.HTTP_200_OK)

    @action(methods=['get'], detail=False)
    def other_contrast_line(self, request, *args, **kwargs):
        """
        轨迹下一跳，到达时间估计，路网匹配 折线图数据返回

        :param request: task: 需要对比的任务的id的字符串，不同任务id之间以逗号分隔，如：1,2,3 taskType: 任务类型
        """
        task_ids = request.query_params.get('task')
        task_type = request.query_params.get('taskType')
        tasks = None
        evaluates = None
        if task_ids and task_type:
            task_ids = task_ids.split(',')
            tasks = Task.objects.filter(id__in=task_ids).all()
            # 根据不同的任务类型，查询不同的评价指标表
            if task_type == TaskEnum.TRAJ_LOC_PRED.value:
                # 轨迹下一跳
                evaluates = TrajLocPred.objects.filter(task_id__in=task_ids).all()
            elif task_type == TaskEnum.ETA.value:
                # 到达时间估计
                evaluates = TrafficStatePredAndEta.objects.filter(task_id__in=task_ids).all()
            elif task_type == TaskEnum.MAP_MATCHING.value:
                # 路网匹配
                evaluates = MapMatching.objects.filter(task_id__in=task_ids).all()
            else:
                return Response(status=status.HTTP_400_BAD_REQUEST)
            # 这个字典存储模型和模型对应的指标对象
            model_evaluate = {}
            if tasks is not None and evaluates is not None:
                # 根据task的模型名分组
                for task in tasks:
                    key = task.model + '-' + task.task_name
                    model_evaluate[key] = []
                    # 此处evaluates长度为1，就一条数据
                    for evaluate in evaluates:
                        if evaluate.task_id == task.id:
                            model_evaluate[key] = evaluate
            # x轴数据，以模型为x轴
            xdata = list(model_evaluate.keys())
            # 响应结果数据
            result_data = []
            count = 0
            # 构造每个折线图的折线图数据
            for evaluate_name in evaluates[0].__dict__:
                is_inf = False
                if evaluates[0].__dict__.get(evaluate_name) is None or evaluates[0].__dict__.get(evaluate_name) == '' \
                        or evaluate_name == '_state' or evaluate_name == 'id' or evaluate_name == 'task_id':
                    continue
                tmp_data = {'id': str(count), 'evaluate_name': evaluate_name, 'xdata': [], 'data': []}
                # 添加折线图数据
                # line_data = {'type': 'line', 'data': []}
                # 添加柱形图数据 默认只加柱形图数据
                bar_data = {'type': 'bar', 'data': [], 'barWidth': '20%'}
                for x in xdata:
                    evaluate = model_evaluate.get(x)
                    value = evaluate.__dict__.get(evaluate_name)
                    if value == 'inf':
                        is_inf = True
                        break
                    if str_is_empty(value):
                        break
                    # line_data['data'].append(value)
                    tmp_data['xdata'].append(x)
                    bar_data['data'].append(value)
                # tmp_data['data'].append(line_data)
                tmp_data['data'].append(bar_data)
                if not is_inf:
                    result_data.append(tmp_data)  # 只加入不存在inf值的tmp_data
                count = count + 1
            return Response(data=result_data, status=status.HTTP_200_OK)
        # 不同指标查不同的sql
        return Response(status=status.HTTP_200_OK)
        # result_data = [{
        #     "id": "1",
        #     "evaluate_name": "召回率",
        #     "xdata": ['GRU', 'RNN'],
        #     "data": [
        #         {
        #             "type": 'bar',
        #             "data": [10, 90],
        #             "barWidth": '20%'
        #         }
        #     ]
        # }]
        # return Response(data=result_data, status=status.HTTP_200_OK)

    @action(methods=['get'], detail=False)
    def contrast_line(self, request, *args, **kwargs):
        """
        交通状态预测，折线图数据

        :param request: task: 需要对比的任务的id的字符串，不同任务id之间以逗号分隔，如：1,2,3
        :return: 是每个指标的折线图数据的list
        """
        task_ids = request.query_params.get('task')
        if task_ids:
            task_ids = task_ids.split(',')
            tasks = Task.objects.filter(id__in=task_ids).all()
            evaluates = TrafficStatePredAndEta.objects.filter(task_id__in=task_ids).all()
            task_evaluates = {}
            # 根据task的模型名分组 key：模型名 value：指标list
            for task in tasks:
                key = task.model + '-' + task.task_name
                task_evaluates[key] = []
                for evaluate in evaluates:
                    if evaluate.task_id == task.id:
                        task_evaluates[key].append(evaluate)
            # 获取所有模型名list
            legend = list(task_evaluates.keys())
            # 构造xdata
            xdata = []
            for i in range(1, len(task_evaluates.get(tasks[0].model + '-' + tasks[0].task_name)) + 1):
                xdata.append(i)
            # 响应结果数据
            result_data = []
            count = 0
            # 构造每个指标的折线图数据
            for evaluate_name in evaluates[0].__dict__:
                is_inf = False
                if evaluate_name == '_state' or evaluate_name == 'id' or evaluate_name == 'task_id':
                    continue
                tmp_data = {'id': str(count), 'evaluate_name': evaluate_name, 'legend': [], 'xdata': xdata,
                            'data': []}
                for task_model in task_evaluates:
                    model_is_null = False
                    model_data = {'name': task_model, 'type': 'line', 'data': []}
                    for evaluate in task_evaluates.get(task_model):
                        # 存在inf值的数据不做返回展示，就不要这个tmp_data了
                        if evaluate.__dict__.get(evaluate_name) == 'inf':
                            is_inf = True
                            break
                        # 获取具体指标值，为空的不参加比较，就不要这个model_data了
                        if str_is_empty(evaluate.__dict__.get(evaluate_name)):
                            model_is_null = True
                            break
                        model_data['data'].append(evaluate.__dict__.get(evaluate_name))
                    if not model_is_null:
                        tmp_data['data'].append(model_data)
                if not is_inf:
                    # 整理tmp_data的legend
                    for item in tmp_data['data']:
                        tmp_data['legend'].append(item['name'])
                    # 如果发现legend为空，就代表这个指标下，所有模型都没有数据，所以也就没必要展示了
                    if not tmp_data['legend'] == []:
                        result_data.append(tmp_data)  # 只加入不存在inf值的tmp_data
                count = count + 1
            return Response(data=result_data, status=status.HTTP_200_OK)
        else:
            return Response(status=status.HTTP_400_BAD_REQUEST)
        # 返回的是tmp_data的list，一个指标对应一个tmp_data
        # tmp_data = {
        #     "evaluate_name": "召回率",
        #     "legend": ['GRU', 'RNN'],
        #     "xdata": [1, 3, 5, 6, 8],
        #     "data": [
        #         {
        #             "name": 'GRU',
        #             "type": 'line',
        #             "data": [10, 90, 60, 30, 50]
        #         },
        #         {
        #             "name": 'RNN',
        #             "type": 'line',
        #             "data": [80, 30, 20, 30, 50]
        #         }
        #     ]
        # }
        # return Response(data=result_data, status=status.HTTP_200_OK)

    @renderer_classes((PassthroughRenderer,))
    @action(methods=['get'], detail=False)
    def download(self, request, *args, **kwargs):
        """
        指定任务指定指标文件下载
        指标文件名匹配规则：evaluate_template = Template("${task_id}_${model}_${dataset}.${suffix}")
        """
        task_id = request.query_params.get('task')
        task = Task.objects.get(id=task_id)
        evaluate_template = Template("${task_id}_${model}_${dataset}")
        evaluate_name = evaluate_template.safe_substitute(task_id=task.id, model=task.model,
                                                          dataset=task.dataset)
        # 根据id找到对应指标文件
        # 数据准备
        file_dir = settings.EVALUATE_PATH_PREFIX + str(task.exp_id) + settings.EVALUATE_PATH_SUFFIX
        logger.info('指标文件夹路径：{}', file_dir)
        if os.path.isdir(file_dir):
            # 扫描文件夹下所有文件
            file_list = os.listdir(file_dir)
            for file in file_list:
                logger.info('os.path.splitext(file)[0]: {} and evaluate_name: {}',
                            os.path.splitext(file)[0], evaluate_name)
                if os.path.splitext(file)[0] == evaluate_name:
                    file_path = file_dir + file
                    return generate_download_file(file_path)
        return Response(data={'detail': '指标文件不存在！'}, status=status.HTTP_400_BAD_REQUEST)


class MapMatchingViewSet(ModelViewSet):
    """
    路网匹配评价指标
    """
    queryset = MapMatching.objects.all()
    serializer_class = MapMatchingSerializer
    filterset_fields = ['task']


class TrajLocPredViewSet(ModelViewSet):
    """
    轨迹下一跳评价指标
    """
    queryset = TrajLocPred.objects.all()
    serializer_class = TrajLocPredSerializer
    filterset_fields = ['task']


def file_duplication_handle(original_file_name, ext, path, index):
    """
    检测文件名是否重复，若重复则将文件名加(index)后缀
    """
    file_path = path + original_file_name + ext
    if os.path.isfile(file_path):
        tmp_file_name = original_file_name + '(' + str(index) + ')'
        file_path = path + tmp_file_name + ext
        if os.path.isfile(file_path):
            return file_duplication_handle(original_file_name, ext, path, index + 1)
        else:
            return file_path
    else:
        return file_path


def dataset_duplication_handle(original_file_name, ext, path):
    """
    数据集文件名重复处理策略

    :param original_file_name: 原始文件名
    :param ext: 文件后缀
    :param path: raw path 路径
    :return: 返回是否可用（boolean）和文件路径
    """
    file_path = path + original_file_name + ext
    if os.path.isfile(file_path):
        logger.info("文件重复，文件路径：{}", file_path)
        return False, file_path
    else:
        return True, file_path
