#!/bin/bash

set -e

service postgresql start

until su - postgres -c "psql -c '\l'"; do
  echo "Waiting for PostgreSQL to start..."
  sleep 1
done


su - postgres -c "psql -c \"DO \$\$ BEGIN IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '$POSTGRES_USER') THEN CREATE USER $POSTGRES_USER WITH PASSWORD '$POSTGRES_PASSWORD'; END IF; END \$\$;\""
su - postgres -c "psql -c \"SELECT 1 FROM pg_database WHERE datname = '$POSTGRES_DB'\" | grep -q 1 || createdb $POSTGRES_DB"
su - postgres -c "psql -c 'GRANT ALL PRIVILEGES ON DATABASE $POSTGRES_DB TO $POSTGRES_USER;'"