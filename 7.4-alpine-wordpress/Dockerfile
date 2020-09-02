FROM alpine:3.11

ENV GOSU_URL=https://github.com/tianon/gosu/releases/download/1.12/gosu-amd64 \
    TINI_URL=https://github.com/krallin/tini/releases/download/v0.19.0/tini-static-amd64 \
    DOCKERIZE_URL=https://github.com/jwilder/dockerize/releases/download/v0.6.1/dockerize-alpine-linux-amd64-v0.6.1.tar.gz \
    INSTALL_PHP_EXTENSIONS_URL=https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions

ADD https://dl.bintray.com/php-alpine/key/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub

RUN apk --update add ca-certificates && \
    echo "https://dl.bintray.com/php-alpine/v3.11/php-7.4" >> /etc/apk/repositories && \
    # Install apache2 and other packages
    apk --update add \
    apache2 \
    bash \
    curl \
    diffutils \
    g++ \
    gcc \
    git \
    make \
    nodejs \
    npm \
    php7 \
    php7-apache2 \
    php7-apcu \
    php7-common \
    php7-ctype \
    php7-curl \
    php7-dom \
    php7-ftp \
    php7-gd \
    php7-iconv \
    php7-intl \
    php7-json \
    php7-mbstring \
    php7-mysqli \
    php7-opcache \
    php7-openssl \
    php7-pdo \
    php7-pdo_mysql \
    php7-phar \
    php7-posix \
    php7-redis \
    php7-session \
    php7-soap \
    php7-sodium \
    php7-xml \
    php7-xmlreader \
    php7-xmlrpc \
    php7-zip \
    php7-zlib \
    python2 \
    shadow \
    ssmtp && \
    # Compile & install ModSecurity 2
    apk --no-cache add automake autoconf libtool pcre-dev pcre geoip-dev geoip \
    yajl-dev yajl lmdb-dev lmdb libxml2-dev libxml2 lua5.3-dev lua5.3 linux-headers apache2-dev apr apr-dev apr-util apr-util-dev && \
    cd /root && \
    git clone git://github.com/SpiderLabs/ModSecurity.git && \
    cd ModSecurity && \
    git checkout v2/master && \
    ./autogen.sh && \
    ./configure && \
    make -j$(nproc) && \
    make install && \
    mkdir -p /etc/modsecurity && \
    cp ./modsecurity.conf-recommended /etc/modsecurity && \
    cp ./unicode.mapping /etc/modsecurity/unicode.mapping && \
    make clean && \
    cd .. && \
    rm -rf ./ModSecurity && \
    curl -sSL https://github.com/coreruleset/coreruleset/archive/v3.3.0.tar.gz | tar -C /etc/modsecurity -xz && \
    mv /etc/modsecurity/coreruleset-3.3.0/crs-setup.conf.example /etc/modsecurity/coreruleset-3.3.0/crs-setup.conf && \
    # Setup apache2 run dir
    mkdir -p /run/apache2/ && \
    # Clean /var/www
    rm -Rf /var/www/* && \
    mkdir -p /var/www/html && \
    # Install gosu
    curl -o /usr/local/bin/gosu -sSL ${GOSU_URL} && \
    chmod +x,u+s /usr/local/bin/gosu && \
    # Install tini
    curl -o /usr/local/bin/tini -sSL ${TINI_URL} && \
    chmod +x,u+s /usr/local/bin/tini && \
    # Install dockerize
    curl -sSL ${DOCKERIZE_URL} | tar -C /usr/local/bin -xz && \
    chmod +x /usr/local/bin/dockerize && \
    # Install composer
    ln -s /usr/bin/php7 /usr/bin/php && \
    curl -sS https://getcomposer.org/installer | php7 -- --install-dir=/usr/local/bin --filename=composer && \
    # Final cleanup
    rm -rf /var/cache/apk/*

COPY ./httpd.conf /etc/apache2/httpd.conf

ENTRYPOINT [ "/usr/local/bin/tini", "--" ]
CMD ["httpd", "-DFOREGROUND"]
