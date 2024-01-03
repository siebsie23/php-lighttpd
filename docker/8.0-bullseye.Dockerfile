FROM php:8.0-fpm-bullseye

ARG BUILD_DATE
ARG VCS_REF

USER root

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/siebsie23/php-lighttpd.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.name="php-lighttpd" \
      org.label-schema.description="Docker image with PHP 8.0, Lighttpd and Alpine" \
      org.label-schema.url="https://github.com/siebsie23/php-lighttpd"

# PHP_INI_DIR to be symmetrical with official php docker image
ENV PHP_INI_DIR /usr/local/etc/php

# When using Composer, disable the warning about running commands as root/super user
ENV COMPOSER_ALLOW_SUPERUSER=1

# Persistent runtime dependencies
ARG DEPS="\
        lighttpd \
        curl \
        ca-certificates \
        runit \
        procps \
"

RUN apt-get update && apt-get install -y --no-install-recommends $DEPS && rm -rf /var/lib/apt/lists/*

# Delete the service directory before copying the new one
RUN rm -rf /etc/service

COPY config /
COPY config-bullseye /

# Set the correct permission for the /var/wwww folder for www-data user
RUN chown -R www-data:www-data /var/www

WORKDIR /var/www

EXPOSE 80

CMD ["/sbin/runit-wrapper"]