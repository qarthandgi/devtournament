from rest_framework import serializers

from .models import UserExercise


class CustomExerciseSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserExercise
        fields = ('id', 'name', 'db', 'objective', 'column_descriptions', 'added', 'working_query')


class InviteExerciseSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserExercise
        fields = ('id', 'name', 'db', 'objective', 'column_descriptions', 'added')
