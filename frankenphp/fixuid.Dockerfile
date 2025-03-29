ARG IMAGE_NAME
ARG IMAGE_TAG
ARG FIXUID_VERSION=0.6.0

FROM ${IMAGE_NAME}:${IMAGE_TAG}

ARG FIXUID_VERSION

RUN addgroup -g 1000 sylius && \
    adduser -u 1000 -G sylius -h /home/sylius -s /bin/sh -D sylius

RUN USER=sylius && \
    GROUP=sylius && \
    if [[ "$(uname -m)" = "aarch64" ]] ; \
      then \
        curl -SsL https://github.com/boxboat/fixuid/releases/download/v${FIXUID_VERSION}/fixuid-${FIXUID_VERSION}-linux-arm64.tar.gz | tar -C /usr/local/bin -xzf - ;\
      else \
        curl -SsL https://github.com/boxboat/fixuid/releases/download/v${FIXUID_VERSION}/fixuid-${FIXUID_VERSION}-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf - ;\
    fi; \
    chown root:root /usr/local/bin/fixuid && \
    chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid && \
    printf "user: $USER\ngroup: $GROUP\n" > /etc/fixuid/config.yml && \
    # Modify FrankenPHP entrypoint to use fixuid
    sed -i 's/^set -e.*/set -e\nfixuid/g' /usr/local/bin/docker-php-entrypoint

# Fix permissions during named volume creation
RUN mkdir -p /srv/sylius/public/media && chmod 777 -R /srv/sylius

USER sylius:sylius 