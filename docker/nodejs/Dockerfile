ARG DOCKER_NODEJS_VERSION

FROM node:$DOCKER_NODEJS_VERSION

WORKDIR /srv/www/sylius

CMD yarn && yarn gulp build ; node
