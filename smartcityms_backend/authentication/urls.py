from django.urls import path, include
from rest_framework import routers

from authentication import views

router = routers.DefaultRouter()
router.register('account', views.AccountViewSet)
router.register('role', views.RoleViewSet)
router.register('permission', views.PermissionViewSet)

urlpatterns = [
    path('', include(router.urls)),
]
