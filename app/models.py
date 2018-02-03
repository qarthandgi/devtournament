from django.contrib.auth.models import AbstractUser, BaseUserManager
from django.contrib.postgres.fields import JSONField
from django.db import models
from django.forms.models import model_to_dict
from django.utils import timezone

from allauth.account.models import EmailAddress


NONE = None
BASIC = 'basic'
PREMIUM = 'premium'

SUBSCRIPTION_CHOICES = (
  (NONE, 'None'),
  (BASIC, 'Basic'),
  (PREMIUM, 'Premium')
)


NOVICE = 'novice'
INTERMEDIATE = 'intermediate'
ADVANCED = 'advanced'

DIFFICULTY_CHOICES = (
  (NOVICE, 'Novice'),
  (INTERMEDIATE, 'Intermediate'),
  (ADVANCED, 'advanced')
)


POSTGRES = 'postgres'

SUBJECT_CHOICES = (
  (POSTGRES, 'Postgres'),
)


PENDING = 'pending'
ACCEPTED = 'accepted'
DECLINED = 'declined'
IN_PROGRESS = 'in progress'
SUCCESSFULLY_COMPLETED = 'successfully completed'

INVITATION_STATUS_CHOICES = (
  (PENDING, 'Pending'),
  (ACCEPTED, 'Accepted'),
  (DECLINED, 'Declined'),
  (IN_PROGRESS, 'In Progress'),
  (SUCCESSFULLY_COMPLETED, 'Successfully Completed')
)


# Managers

