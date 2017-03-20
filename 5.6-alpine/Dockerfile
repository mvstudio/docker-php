FROM alpine:3.5

ENV GOSU_VERSION=1.10
ENV GOSU_URL=https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64
ENV TINI_VERSION=0.13.2
ENV TINI_URL=https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static-amd64
ENV DOCKERIZE_VERSION=0.3.0
ENV DOCKERIZE_URL=https://github.com/jwilder/dockerize/releases/download/v${DOCKERIZE_VERSION}/dockerize-alpine-linux-amd64-v${DOCKERIZE_VERSION}.tar.gz

RUN echo '@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories && \
    echo '@community http://dl-cdn.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories

RUN apk --no-cache add \
      curl apache2 ssmtp git imagemagick diffutils openssl bash nodejs \
      php5 php5-apache2 php5-redis@testing php5-memcache php5-zip php5-mysqli \
      php5-pdo_mysql php5-mysql php5-ftp php5-imagick php5-gd php5-intl \
      php5-zlib php5-json php5-iconv php5-xml php5-ctype php5-dom php5-curl \
      php5-apcu php5-phar php5-openssl php5-opcache php5-soap

# fix missing dire for Apache2 PID file
RUN mkdir -p /run/apache2/

# move php.ini to the same location as in the php-apache image
RUN mkdir -p /usr/local/etc/php && \
    mv /etc/php5/php.ini /usr/local/etc/php/php.ini && \
    ln -s /usr/local/etc/php/php.ini /etc/php5/php.ini

# clean /var/www directory
RUN rm -Rf /var/www/* && \
    mkdir -p /var/www/html

COPY ./httpd.conf /etc/apache2/httpd.conf
COPY ./php5-module.conf /etc/apache2/conf.d/php5-module.conf

RUN curl -o /usr/local/bin/gosu -sSL ${GOSU_URL} && \
    chmod +x,u+s /usr/local/bin/gosu && \
    curl -o /usr/local/bin/tini -sSL ${TINI_URL} && \
    chmod +x,u+s /usr/local/bin/tini && \
    curl -sSL ${DOCKERIZE_URL} | tar -C /usr/local/bin -xz && \
    chmod +x /usr/local/bin/dockerize

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ENTRYPOINT [ "/usr/local/bin/tini", "--" ]
CMD ["httpd", "-DFOREGROUND"]
