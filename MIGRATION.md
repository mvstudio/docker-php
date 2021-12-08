# PHP Docker base images migration guide

## Update docker `FROM` directive

The new mvstudio/php:7-alpine and mvstudio/php:8-alpine are drop in replacement compatible with the previous generation of php docker base images.

From

```Dockerfile
FROM mvstudio/php:7.0-alpine
# or
FROM mvstudio/php:7.2-alpine
# or
FROM mvstudio/php:7.2-alpine-extra
# or
FROM mvstudio/php:7.2-alpine-wordpress
# or
FROM mvstudio/php:7.3-alpine
# or
FROM mvstudio/php:7.4-alpine
# or
FROM mvstudio/php:7.4-alpine-wordpress
# or
FROM mvstudio/php:8.0-alpine
```

To

```Dockerfile
FROM mvstudio/php:7-alpine
# or
FROM mvstudio/php:8-alpine
```

## Remove unecessary configs

The new mvstudio/php:7-alpine and mvstudio/php:8-alpine images already contains an optimised php.ini config.

Thus the following directive can be safely removed from your Dockerfile.

```Dockerfile
COPY ./configs /opt/configs
```

Also the configs directory can be deleted from your repository unless it contains more file than `configs/php.inc.tmpl` in which case only that file can be safely deleted.

The file `scripts/php.inc` becomes uncessary and **must** be deleted and the line `source "${SCRIPTS_PATH}/php.inc"` if present in your `scripts/entrypoint.sh` **must** be removed.

## Remove unecessary env vars

The new mvstudio/php:7-alpine and mvstudio/php:8-alpine images already contains the basic env vars needed.

Thus the following env var declaration can be safely removed unless the value is different.

- `APP_DIR="/var/www/html"`
- `APP_USER="apache"`
- `APP_GROUP="apache"`
- `WP_CLI_PACKAGES_DIR="/tmp/.wp-cli-packages/"`
- `WP_CLI_CACHE_DIR="/tmp/.wp-cli-cache/"`
- `WP_CLI_URL="https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar"`

## Remove unecessary tools/packages installation

The new mvstudio/php:7-alpine and mvstudio/php:8-alpine images come with a buch of already installed packages and tools.

See [PHP 7 docker image Readme](https://github.com/mvstudio/docker-php/blob/master/7-alpine/README.md) to get the list of already installed tools and packages.

### Example of directives that can be removed/replaced

From

```Dockerfile
RUN cd ${APP_DIR} && \
    curl ${WP_CLI_URL} -o /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wp && \
    php -d memory_limit=-1 /usr/local/bin/wp package install https://github.com/runcommand/precache.git && \
    wp core download --version=${WP_VERSION} --locale=fr_FR
```

To

```Dockerfile
RUN wp core download --version=${WP_VERSION} --locale=fr_FR --allow-root
```

## Remove unecessary directives

The new mvstudio/php:7-alpine and mvstudio/php:8-alpine images come with prebaked `WORKDIR`, `ENTRYPOINT`, `COMMAND`, `EXPOSE` directives.

Thus those directives can be safely removed unless explicitly set with a different value.

```Dockerfile
CMD [ "httpd", "-DFOREGROUND" ]
```

```Dockerfile
WORKDIR ${APP_DIR}
```

```Dockerfile
EXPOSE 80
```

```Dockerfile
ENTRYPOINT [ "/usr/local/bin/tini", "--", "/bin/sh", "/opt/bootstrap.sh" ]
```

## Remove unecessary scripts

The new mvstudio/php:7-alpine and mvstudio/php:8-alpine images come with prebaked `bootstrap.sh`

The `scripts/bootstrap.sh` script can be safely deleted from you repository.
