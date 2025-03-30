ARG IMAGE_NAME
ARG IMAGE_TAG

FROM ${IMAGE_NAME}:${IMAGE_TAG}

RUN set -eux; \
      apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
    && install-php-extensions \
       		xdebug \
    && apk del --no-network .build-deps
