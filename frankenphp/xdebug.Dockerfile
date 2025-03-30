ARG IMAGE_NAME
ARG IMAGE_TAG

FROM ${IMAGE_NAME}:${IMAGE_TAG}

RUN install-php-extensions xdebug
