#!/bin/sh

#### MOVE THIS CODE TO THE docker.sh TO MAKE BUILD SYNCHRONOUS

INSTALL_FOR_PROD=0

if [ "$DOCKER_APP_ENV" = 'dev' ] || [ $INSTALL_FOR_PROD = 1 ]; then
    # composer install -v --no-interaction

    check_connection () {
        return $(php -f ./docker/php-fpm/scripts/check_connection.php)
    }

    check_connection

    while [ $? -ne "1" ]
    do
        echo "Connecting to database server..."

        check_connection

        sleep 1
    done

    echo "Connected!"

    # TODO improve sylius:install for Docker
    # php bin/console sylius:install --no-interaction

    # php bin/console doctrine:migrations:migrate --no-interaction
fi

exec "$@"
