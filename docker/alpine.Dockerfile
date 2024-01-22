ARG PHP_VER

FROM php:${PHP_VER}-fpm-alpine

ARG BUILD_DATE
ARG VCS_REF

USER root

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/siebsie23/php-lighttpd.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.name="php-lighttpd" \
      org.label-schema.description="Docker image with PHP ${PHP_VER}, Lighttpd and Alpine" \
      org.label-schema.url="https://github.com/siebsie23/php-lighttpd"

# PHP_INI_DIR to be symmetrical with official php docker image
ENV PHP_INI_DIR /usr/local/etc/php

# Persistent runtime dependencies
ARG DEPS="\
        lighttpd \
        curl \
        ca-certificates \
        runit \
"

RUN apk add --no-cache $DEPS

COPY config /
COPY config-alpine /

# Set the correct folder permissions for the www-data user
RUN touch /env && chown www-data:www-data /env \
    && chown -R www-data:www-data /var/www \
    && mkdir -p /var/cache/lighttpd \
    && chown -R www-data:www-data /var/cache/lighttpd

# Set the home directory of the www-data user to /var/www
RUN sed -i "s|/home/www-data|/var/www|g" /etc/passwd

WORKDIR /var/www

USER www-data

EXPOSE 80

CMD ["/sbin/runit-wrapper"]