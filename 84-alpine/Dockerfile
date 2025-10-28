FROM --platform=${TARGETPLATFORM} alpine:3.21 AS builder

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

RUN echo '@316main http://nl.alpinelinux.org/alpine/v3.16/main' >> /etc/apk/repositories

RUN apk --no-cache add \
  apache2 apache2-utils apache2-dev apr apr-dev apr-util apr-util-dev autoconf automake bash \
  curl diffutils fontconfig freetype freetype-dev fuse g++ gcc geoip geoip-dev \
  git imagemagick libjpeg-turbo-dev libpng-dev libssl3 libstdc++ libtool \
  libx11 libxext libxml2 libxml2-dev libxrender linux-headers lmdb lmdb-dev \
  lua5.3 lua5.3-dev make nodejs npm openssl pcre pcre-dev perl \
  php84 php84-apache2 php84-common php84-ctype \
  php84-curl php84-dev php84-dom php84-fileinfo \
  php84-ftp php84-gd php84-iconv php84-intl \
  php84-json php84-mbstring php84-mysqli php84-opcache \
  php84-openssl php84-pdo php84-pdo_mysql php84-pecl-apcu \
  php84-pecl-redis php84-pecl-xdebug php84-phar \
  php84-posix php84-session php84-simplexml php84-soap \
  php84-sodium php84-tokenizer php84-xml php84-xmlreader \
  php84-xmlwriter php84-zip php84-zlib php84-pecl-imagick \
  shadow ssmtp sudo ttf-dejavu@316main ttf-droid ttf-freefont@316main \
  ttf-liberation yajl yajl-dev

# fix missing dir for Apache2 PID file
RUN mkdir -p /run/apache2/

# create symlink for php executable php -> php84
RUN ln -s /usr/bin/php84 /usr/bin/php

# move php.ini to the same location as in the php-apache image (back compat)
RUN mkdir -p /usr/local/etc/php && \
  cp /etc/php84/php.ini /usr/local/etc/php/php.ini
  # ln -s /usr/local/etc/php/php.ini /etc/php84/conf.d/20_php.ini

