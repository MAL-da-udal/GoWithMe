#!/bin/bash

set -e

service postgresql start

until su - postgres -c "psql -c '\l'"; do
  echo "Waiting for PostgreSQL to start..."
  sleep 1
done


su - postgres -c "psql -c \"CREATE USER $POSTGRES_USER WITH PASSWORD '$POSTGRES_PASSWORD';\""
su - postgres -c "createdb $POSTGRES_DB"
su - postgres -c "psql -c 'GRANT ALL PRIVILEGES ON DATABASE $POSTGRES_DB TO $POSTGRES_USER;'"
