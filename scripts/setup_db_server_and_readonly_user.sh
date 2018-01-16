#!/usr/bin/env bash

sudo apt-get update
sudo apt-get install postgresql postgresql-contrib

echo -n Database Name:
read db_name
echo

echo -n Password:
read -s password
echo

sudo -i -u postgres
psql

CREATE DATABASE ${db_name} OWNER postgres;

CREATE ROLE readonly WITH LOGIN PASSWORD ${password};
GRANT CONNECT ON DATABASE ${db_name} TO readonly;
GRANT USAGE ON SCHEMA public TO readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO readonly;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO readonly;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO readonly;

# make sure to modify pg_hba for listening
# and postgresql.conf for host to listen to
