ARG IMAGE_NAME
ARG IMAGE_TAG

ARG XDEBUG_VERSION=3.1.2

FROM ${IMAGE_NAME}:${IMAGE_TAG}

ARG XDEBUG_VERSION

RUN set -eux; \
	apk add --no-cache --virtual .build-deps $PHPIZE_DEPS linux-headers; \
	# pecl.php.net is being decommissioned, install Xdebug from source
	wget -O /tmp/xdebug.tar.gz "https://github.com/xdebug/xdebug/archive/refs/tags/$XDEBUG_VERSION.tar.gz"; \
	mkdir -p /usr/src/php/ext/xdebug; \
	tar -xzf /tmp/xdebug.tar.gz -C /usr/src/php/ext/xdebug --strip-components=1; \
	rm /tmp/xdebug.tar.gz; \
	docker-php-ext-install -j$(nproc) xdebug; \
	apk del .build-deps
