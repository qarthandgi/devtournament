from rest_framework import serializers

from .models import UserExercise


class UserExerciseSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserExercise
        fields = ('id', 'name', 'db', 'objective', 'column_descriptions', 'added')

