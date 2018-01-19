FROM node:8-alpine

LABEL maintainer="Paolo Chiabrera <paolo.chiabrera@gmail.com>"

ENV NODE_TLS_REJECT_UNAUTHORIZED 0

RUN apk add --update curl && rm -rf /var/cache/apk/*

RUN mkdir -p /opt/app

ENV NODE_ENV production

ARG PORT=80

ENV PORT $PORT

HEALTHCHECK CMD curl -fs http://localhost:$PORT/healthcheck || exit 1

WORKDIR /opt

ONBUILD COPY package.json /opt

ONBUILD COPY yarn.lock /opt

ONBUILD RUN yarn install && yarn cache clean

ONBUILD ENV PATH /opt/node_modules/.bin:$PATH

ONBUILD WORKDIR /opt/app

ONBUILD COPY . /opt/app

ONBUILD CMD ["yarn", "start"]