class UserManager(BaseUserManager):
    """
    Define a model manager to validate both username and email
    """

    use_in_migrations = True

    def _create_user(self, username, email, password, **extra_fields):
        """
        Create and save a User object with given email, username, and password
        """
        if not username:
            raise ValueError('The given username must be set')
        if not email:
            raise ValueError('The given email must be set')
        email = self.normalize_email(email)
        user = self.model(username=username, email=email, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_user(self, username=None, email=None, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', False)
        extra_fields.setdefault('is_superuser', False)
        return self._create_user(username, email, password, **extra_fields)

    def create_superuser(self, username=None, email=None, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)

        if extra_fields.get('is_staff') is not True:
            raise ValueError('Superuser must have is_staff=True')
        if extra_fields.get('is_superuser') is not True:
            raise ValueError('Superuser must have is_superuser=True')
        return self._create_user(username=email, email=email, password=password, **extra_fields)


class DatabaseManager(models.Manager):
    def all_for_user(self, user):
        databases = self.model.objects.all()
        # TODO: test in all possible user cases
        user_access = getattr(user, 'subscription', None) if user else None

        def db_access(db):
            access_needed = db.needed_subscription
            db_dict = model_to_dict(db)
            db_dict.update({'access': 'granted'})

            if access_needed == BASIC and not user_access:
                db_dict['access'] = 'needs basic'
            elif access_needed == PREMIUM and user_access is not PREMIUM:
                db_dict['access'] = 'needs premium'

            return db_dict

        dbs = list(map(db_access, databases))
        return dbs


class Global(models.Model):
    name = models.CharField(max_length=50, null=True, blank=True)
    int_value = models.IntegerField(null=True, blank=True)
    bool_value = models.NullBooleanField(null=True, blank=True)
    text_value = models.CharField(null=True, blank=True, max_length=50)


class User(AbstractUser):
    """
    Subclassed User model to make email the default login method
    """
    email = models.EmailField(unique=True, error_messages={'unique': "A user with that email already exists."})
    username = models.CharField(max_length=20, unique=True)
    subscription = models.CharField(max_length=15, choices=SUBSCRIPTION_CHOICES, default=BASIC)
    setup = models.BooleanField(default=False)
    stripe_customer_id = models.CharField(null=True, blank=True, max_length=100)
    stripe_subscription_id = models.CharField(null=True, blank=True, max_length=100)
    stripe_default_source_id = models.CharField(null=True, blank=True, max_length=100)
    stripe_current_period_start = models.BigIntegerField(null=True, blank=True)
    stripe_current_period_end = models.BigIntegerField(null=True, blank=True)
    slated_for_downgrade = models.BooleanField(default=False)

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = []

    objects = UserManager()

    def save(self, *args, **kwargs):
        invitations = []
        if self.pk is None:
            invitations = Invitation.objects.filter(invitee_s=self.email, assigned_to_invitee=False)

        super().save(*args, **kwargs)

        for inv in invitations:
            inv.invitee = self
            inv.invitee_registered = True
            inv.enabled = True

    @property
    def is_verified(self):
        return getattr(EmailAddress.objects.get_primary(self), 'verified', False)


class SubscriptionChange(models.Model):
    added = models.DateTimeField(auto_now_add=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    going_to = models.CharField(max_length=15, choices=SUBSCRIPTION_CHOICES)


class Database(models.Model):
    internal_name = models.CharField(max_length=30)
    full_name = models.CharField(max_length=40)
    num_tables = models.IntegerField()
    last_built = models.DateTimeField(null=False, blank=True)
    icon_link = models.CharField(max_length=700)
    needed_subscription = models.CharField(max_length=15, choices=SUBSCRIPTION_CHOICES,
                                           default=BASIC, null=True, blank=True)

    objects = DatabaseManager()

    def __str__(self):
        return self.full_name


class Exercise(models.Model):
    name = models.CharField(max_length=50)
    db = models.ForeignKey(Database, on_delete=models.SET_NULL, blank=True, null=True)
    objective = models.TextField()
    working_query = models.TextField()
    expected_headers = models.BinaryField()
    expected_rows = models.BinaryField()
    column_descriptions = JSONField()
    subject = models.CharField(max_length=20, choices=SUBJECT_CHOICES, default=POSTGRES)
    added = models.DateTimeField(auto_now_add=True)
    position = models.IntegerField(default=0)

    class Meta:
        abstract = True


class CompanyExercise(Exercise):
    difficulty = models.CharField(max_length=20, choices=DIFFICULTY_CHOICES, default=NOVICE)
    new = models.BooleanField(default=False)
    needed_subscription = models.CharField(max_length=15, choices=SUBSCRIPTION_CHOICES,
                                           default=BASIC, null=True, blank=True)
    enabled = models.BooleanField(default=False)

    def __str__(self):
        return self.difficulty + ' - ' + self.name

    def save(self, *args, **kwargs):
        super().save(*args, **kwargs)
        num_exercises = CompanyExercise.objects.filter(enabled=True).count()
        property = Global.objects.get(name='company_exercise_num')
        property.int_value = num_exercises
        property.save()


class UserExercise(Exercise):
    author = models.ForeignKey(User, on_delete=models.CASCADE)
    shareable = models.BooleanField(default=True)


class Invitation(models.Model):
    inviter = models.ForeignKey(User, related_name='invites_sent', on_delete=models.CASCADE)
    invitee = models.ForeignKey(User, related_name='invites', on_delete=models.SET_NULL, null=True, blank=True)
    assigned_to_invitee = models.BooleanField(default=True)
    invitee_s = models.CharField(max_length=50, null=True, blank=True)
    created = models.DateTimeField(default=timezone.now)
    status = models.CharField(max_length=30, choices=INVITATION_STATUS_CHOICES, default=PENDING)
    enabled = models.BooleanField(default=True)
    # TODO: Make sure to warn users that when deleting a custom exercise, it will also delete any invitations associated with it
    exercise = models.ForeignKey(UserExercise, on_delete=models.CASCADE)
    archived = models.BooleanField(default=False)
    last_query = models.TextField(null=True, blank=True)
    successful_query = models.TextField(null=True, blank=True)


class SuccessfulCompanyAttempt(models.Model):
    query = models.TextField()
    time = models.DateTimeField(default=timezone.now)
    user = models.ForeignKey(User, related_name='%(class)s_set', related_query_name='%(class)ss')
    exercise = models.ForeignKey(CompanyExercise, on_delete=models.CASCADE)

    def __str__(self):
        return self.user.username + ' - ' + self.exercise.name