# clean /var/www directory
RUN rm -Rf /var/www/* && \
  mkdir -p /var/www/html

COPY ./bootstrap.sh /bootstrap.sh
COPY ./entrypoint.sh /entrypoint.sh
COPY ./httpd.conf /etc/apache2/httpd.conf
COPY ./php.ini /etc/php84/conf.d/fromnoware.ini
COPY ./bin/gosu-${TARGETARCH} /usr/local/bin/gosu
COPY ./bin/tini-static-${TARGETARCH} /usr/local/bin/tini
COPY ./bin/dockerize-linux-${TARGETARCH} /usr/local/bin/dockerize

ENV HTTPD_PORT_HTTP="80" \
    HTTPD_PORT_HTTPS="443" \
    HTTPD_CORES="4" \
    HTTPD_THREADS_PER_CORE="64" \
    HTTPD_DUMPIO_INPUT="Off" \
    HTTPD_DUMPIO_OUTPUT="Off"

ENV PHP_XDEBUG_CLI_COLOR="0" \
    PHP_XDEBUG_CLIENT_DISCOVERY_HEADER="" \
    PHP_XDEBUG_CLIENT_HOST="host.docker.internal" \
    PHP_XDEBUG_CLIENT_PORT="9005" \
    PHP_XDEBUG_CLOUD_ID="" \
    PHP_XDEBUG_COLLECT_ASSIGNMENTS="0" \
    PHP_XDEBUG_COLLECT_RETURN="0" \
    PHP_XDEBUG_CONNECT_TIMEOUT_MS="200" \
    PHP_XDEBUG_DISCOVER_CLIENT_HOST="0" \
    PHP_XDEBUG_DUMP_COOKIE="" \
    PHP_XDEBUG_DUMP_FILES="" \
    PHP_XDEBUG_DUMP_GET="" \
    PHP_XDEBUG_DUMP_POST="" \
    PHP_XDEBUG_DUMP_REQUEST="" \
    PHP_XDEBUG_DUMP_SERVER="" \
    PHP_XDEBUG_DUMP_SESSION="" \
    PHP_XDEBUG_DUMP_GLOBALS="" \
    PHP_XDEBUG_DUMP_ONCE="" \
    PHP_XDEBUG_DUMP_UNDEFINED="" \
    PHP_XDEBUG_FILE_LINK_FORMAT="" \
    PHP_XDEBUG_FILENAME_FORMAT="...%s%n" \
    PHP_XDEBUG_FORCE_DISPLAY_ERRORS="0" \
    PHP_XDEBUG_FORCE_ERROR_REPORTING="0" \
    PHP_XDEBUG_GC_STATS_OUTPUT_NAME="gcstats.%p" \
    PHP_XDEBUG_HALT_LEVEL="0" \
    PHP_XDEBUG_IDEKEY="" \
    PHP_XDEBUG_LOG="/dev/stdout" \
    PHP_XDEBUG_LOG_LEVEL="7" \
    PHP_XDEBUG_MAX_NESTING_LEVEL="256" \
    PHP_XDEBUG_MAX_STACK_FRAMES="-1" \
    PHP_XDEBUG_MODE="off" \
    PHP_XDEBUG_OUTPUT_DIR="/var/www/codeprofiling/profiles" \
    PHP_XDEBUG_PROFILER_APPEND="0" \
    PHP_XDEBUG_PROFILER_OUTPUT_NAME="cachegrind.out.%p" \
    PHP_XDEBUG_SCREAM="0" \
    PHP_XDEBUG_SHOW_TRACE="0" \
    PHP_XDEBUG_SHOW_EXCEPTION_TRACE="0" \
    PHP_XDEBUG_SHOW_LOCAL_VARS="0" \
    PHP_XDEBUG_START_UPON_ERROR="default" \
    PHP_XDEBUG_START_WITH_REQUEST="trigger" \
    PHP_XDEBUG_TRACE_FORMAT="0" \
    PHP_XDEBUG_TRACE_OPTIONS="0" \
    PHP_XDEBUG_TRACE_OUTPUT_NAME="trace.%c" \
    PHP_XDEBUG_TRIGGER_VALUE="xdebug" \
    PHP_XDEBUG_USE_COMPRESSION="1" \
    PHP_XDEBUG_VAR_DISPLAY_MAX_CHILDREN="128" \
    PHP_XDEBUG_VAR_DISPLAY_MAX_DATA="512" \
    PHP_XDEBUG_VAR_DISPLAY_MAX_DEPTH="3"

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Building & Install Mod Security 2.9.11
RUN curl -sSL https://github.com/SpiderLabs/ModSecurity/releases/download/v2.9.11/modsecurity-v2.9.11.tar.gz | tar -C /tmp/ -xz && \
  cd /tmp/modsecurity-v2.9.11 && \
  ./autogen.sh && \
  ./configure && \
  make -j$(nproc) && \
  make install && \
  mkdir -p /etc/modsecurity && \
  cp ./modsecurity.conf-recommended /etc/modsecurity && \
  cp ./unicode.mapping /etc/modsecurity/unicode.mapping && \
  make clean && \
  cd / && \
  rm -rf /tmp/modsecurity-2.9.11

# Install Core ruleset 4.16.0
RUN curl -sSL https://github.com/coreruleset/coreruleset/archive/v4.16.0.tar.gz | tar -C /etc/modsecurity -xz && \
  mv /etc/modsecurity/coreruleset-4.16.0/crs-setup.conf.example /etc/modsecurity/coreruleset-4.16.0/crs-setup.conf

# Install WP cli
RUN curl ${WP_CLI_URL} -o /usr/local/bin/wp && \
  chmod +x /usr/local/bin/wp && \
  php -d memory_limit=-1 /usr/local/bin/wp package install https://github.com/runcommand/precache.git --allow-root

WORKDIR ${APP_DIR}
EXPOSE 80

ENTRYPOINT [ "/usr/local/bin/tini", "--", "/bootstrap.sh" ]
CMD ["httpd", "-DFOREGROUND"]
