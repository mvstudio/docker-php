FROM php:5.4-apache

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
    -y --no-install-recommends

# Other commonly needed packages
RUN apt-get install \
      ssmtp \
      imagemagick \
      git \
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

# Apache2
## Enabled mod rewrite
RUN a2enmod rewrite

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# gosu
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu" && \
    chmod +x,u+s /usr/local/bin/gosu
