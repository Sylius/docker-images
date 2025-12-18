ARG PHP_SHORT_VERSION=7.4
ARG APCU_VERSION=5.1.28

FROM php:${PHP_SHORT_VERSION}-fpm-alpine

ARG PHP_SHORT_VERSION
ARG APCU_VERSION

# persistent / runtime deps
RUN apk add --no-cache \
		acl \
		file \
		gettext \
		gnu-libiconv \
	;

# install gnu-libiconv and set LD_PRELOAD env to make iconv work fully on Alpine image.
# see https://github.com/docker-library/php/issues/240#issuecomment-763112749
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so


RUN set -eux; \
	apk add --no-cache --virtual .build-deps \
		$PHPIZE_DEPS \
		freetype-dev \
		icu-dev \
		libjpeg-turbo-dev \
		libpng-dev \
		libtool \
		libwebp-dev \
		libzip-dev \
		linux-headers \
		zlib-dev \
	; \
	\
	# solves BC after PHP 7.4 release
	# see https://github.com/docker-library/php/issues/912
	if [[ 1 -eq "$(echo "$PHP_SHORT_VERSION >= 7.4" | bc)" ]] ; \
        then \
          docker-php-ext-configure gd --with-jpeg --with-webp --with-freetype; \
          docker-php-ext-configure zip --with-zip; \
        else \
          docker-php-ext-configure gd --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include --with-webp-dir=/usr/include --with-freetype-dir=/usr/include/;  \
          docker-php-ext-configure zip --with-libzip; \
    fi; \
	docker-php-ext-install -j$(nproc) \
		exif \
		gd \
		intl \
		pdo_mysql \
		sockets \
		zip \
	; \
	pecl install \
		apcu-${APCU_VERSION} \
	; \
	pecl clear-cache; \
    # Opcache is built into core of PHP binary from version 8.5
    if [[ 1 -eq "$(echo "$PHP_SHORT_VERSION < 8.5" | bc)" ]] ; \
        then \
          docker-php-ext-enable opcache; \
    fi; \
	docker-php-ext-enable \
		apcu \
	; \
	\
	runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)"; \
	apk add --no-cache --virtual .sylius-phpexts-rundeps $runDeps; \
	\
	apk del .build-deps

# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_MEMORY_LIMIT=-1

ENV PATH="${PATH}:/root/.composer/vendor/bin"

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY php.ini "$PHP_INI_DIR/"
COPY php-cli.ini "$PHP_INI_DIR/"

WORKDIR /srv/sylius
