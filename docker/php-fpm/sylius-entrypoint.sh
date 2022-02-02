#!/bin/sh
set -e

INSTALL_FOR_PROD=0
USE_SYLIUS_SOURCE=1

PREFER=$([ $USE_SYLIUS_SOURCE = 1 ] && echo "--prefer-source" || echo "--prefer-dist")

if [ "$APP_ENV" = 'dev' ] || { [ "$APP_ENV" = 'prod' ] && [ $INSTALL_FOR_PROD = 1 ]; }; then
    composer install $PREFER --no-interaction

    while ! mysqladmin ping -h"$DB_HOST" --silent; do
        (>&2 echo "Connecting to database server...")
        sleep 1
    done

    (>&2 echo "Connected!")

    bin/console sylius:install --no-interaction

    bin/console doctrine:migrations:migrate --no-interaction

    symfony check:requirements
fi

(>&2 echo "Installation skipped!")

exec "$@"
