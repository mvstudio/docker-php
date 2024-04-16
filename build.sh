#!/bin/sh

docker build \
  -t ghcr.io/mvstudio/php:7-alpine \
  -t ghcr.io/mvstudio/php:7.0-alpine \
  -t ghcr.io/mvstudio/php:7.2-alpine \
  -t ghcr.io/mvstudio/php:7.3-alpine \
  -t ghcr.io/mvstudio/php:7.4-alpine \
  -t ghcr.io/mvstudio/php:7.2-alpine-wordpress \
  -t ghcr.io/mvstudio/php:7.4-alpine-wordpress \
  ./7-alpine

docker build \
  -t ghcr.io/mvstudio/php:8-alpine \
  -t ghcr.io/mvstudio/php:8.0-alpine-wordpress \
  ./8-alpine

docker build \
  -t ghcr.io/mvstudio/php:81-alpine \
  ./81-alpine

docker build \
  -t ghcr.io/mvstudio/php:82-alpine \
  ./82-alpine

docker build \
  -t ghcr.io/mvstudio/php:83-alpine \
  ./83-alpine
