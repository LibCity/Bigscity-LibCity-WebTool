from rest_framework import serializers

import common.utils
from business.models import File, Task, TrafficStatePredAndEta, MapMatching, TrajLocPred


class FileSerializer(serializers.ModelSerializer):
    class Meta:
        model = File
        fields = '__all__'


class FileListSerializer(serializers.ModelSerializer):
    creator = serializers.StringRelatedField()

    class Meta:
        model = File
        fields = '__all__'

    @staticmethod
    def setup_eager_loading(queryset):
        """ Perform necessary eager loading of data. """
        queryset = queryset.prefetch_related('creator')
        return queryset

    def to_representation(self, instance):
        data = super(FileListSerializer, self).to_representation(instance)
        # 取出要进行处理的字段
        data['file_size'] = common.utils.pybyte(data['file_size'])
        return data


class TaskSerializer(serializers.ModelSerializer):
    class Meta:
        model = Task
        fields = '__all__'


class TaskListSerializer(serializers.ModelSerializer):
    creator = serializers.StringRelatedField()

    @staticmethod
    def setup_eager_loading(queryset):
        """ Perform necessary eager loading of data. """
        queryset = queryset.prefetch_related('creator')
        return queryset

    class Meta:
        model = Task
        fields = '__all__'


class TrafficStateEtaSerializer(serializers.ModelSerializer):
    class Meta:
        model = TrafficStatePredAndEta
        fields = '__all__'


class MapMatchingSerializer(serializers.ModelSerializer):
    class Meta:
        model = MapMatching
        fields = '__all__'


class TrajLocPredSerializer(serializers.ModelSerializer):
    class Meta:
        model = TrajLocPred
        fields = '__all__'