ARG IMAGE_NAME
ARG IMAGE_TAG

ARG XDEBUG_VERSION=3.1.2

FROM ${IMAGE_NAME}:${IMAGE_TAG}

ARG XDEBUG_VERSION

RUN if [ "$(awk -F= '/^NAME/{print $2}' /etc/os-release)" = '"Ubuntu"' ] then \
    set -eux \
    && apt install build-essentials \
    && pecl install xdebug-$XDEBUG_VERSION \
    && docker-php-ext-enable xdebug \
    && apt autoclean; \
fi

RUN if [ "$(awk -F= '/^NAME/{print $2}' /etc/os-release)" = '"Alpine Linux"' ] then \
    set -eux \
    && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS linux-headers \
    && pecl install xdebug-$XDEBUG_VERSION \
    && docker-php-ext-enable xdebug \
    && apk del .build-deps; \
fi
