ARG PHP_BASE_IMAGE_TAG=8.0-fpm

FROM php:${PHP_BASE_IMAGE_TAG} AS sylius_php

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN apt-get update && \
    apt-get install -y unzip && \
    install-php-extensions  \
      apcu \
      exif \
      fileinfo \
      gd \
      imagick \
      intl \
      memcached \
      opcache \
      pdo_mysql \
      zip
RUN docker-php-ext-enable apcu --ini-name 10-docker-php-ext-apcu.ini
RUN docker-php-ext-enable memcached
ENV PHP_DATE_TIMEZONE="Europe/Warsaw"
COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN curl -fs https://get.symfony.com/cli/installer | bash && \
    mv /root/.symfony/bin/symfony /usr/local/bin/symfony
WORKDIR /
