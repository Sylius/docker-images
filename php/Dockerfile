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
RUN docker-php-ext-install opcache
ENV PHP_DATE_TIMEZONE="Europe/Warsaw"
COPY --from=composer /usr/bin/composer /usr/bin/composer
WORKDIR /symfony
RUN apt install -y wget
RUN wget https://get.symfony.com/cli/installer
RUN chmod +x installer
RUN bash installer
RUN mv /root/.symfony/bin/symfony /usr/local/bin/symfony
WORKDIR /
