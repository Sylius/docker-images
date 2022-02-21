#!/bin/sh

# INSTALL_FOR_PROD=0

# if [ "$DOCKER_APP_ENV" = 'dev' ] || [ $INSTALL_FOR_PROD = 1 ]; then
#     #composer install -v --no-interaction

#     IS_CONNECTED=$(php -f ./docker/php-fpm/check_connection.php)

#     while [ $IS_CONNECTED -ne 1 ]
#     do
#         echo "Connecting to database server..."

#         sleep 1
#     done

#     echo "Connected!"

#     # TODO improve sylius:install for Docker
#     # php bin/console sylius:install --no-interaction

#     # php bin/console doctrine:migrations:migrate --no-interaction

# fi

exec "$@"
