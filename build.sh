#!/bin/sh

docker build \
  -t mvstudio/php:7-alpine \
  -t mvstudio/php:7.0-alpine \
  -t mvstudio/php:7.2-alpine \
  -t mvstudio/php:7.3-alpine \
  -t mvstudio/php:7.4-alpine \
  -t mvstudio/php:7.2-alpine-wordpress \
  -t mvstudio/php:7.4-alpine-wordpress \
  ./7-alpine

docker build \
  -t mvstudio/php:8-alpine \
  -t mvstudio/php:8.0-alpine-wordpress \
  ./8-alpine
