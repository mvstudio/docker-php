FROM mvstudio/php:7.2-alpine

# S6
RUN apk --no-cache add gcc g++ make && \
    curl -sSL http://skarnet.org/software/s6/s6-2.4.0.0.tar.gz | tar -C /tmp -xz && \
    curl -sSL http://skarnet.org/software/skalibs/skalibs-2.4.0.1.tar.gz | tar -C /tmp -xz && \
    curl -sSL http://skarnet.org/software/execline/execline-2.2.0.0.tar.gz | tar -C /tmp -xz && \
    cd /tmp/skalibs-2.4.0.1 && \
    ./configure && make && make install && \
    cd /tmp/execline-2.2.0.0 && \
    ./configure && make && make install && \
    cd /tmp/s6-2.4.0.0 && \
    ./configure && make && make install && \
    cd && rm -Rf /tmp/* && \
    apk --no-cache del --purge gcc g++ make
