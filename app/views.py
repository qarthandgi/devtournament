from django.shortcuts import render
from django.db import connections

from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated, IsAdminUser, AllowAny

from .models import User, Database, CompanyExercise, UserExercise, Invitation
from .serializers import CustomExerciseSerializer, InvitationSerializer, InvitationForExerciseSerializer

from pprint import pprint
import pickle


# Create your views here.
def index(request):
    return render(request, 'index.html')


def execute_sql(db, sql):
    with connections[db.internal_name].cursor() as cursor:
        cursor.execute(sql)
        rows = cursor.fetchall()
        columns = []
        headers = [x[0] for x in cursor.description]
        duplicate_header_names = len(headers) > len(set(headers))
        for i, col in enumerate(cursor.description):
            col_data = list(map(lambda x: x[i], rows))
            col = {col[0]: col_data}
            columns.append(col)

    data = {
      'rows': rows,
      'headers': headers,
      'duplicates': duplicate_header_names
    }

    return data


# TODO: this shouldn't be AllowAny
# @permission_classes((AllowAny,))
@api_view()
def profile_data(request):
    u = User.objects.get(pk=3)
    dbs = Database.objects.all_for_user(u)
    pprint(dbs)
    return Response({'databases': dbs})
    # return Response({'first_name': request.user.first_name, 'last_name': request.user.last_name,
    #                  'email': request.user.email})


@api_view()
@permission_classes((AllowAny,))
def load_postgres(request):
    dbs = Database.objects.all_for_user(request.user)
    custom_exercises = load_custom_exercises(request.user) if request.user.is_authenticated else None
    invitations = load_invitations(request.user) if request.user.is_authenticated else None

    resp = {
        'databases': dbs,
    }
    if custom_exercises is not None:
        resp['custom_exercises'] = custom_exercises
    if invitations is not None:
        resp['invitations'] = invitations
    return Response(resp)


@permission_classes((IsAuthenticated,))
def load_custom_exercises(user):
    exercises = UserExercise.objects.filter(author=user)
    serializer = CustomExerciseSerializer(exercises, many=True)

    return serializer.data


@permission_classes((IsAuthenticated,))
def load_invitations(user):
    invitations = Invitation.objects.filter(invitee=user, archived=False).exclude(status='declined')
    serializer = InvitationSerializer(invitations, many=True)

    pprint(serializer.data)

    return serializer.data


@api_view(['POST'])
@permission_classes((AllowAny,))
def test_query(request):
    db_id = request.data['db']
    db = Database.objects.get(pk=db_id)
    data = execute_sql(db, request.data['sql'])

    resp = {
      'rows': data['rows'],
      'headers': data['headers'],
      'db_id': db_id,
      'duplicates': data['duplicates']
    }
    return Response(data=resp, status=200)


@api_view(['POST'])
@permission_classes((IsAuthenticated,))
def create_exercise(request):
    name = request.data['name']
    db_id = request.data['database']
    objective = request.data['objective']
    sql = request.data['sql']

    db = Database.objects.get(pk=db_id)
    data = execute_sql(db, sql)

    expected_headers = pickle.dumps(data['headers'])
    expected_rows = pickle.dumps(data['rows'])

    ue = UserExercise(
      name=name,
      db=db,
      author=request.user,
      objective=objective,
      working_query=sql,
      expected_headers=expected_headers,
      expected_rows=expected_rows,
      column_descriptions=request.data['columnDescriptions']
    )
    ue.save()

    return Response(status=200)


@api_view(['POST'])
@permission_classes((IsAuthenticated,))
def invite_user(request):
    custom_exercise_id = request.data['customExerciseId']
    email = request.data['email']

    custom_exercise = UserExercise.objects.get(pk=custom_exercise_id)

    inv = Invitation(
      inviter=request.user,
      exercise=custom_exercise,
      invitee_s=email
    )

    try:
        u = User.objects.get(email=email)
        inv.invitee = u
    except User.DoesNotExist:
        inv.assigned_to_invitee = False

    inv.save()

    return Response(status=200)


@api_view(['POST'])
@permission_classes((IsAuthenticated,))
def enable_invitation(request):
    invitation_id = request.data['invitationId']

    inv = Invitation.objects.get(pk=invitation_id)
    inv.enabled = True
    inv.save()

    serializer = InvitationForExerciseSerializer(inv)

    return Response(data=serializer.data, status=200)


@api_view(['POST'])
@permission_classes((IsAuthenticated,))
def disable_invitation(request):
    invitation_id = request.data['invitationId']

    inv = Invitation.objects.get(pk=invitation_id)
    inv.enabled = False
    inv.save()

    serializer = InvitationForExerciseSerializer(inv)

    return Response(data=serializer.data, status=200)


@api_view(['POST'])
@permission_classes((IsAuthenticated,))
def delete_invitation(request):
    invitation_id = request.data['invitationId']

    inv = Invitation.objects.get(pk=invitation_id)
    inv.archived = True
    inv.save()

    return Response(status=200)


@api_view(['POST'])
@permission_classes((IsAuthenticated,))
def rsvp_invitation(request):
    accepted = request.data['accepted']
    invitation_id = request.data['invitationId']

    inv = Invitation.objects.get(pk=invitation_id)
    if accepted:
        inv.status = 'accepted'
        inv.save()
        serializer = InvitationSerializer(inv)
        return Response(data=serializer.data, status=200)
    else:
        inv.status = 'declined'
        inv.save()
        return Response(status=200)
