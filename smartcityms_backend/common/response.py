from rest_framework import renderers
from rest_framework.renderers import JSONRenderer


class BaseResponse(object):
    """
    封装的返回信息类
    """

    def __init__(self):
        self.code = 200
        self.data = None
        self.msg = None

    @property
    def dict(self):
        return self.__dict__


class PassthroughRenderer(renderers.BaseRenderer):
    """
    文件下载响应渲染
    """
    media_type = ''
    format = ''

    def render(self, data, accepted_media_type=None, renderer_context=None):
        return data


class FitJSONRenderer(JSONRenderer):
    """
    返回结果封装
    """

    def render(self, data, accepted_media_type=None, renderer_context=None):
        """
        :param data:
        :param accepted_media_type:
        :param renderer_context:
        :return: {"code":200,"data":"X","msg":"X"}
        """
        response_body = BaseResponse()
        response = renderer_context.get("response")
        response_body.code = response.status_code
        # 响应异常
        if response_body.code >= 400:
            # 异常信息放入msg
            if isinstance(data, dict):
                response_body.msg = data.get('detail', data)
        else:
            response_body.data = data
            response_body.msg = '成功'
        # 统一成200响应,用code区分
        renderer_context.get("response").status_code = 200
        return super(FitJSONRenderer, self).render(response_body.dict, accepted_media_type, renderer_context)
