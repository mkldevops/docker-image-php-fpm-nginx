ARG PHP_VERSION=8.2

################################################################################
# Base image
#
# It contains every needed dependencies
################################################################################

FROM php:${PHP_VERSION}-fpm-alpine AS base

# php extensions installer: https://github.com/mlocati/docker-php-extension-installer
COPY --from=mlocati/php-extension-installer --link /usr/bin/install-php-extensions /usr/local/bin/

RUN apk update && \
    apk add --no-cache $PHPIZE_DEPS git build-base nginx supervisor shadow && \
    addgroup -S app_group && \
    adduser \
        --disabled-password \
        --home "$(pwd)" \
        --ingroup app_group \
        --no-create-home \
        app_user && \
    install-php-extensions @composer xsl pdo_mysql intl opcache apcu sysvsem uuid

# Configure nginx
COPY etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY etc/nginx/conf.d /etc/nginx/conf.d/

# Configure PHP-FPM
COPY etc/php-fpm.d /usr/local/etc/php-fpm.d/
COPY etc/php/conf.d/php.ini /usr/local/etc/php/conf.d/custom.ini

# Configure supervisord
COPY etc/supervisor/conf.d/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Make sure files/folders needed by the processes are accessable when they run
# under the nobody user
RUN chown -R app_user.app_group /var/www /run /var/lib/nginx /var/log/nginx

# Expose the port nginx is reachable on
EXPOSE 80

# Let supervisord start nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]


################################################################################
# Builder image
#
# It contains every needed dependencies and make sure it runs as a non-root user
# It serves as deployment purpose only
################################################################################

FROM base AS builder

# Switch to use a non-root user from here on
USER app_user

# Add application
COPY --chown=app_user src/ /var/www/html/public


################################################################################
# CI image
#
# Base image, plus pcov (needed to get the code coverage and report)
################################################################################

FROM base AS ci

RUN install-php-extensions pcov

USER app_user


################################################################################
# Builder image
#
# It contains every needed dependencies and make sure it runs as a non-root user
# It serves as deployment purpose only
################################################################################

FROM base AS dev

RUN install-php-extensions xdebug-^3.2
