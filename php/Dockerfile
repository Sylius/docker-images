ARG PHP_BASE_IMAGE_TAG=8.0-fpm

FROM php:${PHP_BASE_IMAGE_TAG} AS sylius_php
RUN apt update
RUN apt install -y zlib1g-dev
RUN apt install -y libpng-dev
RUN apt install -y libicu-dev
RUN apt install -y zip
RUN docker-php-ext-install gd
RUN docker-php-ext-install exif
RUN docker-php-ext-install fileinfo
RUN docker-php-ext-install intl
RUN docker-php-ext-install pdo_mysql
COPY php.ini $PHP_INI_DIR/php.ini
ENV PHP_DATE_TIMEZONE="Europe/Warsaw"
