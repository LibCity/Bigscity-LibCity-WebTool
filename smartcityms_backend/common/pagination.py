from rest_framework.pagination import PageNumberPagination


# 分页
class CustomizePagination(PageNumberPagination):
    """
    自定义分页类
    默认page_size已经在setting中设置，为10
    查询参数为page和size
    """
    # 查询参数，URL 中的过滤参数，在url后加 ?page=1&size=2，意思就是找第一页数据，每页两条
    page_query_param = 'page'
    page_size_query_param = 'size'
