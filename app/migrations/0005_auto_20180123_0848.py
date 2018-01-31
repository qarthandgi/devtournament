# -*- coding: utf-8 -*-
# Generated by Django 1.11.7 on 2018-01-23 08:48
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('app', '0004_auto_20180122_0703'),
    ]

    operations = [
        migrations.AddField(
            model_name='user',
            name='setup',
            field=models.BooleanField(default=False),
        ),
        migrations.AddField(
            model_name='user',
            name='stripe_id',
            field=models.CharField(blank=True, max_length=100, null=True),
        ),
    ]