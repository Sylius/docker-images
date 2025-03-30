#syntax=docker/dockerfile:1
ARG FRANKENPHP_VERSION=1.5-php8.2-alpine

# Adapted from https://github.com/dunglas/symfony-docker

# Versions
FROM dunglas/frankenphp:${FRANKENPHP_VERSION} AS frankenphp_upstream


# The different stages of this Dockerfile are meant to be built into separate images
# https://docs.docker.com/develop/develop-images/multistage-build/#stop-at-a-specific-build-stage
# https://docs.docker.com/compose/compose-file/#target


# Base FrankenPHP image
FROM frankenphp_upstream AS frankenphp_base

WORKDIR /srv/sylius

# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER=1

# persistent / runtime deps
# hadolint ignore=DL3008
RUN install-php-extensions \
    @composer \
    apcu \
    exif \
    gd \
    intl \
    pdo_mysql \
    opcache \
    zip

COPY --link conf.d/app.ini $PHP_INI_DIR/conf.d/
COPY --link --chmod=755 docker-entrypoint.sh /usr/local/bin/docker-entrypoint
COPY --link Caddyfile /etc/caddy/Caddyfile

ENTRYPOINT ["docker-entrypoint"]

HEALTHCHECK --start-period=60s CMD curl -f http://localhost:2019/metrics || exit 1
CMD [ "frankenphp", "run", "--config", "/etc/caddy/Caddyfile" ]

# Dev FrankenPHP image
FROM frankenphp_base AS frankenphp_dev

ENV APP_ENV=dev XDEBUG_MODE=off
VOLUME /app/var/

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

RUN set -eux; \
	install-php-extensions \
		xdebug \
	;

COPY --link conf.d/app.dev.ini $PHP_INI_DIR/conf.d/
COPY --link conf.d/app-cli.ini $PHP_INI_DIR/conf.d/

CMD [ "frankenphp", "run", "--config", "/etc/caddy/Caddyfile", "--watch" ]

# Prod FrankenPHP image
FROM frankenphp_base AS frankenphp_prod

ENV APP_ENV=prod
ENV FRANKENPHP_CONFIG="import worker.Caddyfile"

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

COPY --link conf.d/app.prod.ini $PHP_INI_DIR/conf.d/
COPY --link conf.d/app-cli.ini $PHP_INI_DIR/conf.d/
COPY --link worker.Caddyfile /etc/caddy/worker.Caddyfile
