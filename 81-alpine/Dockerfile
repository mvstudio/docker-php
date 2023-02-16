FROM --platform=${TARGETPLATFORM} alpine:edge

ARG TARGETPLATFORM
ARG TARGETARCH

ENV APP_DIR="/var/www/html"
ENV APP_USER="apache"
ENV APP_GROUP="apache"

ENV WP_CLI_PACKAGES_DIR="/tmp/.wp-cli-packages/"
ENV WP_CLI_CACHE_DIR="/tmp/.wp-cli-cache/"
ENV WP_CLI_URL="https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar"

ENV OPCACHE_ENABLE=1
ENV OPCACHE_REVALIDATE_FREQ=3600
ENV SESSION_SAVE_HANDLER=files
ENV SESSION_SAVE_PATH=/tmp

RUN echo '@community http://nl.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories && \
  echo '@316main http://nl.alpinelinux.org/alpine/v3.16/main' >> /etc/apk/repositories

RUN apk --no-cache add \
  apache2 apache2-dev apr apr-dev apr-util apr-util-dev autoconf automake bash \
  curl diffutils fontconfig freetype freetype-dev fuse g++ gcc geoip geoip-dev \
  git imagemagick@community libjpeg-turbo-dev libpng-dev libssl1.1@community libstdc++ libtool \
  libx11 libxext libxml2 libxml2-dev libxrender linux-headers lmdb lmdb-dev \
  lua5.3 lua5.3-dev make nodejs npm@community openssl pcre pcre-dev perl \
  php81@community php81-apache2@community php81-common@community php81-ctype@community \
  php81-curl@community php81-dev@community php81-dom@community php81-fileinfo@community \
  php81-ftp@community php81-gd@community php81-iconv@community php81-intl@community \
  php81-json@community php81-mbstring@community php81-mysqli@community php81-opcache@community \
  php81-openssl@community php81-pdo@community php81-pdo_mysql@community php81-pecl-apcu@community \
  php81-pecl-redis@community php81-pecl-xdebug@community php81-phar@community \
  php81-posix@community php81-session@community php81-simplexml@community php81-soap@community \
  php81-sodium@community php81-tokenizer@community php81-xml@community php81-xmlreader@community \
  php81-xmlwriter@community php81-zip@community php81-zlib@community \
  shadow@community ssmtp sudo@community ttf-dejavu@316main ttf-droid ttf-freefont@316main \
  ttf-liberation yajl yajl-dev

# fix missing dir for Apache2 PID file
RUN mkdir -p /run/apache2/

# create symlink for php executable php -> php81
# RUN ln -s /usr/bin/php81 /usr/bin/php

# move php.ini to the same location as in the php-apache image (back compat)
RUN mkdir -p /usr/local/etc/php && \
  cp /etc/php81/php.ini /usr/local/etc/php/php.ini && \
  ln -s /usr/local/etc/php/php.ini /etc/php81/conf.d/20_php.ini

# clean /var/www directory
RUN rm -Rf /var/www/* && \
  mkdir -p /var/www/html

COPY ./bootstrap.sh /bootstrap.sh
COPY ./entrypoint.sh /entrypoint.sh
COPY ./httpd.conf /etc/apache2/httpd.conf
COPY ./php.ini /etc/php81/conf.d/mvstudio.ini
COPY ./bin/gosu-${TARGETARCH} /usr/local/bin/gosu
COPY ./bin/tini-static-${TARGETARCH} /usr/local/bin/tini
COPY ./bin/dockerize-linux-${TARGETARCH} /usr/local/bin/dockerize

ENV HTTPD_PORT_HTTP="80" \
    HTTPD_PORT_HTTPS="443" \
    HTTPD_CORES="4" \
    HTTPD_THREADS_PER_CORE="64" \
    HTTPD_DUMPIO_INPUT="Off" \
    HTTPD_DUMPIO_OUTPUT="Off"

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Building & Install Mod Security 2.9.5
RUN curl -sSL https://github.com/SpiderLabs/ModSecurity/releases/download/v2.9.5/modsecurity-2.9.5.tar.gz | tar -C /tmp/ -xz && \
  cd /tmp/modsecurity-2.9.5 && \
  ./autogen.sh && \
  ./configure && \
  make -j$(nproc) && \
  make install && \
  mkdir -p /etc/modsecurity && \
  cp ./modsecurity.conf-recommended /etc/modsecurity && \
  cp ./unicode.mapping /etc/modsecurity/unicode.mapping && \
  make clean && \
  cd / && \
  rm -rf /tmp/modsecurity-2.9.5

# Install Core ruleset 3.3.2
RUN curl -sSL https://github.com/coreruleset/coreruleset/archive/v3.3.2.tar.gz | tar -C /etc/modsecurity -xz && \
  mv /etc/modsecurity/coreruleset-3.3.2/crs-setup.conf.example /etc/modsecurity/coreruleset-3.3.2/crs-setup.conf

# Install WP cli
RUN curl ${WP_CLI_URL} -o /usr/local/bin/wp && \
  chmod +x /usr/local/bin/wp && \
  php -d memory_limit=-1 /usr/local/bin/wp package install https://github.com/runcommand/precache.git --allow-root

WORKDIR ${APP_DIR}
EXPOSE 80

ENTRYPOINT [ "/bootstrap.sh" ]
CMD ["httpd", "-DFOREGROUND"]
