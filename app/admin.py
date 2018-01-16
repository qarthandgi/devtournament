from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as DjangoUserAdmin

from .models import User, Database, CompanyExercise, SuccessfulCompanyAttempt


admin.site.register(Database)
admin.site.register(CompanyExercise)
admin.site.register(SuccessfulCompanyAttempt)


@admin.register(User)
class UserAdmin(DjangoUserAdmin):
    """
    Define admin model for custom user model with required email field
    """

    fieldsets = (
      (None, {'fields': ('email', 'username', 'password')}),
      ('Personal Info', {'fields': ('first_name', 'last_name', 'subscription')}),
      ('Permissions', {'fields': ('is_active', 'is_staff', 'is_superuser', 'groups', 'user_permissions')}),
      ('Important Dates', {'fields': ('last_login', 'date_joined')})
    )
    add_fieldsets = (
      (None, {'classes': ('wide', ), 'fields': ('email', 'username', 'password1', 'password2')})
    )
    list_display = ('email', 'username', 'first_name', 'last_name', 'is_staff')
    search_fields = ('email', 'username', 'first_name', 'last_name')
    ordering = ('email',)
