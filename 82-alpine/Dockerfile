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
  php82@community php82-apache2@community php82-common@community php82-ctype@community \
  php82-curl@community php82-dev@community php82-dom@community php82-fileinfo@community \
  php82-ftp@community php82-gd@community php82-iconv@community php82-intl@community \
  php82-json@community php82-mbstring@community php82-mysqli@community php82-opcache@community \
  php82-openssl@community php82-pdo@community php82-pdo_mysql@community php82-pecl-apcu@community \
  php82-pecl-redis@community php82-pecl-xdebug@community php82-phar@community \
  php82-posix@community php82-session@community php82-simplexml@community php82-soap@community \
  php82-sodium@community php82-tokenizer@community php82-xml@community php82-xmlreader@community \
  php82-xmlwriter@community php82-zip@community php82-zlib@community \
  shadow@community ssmtp sudo@community ttf-dejavu@316main ttf-droid ttf-freefont@316main \
  ttf-liberation yajl yajl-dev

# fix missing dir for Apache2 PID file
RUN mkdir -p /run/apache2/

# create symlink for php executable php -> php82
RUN ln -s /usr/bin/php82 /usr/bin/php

# move php.ini to the same location as in the php-apache image (back compat)
RUN mkdir -p /usr/local/etc/php && \
  cp /etc/php82/php.ini /usr/local/etc/php/php.ini
  # ln -s /usr/local/etc/php/php.ini /etc/php82/conf.d/20_php.ini

# clean /var/www directory
RUN rm -Rf /var/www/* && \
  mkdir -p /var/www/html

COPY ./bootstrap.sh /bootstrap.sh
COPY ./entrypoint.sh /entrypoint.sh
COPY ./httpd.conf /etc/apache2/httpd.conf
COPY ./php.ini /etc/php82/conf.d/mvstudio.ini
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

ENTRYPOINT [ "/usr/local/bin/tini", "--", "/bootstrap.sh" ]
CMD ["httpd", "-DFOREGROUND"]
