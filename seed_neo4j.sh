#!/bin/sh

set -eu # Exit immediately if a command exits with a non-zero status, and treat unset variables as an error

# Load environment variables
NEO4J_USER=${NEO4J_USER:-neo4j}
NEO4J_PASSWORD=${NEO4J_PASSWORD:-12345678}
NEO4J_HOST=${NEO4J_HOST:-neo4jdb}
NEO4J_PORT=${NEO4J_PORT:-7687}

# Wait for Neo4j to be available
until cypher-shell -a bolt://$NEO4J_HOST:$NEO4J_PORT -u "$NEO4J_USER" -p "$NEO4J_PASSWORD" 'RETURN 1' >/dev/null 2>&1; do
  echo "Waiting for Neo4j..."
  sleep 2
done

# Run Cypher script using cypher-shell
cat /var/lib/neo4j/import/moviesDb_cypher | cypher-shell -a bolt://$NEO4J_HOST:$NEO4J_PORT -u "$NEO4J_USER" -p "$NEO4J_PASSWORD"


# Create fraud-demo database if it does not exist
cypher-shell \
  -a bolt://$NEO4J_HOST:$NEO4J_PORT \
  -u "$NEO4J_USER" \
  -p "$NEO4J_PASSWORD" \
  -d system \
  'CREATE DATABASE `fraud-demo` IF NOT EXISTS'

# Wait for fraud-demo to become available
until cypher-shell \
  -a bolt://$NEO4J_HOST:$NEO4J_PORT \
  -u "$NEO4J_USER" \
  -p "$NEO4J_PASSWORD" \
  -d fraud-demo \
  'RETURN 1' >/dev/null 2>&1
do
  echo "Waiting for fraud-demo..."
  sleep 2
done

# Seed fraud-demo database
cat /var/lib/neo4j/import/fraud-demo.cypher | \
  cypher-shell \
    -a bolt://$NEO4J_HOST:$NEO4J_PORT \
    -u "$NEO4J_USER" \
    -p "$NEO4J_PASSWORD" \
    -d fraud-demo

echo "Seeding completed successfully."