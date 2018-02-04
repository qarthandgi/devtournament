from django.shortcuts import render
from django.db import connections
from django.utils import timezone
from django.views.decorators.csrf import csrf_exempt

from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated, IsAdminUser, AllowAny

from .models import User, Database, CompanyExercise, UserExercise, Invitation, IN_PROGRESS, SUCCESSFULLY_COMPLETED
from .models import SuccessfulCompanyAttempt, Global, SubscriptionChange
from .serializers import CompanyExerciseSerializer, CustomExerciseSerializer, InvitationSerializer, InvitationForExerciseSerializer

from pprint import pprint
import pickle
from decimal import Decimal

import stripe
from private.private import config


# Create your views here.
def index(request):
    return render(request, 'index.html')


def execute_sql(db, sql):
    with connections[db.internal_name].cursor() as cursor:
        cursor.execute(sql)
        rows = cursor.fetchall()
        print('OK EXECUTE SQL')
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


def compare_1d(stored, attempt):
    if len(stored) != len(attempt):
        return False

    for i, item in enumerate(stored):
        if attempt[i] != item:
            return False

    return True


def compare_2d(stored, attempt):
    if len(stored) != len(attempt):
        return False

    for i, arr in enumerate(stored):
        if len(arr) != len(attempt[i]):
            return False
        for j, item in enumerate(arr):
            if attempt[i][j] != item:
                return False

    return True


def compare_query_results(data, exercise):
    expected_headers = pickle.loads(exercise.expected_headers)
    expected_rows = pickle.loads(exercise.expected_rows)

    queried_headers = data['headers']
    queried_rows = data['rows']

    headers_match = compare_1d(expected_headers, queried_headers)
    rows_match = compare_2d(expected_rows, queried_rows)

    all_match = headers_match and rows_match

    return all_match


@csrf_exempt
@api_view(['POST'])
@permission_classes((IsAuthenticated,))
def to_premium(request):
    user = User.objects.get(pk=request.user.id)
    create_source = request.data['createSource']

    if create_source:
        stripe_source = request.data['stripeSource']
        stripe_customer_id = user.stripe_customer_id
        stripe_customer = stripe.Customer.retrieve(stripe_customer_id)
        stripe_customer.sources.create(source=stripe_source)
        stripe_customer.default_source = stripe_source
        stripe_customer.save()
        user.stripe_default_source_id = stripe_source

    subscription = stripe.Subscription.retrieve(user.stripe_subscription_id)
    modified_subscription = stripe.Subscription.modify(user.stripe_subscription_id,
                               items=[{
                                 'id': subscription['items']['data'][0].id,
                                 'plan': 'premium-subscription'
                               }])
    pprint(modified_subscription)
    user.stripe_current_period_start = modified_subscription['current_period_start']
    user.stripe_current_period_end = modified_subscription['current_period_end']
    user.subscription = 'premium'
    user.save()

    return Response({'details': 'ok', 'current_period_end': str(user.stripe_current_period_end)})


@api_view(['POST'])
@permission_classes((IsAuthenticated,))
def downgrade_plan(request):
    sc = SubscriptionChange(user=request.user, going_to='basic')
    sc.save()
    user = User.objects.get(pk=request.user.id)
    user.slated_for_downgrade = True
    user.save()

    return Response({'details': 'ok'})


@api_view(['POST'])
@permission_classes((IsAuthenticated,))
def change_subscription(request):
    user = User.objects.get(pk=request.user)
    new_subscription = request.data['newSubscription']

    subscription = stripe.Subscription.retrieve(user.stripe_subscription_id)
    if new_subscription == 'premium':
        token = request.data['stripeToken']
        stripe.Subscription.modify(user.stripe_subscription_id,
                                   items=[{
                                     'id': subscription['items']['data'][0].id,
                                     'plan': 'premium-subscription'
                                   }])
        user.subscription = 'premium'
    elif new_subscription == 'basic':
        stripe.Subscription.modify(user.stripe_subscription_id,
                                   items=[{
                                     'id': subscription['items']['data'][0].id,
                                     'plan': 'basic-subscription'
                                   }])
        user.subscription = 'basic'
    user.save()

    return Response({'details': 'ok'})


@api_view()
@permission_classes((IsAuthenticated,))
def user_details(request):
    resp = {
      'subscription': request.user.subscription,
      'setup': request.user.setup,
      'current_period_end': request.user.stripe_current_period_end,
      'slated_for_downgrade': request.user.slated_for_downgrade
    }
    return Response(resp)


@api_view(['GET'])
@permission_classes((IsAuthenticated,))
def user_logged_in(request):
    print('in user logged in!!!')
    first_time = False
    u = request.user
    if not u.setup:
        print('about to setup')
        customer = stripe.Customer.create(
          email=u.email
        )
        print('CUSTOMER RESPONSE STRIPE')
        pprint(customer)
        u.stripe_customer_id = customer.id

        subscription = stripe.Subscription.create(
          customer=customer.id,
          items=[{'plan': 'basic-subscription'}]
        )
        u.stripe_subscription_id = subscription.id
        print('SUBSCRIPTION RESPONSE STRIPE')
        pprint(subscription)
        u.stripe_current_period_start = subscription['current_period_start']
        u.stripe_current_period_end = subscription['current_period_end']
        u.setup = True
        u.save()
        first_time = True

    return Response({'details': 'ok', 'first_time': first_time})


