#!/usr/bin/env bash

# MAKE SURE TO DROP DATABASE MANUALLY
# THEN CREATE AFTER

python manage.py reset_migrations account admin app auth authtoken contenttypes sessions sites socialaccount
python manage.py makemigrations app
