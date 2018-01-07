from django.contrib.auth.models import AbstractUser, BaseUserManager
from django.contrib.postgres.fields import JSONField
from django.db import models
from django.forms.models import model_to_dict

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
    create_company_exercise = models.BooleanField(default=True)


class User(AbstractUser):
    """
    Subclassed User model to make email the default login method
    """
    email = models.EmailField(unique=True, error_messages={'unique': "A user with that email already exists."})
    username = models.CharField(max_length=20, unique=True)
    subscription = models.CharField(max_length=15, choices=SUBSCRIPTION_CHOICES, default=BASIC)

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = []

    objects = UserManager()

    @property
    def is_verified(self):
        return getattr(EmailAddress.objects.get_primary(self), 'verified', False)


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

    class Meta:
        abstract = True


class CompanyExercise(Exercise):
    difficulty = models.CharField(max_length=20, choices=DIFFICULTY_CHOICES, default=NOVICE)
    new = models.BooleanField(default=False)
    needed_subscription = models.CharField(max_length=15, choices=SUBSCRIPTION_CHOICES,
                                           default=BASIC, null=True, blank=True)


class UserExercise(Exercise):
    author = models.ForeignKey(User, on_delete=models.CASCADE)
    shareable = models.BooleanField(default=True)
