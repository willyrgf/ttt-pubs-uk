#!/usr/bin/env bash

USE_DOCKERCOMPOSER=true
SERVICE='db-ttt'

POSTGRES_USER='postgres'
POSTGRES_PASS='example'
POSTGRES_HOST='127.0.0.1'
POSTGRES_PORT='54325'
POSTGRES_DBNAME='pubsuk'
SQL_DIR="sql"
SEEDERS_DIR="seeders"

# if not exist sql dir
[ -d ${SQL_DIR} ] || exit 1
[ -d ${SEEDERS_DIR} ] || exit 1

# if you will use docker-compose, check if exist
if ${USE_DOCKERCOMPOSER} && ! command -v docker-compose > /dev/null ; then
    exit 1
fi

# up database using docker
if ${USE_DOCKERCOMPOSER}; then
    docker-compose ps ${SERVICE} | grep -q Up ||
        docker-compose up -d 
fi

# creating database, schemas and extensions
PGPASSWORD=${POSTGRES_PASS} psql \
    -U${POSTGRES_USER} \
    -h${POSTGRES_HOST} \
    -p ${POSTGRES_PORT} < sql/init_database.sql || exit 1

# create all tables and functions
list_sqls_ordered=(
    'part1_create_tables.sql' 'part1_create_functions.sql'
    'part2_create_tables.sql' 'part2_create_functions.sql'
    'part3_create_tables.sql' 'part3_create_functions.sql'
)
for f in ${list_sqls_ordered[*]}; do
        PGPASSWORD=${POSTGRES_PASS} psql \
        -U${POSTGRES_USER} \
        -h${POSTGRES_HOST} \
        -p ${POSTGRES_PORT} \
        -d ${POSTGRES_DBNAME} < "${SQL_DIR}/${f}" || exit 1
done

# importing all data
awk -F '\t' '{print $2 "\t" $3}' data/cities.tsv | 
    PGPASSWORD=${POSTGRES_PASS} psql \
    -U${POSTGRES_USER} \
    -h${POSTGRES_HOST} \
    -p ${POSTGRES_PORT} \
    -d ${POSTGRES_DBNAME} \
    -c "copy ttt.cities(location, name) from stdin delimiter E'\t'"

awk -F '\t' '{print $2 "\t" $3}' data/pubs.tsv | 
    PGPASSWORD=${POSTGRES_PASS} psql \
    -U${POSTGRES_USER} \
    -h${POSTGRES_HOST} \
    -p ${POSTGRES_PORT} \
    -d ${POSTGRES_DBNAME} \
    -c "copy ttt.pubs(location, name) from stdin delimiter E'\t'"


# create all tables and functions
list_seeders_ordered=(
    'part2_seeder.sql'
    'part3_seeder.sql'
)
for f in ${list_seeders_ordered[*]}; do
        PGPASSWORD=${POSTGRES_PASS} psql \
        -U${POSTGRES_USER} \
        -h${POSTGRES_HOST} \
        -p ${POSTGRES_PORT} \
        -d ${POSTGRES_DBNAME} < "${SEEDERS_DIR}/${f}" || exit 1
done

