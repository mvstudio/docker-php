FROM alpine:3.8

ENV GOSU_VERSION=1.10
ENV GOSU_URL=https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64
ENV TINI_VERSION=0.13.2
ENV TINI_URL=https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static-amd64
ENV DOCKERIZE_VERSION=0.3.0
ENV DOCKERIZE_URL=https://github.com/jwilder/dockerize/releases/download/v${DOCKERIZE_VERSION}/dockerize-alpine-linux-amd64-v${DOCKERIZE_VERSION}.tar.gz

RUN echo '@testing http://nl.alpinelinux.org/alpine/3.8/testing' >> /etc/apk/repositories && \
    echo '@community http://nl.alpinelinux.org/alpine/3.8/community' >> /etc/apk/repositories

RUN apk --no-cache add \
    curl apache2 ssmtp git imagemagick diffutils openssl bash nodejs npm \
    php7 php7-common php7-apache2 php7-redis php7-zip php7-mysqli \
    php7-pdo_mysql php7-ftp php7-gd php7-intl \
    php7-zlib php7-json php7-iconv php7-xml php7-ctype php7-dom php7-curl \
    php7-apcu php7-phar php7-openssl php7-opcache php7-tokenizer \
    python2 make gcc g++ php-soap shadow freetype-dev libjpeg-turbo-dev libpng-dev \
    php7-mbstring php7-zip php7-simplexml


# fix missing dire for Apache2 PID file
RUN mkdir -p /run/apache2/

# move php.ini to the same location as in the php-apache image
RUN mkdir -p /usr/local/etc/php && \
    mv /etc/php7/php.ini /usr/local/etc/php/php.ini && \
    ln -s /usr/local/etc/php/php.ini /etc/php7/php.ini

# clean /var/www directory
RUN rm -Rf /var/www/* && \
    mkdir -p /var/www/html

COPY ./httpd.conf /etc/apache2/httpd.conf
COPY ./php7-module.conf /etc/apache2/conf.d/php7-module.conf

RUN curl -o /usr/local/bin/gosu -sSL ${GOSU_URL} && \
    chmod +x,u+s /usr/local/bin/gosu && \
    curl -o /usr/local/bin/tini -sSL ${TINI_URL} && \
    chmod +x,u+s /usr/local/bin/tini && \
    curl -sSL ${DOCKERIZE_URL} | tar -C /usr/local/bin -xz && \
    chmod +x /usr/local/bin/dockerize

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ENTRYPOINT [ "/usr/local/bin/tini", "--" ]
CMD ["httpd", "-DFOREGROUND"]
