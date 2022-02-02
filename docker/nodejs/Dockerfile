ARG NODEJS_VERSION

FROM node:${NODEJS_VERSION}

WORKDIR /srv/www/sylius

CMD yarn && yarn gulp build ; node