# TODO: this shouldn't be AllowAny
# @permission_classes((AllowAny,))
@api_view()
def profile_data(request):
    u = User.objects.get(pk=3)
    dbs = Database.objects.all_for_user(u)
    return Response({'databases': dbs})
    # return Response({'first_name': request.user.first_name, 'last_name': request.user.last_name,
    #                  'email': request.user.email})


@api_view()
@permission_classes((AllowAny,))
def load_postgres(request):
    dbs = Database.objects.all_for_user(request.user)
    custom_exercises = load_custom_exercises(request.user) if request.user.is_authenticated else None
    invitations = load_invitations(request.user) if request.user.is_authenticated else None

    exercises = CompanyExercise.objects.filter(enabled=True)
    company_serializer = CompanyExerciseSerializer(exercises, many=True, context={'request': request})

    resp = {
      'databases': dbs,
      'exercises': company_serializer.data,
      'premium_exercises': Global.objects.get(name='premium_exercises').int_value,
      'non_premium_exercises': Global.objects.get(name='non_premium_exercises').int_value
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

    return serializer.data


def check_datatypes(data):
    new_data = []
    for i, row in enumerate(data):
        new_data.append([])
        for j, item in enumerate(row):
            if isinstance(item, Decimal):
                print(new_data)
                print(i, j)
                new_data[i].append(str(item))
            else:
                new_data[i].append(item)

    return new_data


@api_view(['POST'])
@permission_classes((AllowAny,))
def sandbox_test_query(request):
    db_id = request.data['db']
    sql = request.data['sql']
    db = Database.objects.get(pk=db_id)
    data = execute_sql(db, sql)

    resp = {
      'rows': check_datatypes(data['rows']),
      'headers': data['headers'],
    }

    return Response(data=resp, status=200)


@api_view(['POST'])
@permission_classes((AllowAny,))
def custom_test_query(request):
    db_id = request.data['db']
    sql = request.data['sql']
    db = Database.objects.get(pk=db_id)
    data = execute_sql(db, sql)

    resp = {
      'rows': data['rows'],
      'headers': data['headers'],
      'db_id': db_id,
      'duplicates': data['duplicates']
    }

    return Response(data=resp, status=200)


@api_view(['POST'])
@permission_classes((AllowAny,))
def company_test_query(request):
    db_id = request.data['db']
    session_id = request.data['sessionId']
    sql = request.data['sql']

    exercise = CompanyExercise.objects.get(pk=session_id)

    db = Database.objects.get(pk=db_id)
    data = execute_sql(db, sql)
    match = compare_query_results(data, exercise)

    resp = {
      'rows': data['rows'],
      'headers': data['headers'],
      'db_id': db_id,
      'match': match,
    }

    if match:
        try:
            success_attempt = SuccessfulCompanyAttempt.objects.get(exercise=exercise, user=request.user)
            success_attempt.time = timezone.now()
            success_attempt.save()
            print('succeeded try')
        except SuccessfulCompanyAttempt.DoesNotExist:
            success_attempt = SuccessfulCompanyAttempt(exercise=exercise, user=request.user, query=sql)
            success_attempt.save()
            print('succeeded except')
        except Exception as e:
            print(e)
        # TODO: FIX SERIALIZER HERE
        serializer = CompanyExerciseSerializer(exercise, context={'request': request})
        pprint(serializer.data)
        resp['exercise'] = serializer.data

    return Response(data=resp, status=200)



@api_view(['POST'])
@permission_classes((AllowAny,))
def test_query(request):
    db_id = request.data['db']
    session_id = request.data['sessionId']
    dt_session = request.data['dtSession']
    sql = request.data['sql']
    invitation_id = request.data['invitationId']

    inv = Invitation.objects.get(pk=invitation_id)

    if dt_session:
        exercise = CompanyExercise.objects.get(pk=session_id)
    else:
        exercise = UserExercise.objects.get(pk=session_id)

    db = Database.objects.get(pk=db_id)
    data = execute_sql(db, sql)
    match = compare_query_results(data, exercise)

    first_query_invitation = request.data.get('firstQueryInvitation', False)
    if first_query_invitation:
        inv.status = IN_PROGRESS

    if match:
        inv.status = SUCCESSFULLY_COMPLETED
        inv.successful_query = sql

    inv.last_query = sql
    inv.save()

    resp = {
      'rows': data['rows'],
      'headers': data['headers'],
      'db_id': db_id,
      'duplicates': data['duplicates'],
      'match': match,
      'invitation_status': inv.status
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

    if request.user.is_superuser and request.user.email == 'adminCREATE@dev.com':
        ce = CompanyExercise(
          name=name,
          db=db,
          objective=objective,
          working_query=sql,
          expected_headers=expected_headers,
          expected_rows=expected_rows,
          column_descriptions=request.data['columnDescriptions']
        )
        ce.save()
    else:
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
