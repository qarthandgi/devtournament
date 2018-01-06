"""vuedj URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/1.9/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  url(r'^$', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  url(r'^$', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.conf.urls import url, include
    2. Add a URL to urlpatterns:  url(r'^blog/', include('blog.urls'))
"""
from django.conf.urls import url, include
from django.contrib import admin
# from app.views import index, profile_data
from app import views

# from .views import LoginViewCustom

urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^$', views.index, name='home'),
    url(r'^profile-data/', views.profile_data),
    url(r'^load-postgres/', views.load_postgres),
    url(r'^load-custom-exercises', views.load_custom_exercises),

    url(r'^test-query/', views.test_query),
    url(r'^create-exercise/', views.create_exercise),

    # url(r'^rest-auth/login/$', LoginViewCustom.as_view(), name='rest_login'),
    url(r'^rest-auth/', include('rest_auth.urls')),
    url(r'^rest-auth/registration/', include('rest_auth.registration.urls')),
    url(r'^', include('django.contrib.auth.urls')),
]
