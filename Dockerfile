FROM node:10.16-alpine

ENV SCREENIE_VERSION=3.0.0-beta.2
ENV SCREENIE_CHROMIUM_ARGS=--no-sandbox
ENV SCREENIE_CHROMIUM_EXEC=/usr/lib/chromium/chrome
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Installs latest Chromium (77) package
RUN apk update && apk upgrade && \
  echo @3.10 http://nl.alpinelinux.org/alpine/v3.10/community >> /etc/apk/repositories && \
  echo @3.10 http://nl.alpinelinux.org/alpine/v3.10/main >> /etc/apk/repositories && \
  apk add --no-cache \
  chromium@3.10 \
  nss@3.10 \
  freetype@3.10 \
  harfbuzz@3.10 \
  ttf-freefont@3.10 \
  git@3.10 && \
  wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 && \
  chmod +x /usr/local/bin/dumb-init

ENTRYPOINT ["dumb-init"]

RUN npm install -g screenie-server@${SCREENIE_VERSION} --unsafe-perm

EXPOSE 3000

CMD /usr/local/bin/screenie
