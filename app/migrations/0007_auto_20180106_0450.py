# -*- coding: utf-8 -*-
# Generated by Django 1.11.7 on 2018-01-06 04:50
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('app', '0006_auto_20180106_0448'),
    ]

    operations = [
        migrations.AlterField(
            model_name='companyexercise',
            name='needed_subscription',
            field=models.CharField(blank=True, choices=[(None, 'None'), ('basic', 'Basic'), ('premium', 'Premium')], default='basic', max_length=15, null=True),
        ),
        migrations.AlterField(
            model_name='database',
            name='needed_subscription',
            field=models.CharField(blank=True, choices=[(None, 'None'), ('basic', 'Basic'), ('premium', 'Premium')], default='basic', max_length=15, null=True),
        ),
    ]
