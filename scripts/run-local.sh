#!/bin/bash
set -e

echo "Starting local reference data setup..."

# Clean existing containers
echo "Cleaning up existing containers..."
docker compose down -v

# Start PostgreSQL
echo "Starting PostgreSQL..."
docker compose up -d postgres

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL to be ready..."
sleep 10

# Apply changes
echo "Applying changes..."
docker compose run --rm liquibase \
  --changelog-file=db.changelog-master.sql \
  update

echo "Setup completed!"
