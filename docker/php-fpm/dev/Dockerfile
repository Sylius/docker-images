ARG PHP_VERSION

FROM php:${PHP_VERSION}

ARG PHP_USER_NAME
ARG PHP_USER_GROUP
ARG UID
ARG GID
ARG APP_ENV
ARG DB_HOST
ARG PHP_DATE_TIMEZONE

WORKDIR /srv/www/sylius

COPY ./docker/php-fpm/php-cli.ini /usr/local/etc/php/php-cli.ini
COPY ./docker/php-fpm/dev/php.ini /usr/local/etc/php/php.ini

COPY --chown=$PHP_USER_NAME:$PHP_USER_GROUP ./config/preload.php ./config/preload.php

# set env variables for bash scripts and .ini files
ENV PHP_USER_NAME=${PHP_USER_NAME}
ENV APP_ENV=${APP_ENV}
ENV DB_HOST=${DB_HOST}
ENV PHP_DATE_TIMEZONE=${PHP_DATE_TIMEZONE}

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN apt update && apt install -y \
    zip \
    unzip \
    git \
    vim \
    nano

RUN install-php-extensions \
    # TO BE VERIFIED WHETHER APCU AND MEMCACHED ARE NEEDED
    # apcu \
    # memcached \
    # opcache \
    gd \
    exif \
    fileinfo \
    intl \
    pdo_mysql \
    zip \
    imagick \
    xdebug-3.1.2

# RUN docker-php-ext-enable apcu --ini-name 10-docker-php-ext-apcu.ini
# RUN docker-php-ext-enable memcached

RUN curl -sS https://get.symfony.com/cli/installer | bash
RUN mv /root/.symfony/bin/symfony /usr/local/bin/symfony

RUN mkdir -p var/cache var/log public/media

RUN groupadd -g $GID -o $PHP_USER_GROUP
RUN useradd -m -u $UID -g $GID -o -s /bin/bash $PHP_USER_NAME

RUN chown -R $PHP_USER_NAME:$PHP_USER_GROUP ./*

USER $PHP_USER_NAME:$PHP_USER_GROUP

COPY ./../../composer.* ./
COPY --from=composer /usr/bin/composer /usr/local/bin/composer
ENV COMPOSER_MEMORY_LIMIT=-1

COPY --chown=$PHP_USER_NAME:$PHP_USER_GROUP ./docker/php-fpm/sylius-entrypoint.sh /tmp/sylius-entrypoint.sh
RUN chmod o=r /tmp/sylius-entrypoint.sh

ENTRYPOINT ["/tmp/sylius-entrypoint.sh"]

CMD php-fpm

EXPOSE 9000
