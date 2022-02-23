#!/bin/sh

export $(cat .env | sed 's/#.*//g' | xargs)

ACTION=${1:-'up'}
ENVIRONMENT=${2:-$APP_ENV}
RDBMS=${3:-$DOCKER_DB_RDBMS}
INSTALL_FOR_PROD=${4:-0}

DOCKER_COMPOSE_PATH="./docker/docker-compose.${ENVIRONMENT}.${RDBMS}.yaml"
DOCKER_COMPOSE_COMMAND="docker-compose --file $DOCKER_COMPOSE_PATH --env-file ./.env"

containsElement () {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 1; done
  return 0
}

SERVICES=("php-fpm" "nginx" "mysql" "nodejs" "mailhog")

containsElement $ACTION "${SERVICES[@]}"

if [[ $? == 1 ]]; then
    $DOCKER_COMPOSE_COMMAND exec $ACTION bash
elif [[ $ACTION == 'down' ]]; then
    $DOCKER_COMPOSE_COMMAND down
elif [[ $ACTION == 'up' ]]; then
    $DOCKER_COMPOSE_COMMAND up -d --build

    # Install composer dependencies, check database connection and prepare data in database:
    if [[ $ENVIRONMENT == 'dev' || $INSTALL_FOR_PROD == '1' ]]; then
        # $DOCKER_COMPOSE_COMMAND exec php-fpm composer install -v --no-interaction

        check_connection () {
            local result=$($DOCKER_COMPOSE_COMMAND exec php-fpm php -f /tmp/check_connection.php $DB_USER $DB_PASSWORD $APP_ENV)
            echo "$result"
        }

        while [[ $(check_connection) != 'connected' ]]; do
            echo "Connecting to database server..."
            sleep 1
        done

        echo "Connected!"

        # TODO improve sylius:install for Docker
        # php bin/console sylius:install --no-interaction

        # $DOCKER_COMPOSE_COMMAND exec php-fpm php bin/console doctrine:migrations:migrate --no-interaction
    fi
else
    echo "$ACTION is not supported"
fi
