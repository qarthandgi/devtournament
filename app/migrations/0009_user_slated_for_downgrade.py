# -*- coding: utf-8 -*-
# Generated by Django 1.11.7 on 2018-02-03 07:51
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('app', '0008_auto_20180202_1247'),
    ]

    operations = [
        migrations.AddField(
            model_name='user',
            name='slated_for_downgrade',
            field=models.BooleanField(default=False),
        ),
    ]