#!/bin/sh

export $(cat .env | sed 's/#.*//g' | xargs)

BUILD_ACTION=${1:-"up -d --build"}

ENVIRONMENT=${2:-$APP_ENV}

RDBMS=${3:-$DOCKER_DB_RDBMS}

DOCKER_COMPOSE_PATH="./docker/docker-compose.${ENVIRONMENT}.${RDBMS}.yaml"
DOCKER_COMPOSE_COMMAND="docker-compose --file $DOCKER_COMPOSE_PATH --env-file ./.env "

$DOCKER_COMPOSE_COMMAND $BUILD_ACTION

# $DOCKER_COMPOSE_COMMAND exec php-fpm composer install -v --no-interaction

# check connection here

# $DOCKER_COMPOSE_COMMAND exec php-fpm php bin/console doctrine:migrations:migrate --no-interaction
