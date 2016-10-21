FROM php:5.5-apache

ENV GOSU_VERSION 1.0
ENV PHP_EXT_REDIS_VERSION 2.2.7
ENV PHP_EXT_MEMCACHED_VERSION 2.2.0

# Debian/Ubuntu package update
RUN apt-get update && \
    apt-get upgrade -y

# Extension compilation dependencies
RUN apt-get install \
      zlib1g \
      zlib1g-dev \
      libssl-dev \
      libmemcached-dev \
      libpng12-dev \
      libjpeg62-turbo-dev \
      libmagickwand-dev \
      libicu-dev \
      libxml2-dev \
      libfreetype6-dev \
    -y --no-install-recommends

# Other commonly needed packages
RUN apt-get install \
      ssmtp \
      imagemagick \
      git \
      build-essential \
    -y --no-install-recommends

# APT Cleanup
RUN rm -r /var/lib/apt/lists/*

# PHP Extensions
## redis
RUN pecl install redis-${PHP_EXT_REDIS_VERSION} && \
    docker-php-ext-enable redis

## memcached
RUN pecl install memcached-${PHP_EXT_MEMCACHED_VERSION} && \
    docker-php-ext-enable memcached

## mbstring
RUN docker-php-ext-install mbstring

## zip
RUN docker-php-ext-install zip

## mysqli
RUN docker-php-ext-install mysqli

## pdo_mysql
RUN docker-php-ext-install pdo_mysql

## ftp
RUN docker-php-ext-install ftp

## imagick
RUN pecl install imagick && \
    docker-php-ext-enable imagick

## GD
RUN docker-php-ext-configure gd \
      --enable-gd-native-ttf \
      --with-freetype-dir=/usr/include/freetype2 \
      --with-png-dir=/usr/include \
      --with-jpeg-dir=/usr/include && \
    docker-php-ext-install gd

## intl
RUN docker-php-ext-install intl

# Apache2
## Enabled mod rewrite
RUN a2enmod rewrite

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# gosu
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu" && \
    chmod +x,u+s /usr/local/bin/gosu

# tini
ADD https://github.com/krallin/tini/releases/download/v0.10.0/tini /usr/local/bin/tini
RUN chmod +x /usr/local/bin/tini

# dockerize
RUN curl -sSL https://github.com/jwilder/dockerize/releases/download/v0.2.0/dockerize-linux-amd64-v0.2.0.tar.gz | tar -C /usr/local/bin -xzv && \
    chmod +x /usr/local/bin/dockerize

ENTRYPOINT [ "/usr/local/bin/tini", "--" ]
CMD ["apache2-foreground"]
