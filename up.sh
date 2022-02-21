#!/bin/sh

export $(cat .env | sed 's/#.*//g' | xargs)

ENVIRONMENT=${1:-$APP_ENV}

RDBMS=${2:-$DOCKER_DB_RDBMS}

DOCKER_COMPOSE_PATH="./docker/docker-compose.${ENVIRONMENT}.${RDBMS}.yaml"

docker-compose --file $DOCKER_COMPOSE_PATH --env-file ./.env up -d --build
