from rest_framework import serializers

from .models import CompanyExercise, UserExercise, Invitation, User, SuccessfulCompanyAttempt

import pickle
from pprint import pprint


class CompanyExerciseSerializer(serializers.ModelSerializer):
    expected_output = serializers.SerializerMethodField()
    last_successful_completion = serializers.SerializerMethodField()

    def get_expected_output(self, exercise):
        headers = pickle.loads(exercise.expected_headers)
        rows = pickle.loads(exercise.expected_rows)
        output = {
          'headers': headers,
          'rows': rows
        }
        return output

    def get_last_successful_completion(self, exercise):
        user = self.context['request'].user
        if user.is_anonymous:
            print('user anonymous')
            return False
        try:
            print('in try')
            print(user.email)
            print(exercise)
            success_attempt = SuccessfulCompanyAttempt.objects.get(user=user, exercise=exercise)
            print(success_attempt.time)
            return success_attempt.time
        except SuccessfulCompanyAttempt.DoesNotExist:
            return False

    class Meta:
        model = CompanyExercise
        fields = ('id', 'name', 'db', 'objective', 'column_descriptions', 'added', 'expected_output',
                  'difficulty', 'needed_subscription', 'position', 'last_successful_completion')


class InviteExerciseSerializer(serializers.ModelSerializer):
    expected_output = serializers.SerializerMethodField()

    def get_expected_output(self, exercise):
        headers = pickle.loads(exercise.expected_headers)
        rows = pickle.loads(exercise.expected_rows)
        output = {
          'headers': headers,
          'rows': rows
        }
        return output

    class Meta:
        model = UserExercise
        fields = ('id', 'name', 'db', 'objective', 'column_descriptions', 'added', 'expected_output')


class InviterSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('email', )


class InvitationSerializer(serializers.ModelSerializer):
    exercise = InviteExerciseSerializer(read_only=True)
    inviter = InviterSerializer(read_only=True)

    class Meta:
        model = Invitation
        fields = ('id', 'inviter', 'created', 'status', 'enabled', 'exercise')


class InvitationForExerciseSerializer(serializers.ModelSerializer):

    class Meta:
        model = Invitation
        fields = ('id', 'invitee_s', 'created', 'status', 'enabled')


class CustomExerciseSerializer(serializers.ModelSerializer):
    invitation_set = serializers.SerializerMethodField()
    expected_output = serializers.SerializerMethodField()

    def get_expected_output(self, exercise):
        headers = pickle.loads(exercise.expected_headers)
        rows = pickle.loads(exercise.expected_rows)
        output = {
          'headers': headers,
          'rows': rows
        }
        return output

    def get_invitation_set(self, exercise):
        inv_set = Invitation.objects.filter(exercise=exercise, archived=False)
        serializer = InvitationForExerciseSerializer(instance=inv_set, many=True, read_only=True)
        return serializer.data

    class Meta:
        model = UserExercise
        fields = ('id', 'name', 'db', 'objective', 'column_descriptions', 'added', 'working_query',
                  'expected_output', 'invitation_set')
