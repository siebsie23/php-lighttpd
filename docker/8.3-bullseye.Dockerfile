FROM php:8.3-fpm-bullseye

ARG BUILD_DATE
ARG VCS_REF

USER root

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/siebsie23/php-lighttpd.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.name="php-lighttpd" \
      org.label-schema.description="Docker image with PHP 8.3, Lighttpd and Alpine" \
      org.label-schema.url="https://github.com/siebsie23/php-lighttpd"

# PHP_INI_DIR to be symmetrical with official php docker image
ENV PHP_INI_DIR /usr/local/etc/php

# When using Composer, disable the warning about running commands as root/super user
ENV COMPOSER_ALLOW_SUPERUSER=1

# Persistent runtime dependencies
ARG DEPS="\
        autoconf \
        automake \
        libtool \
        m4 \
        pkg-config \
        libpcre2-posix2 \
        libpcre2-dev \
        liblua5.4 \
        liblua5.4-dev \
        libnettle8 \
        nettle-dev \
        zlib1g \
        zlib1g-dev \
        libzstd1 \
        libzstd-dev \
        libbrotli1 \
        libbrotli-dev \
        libdeflate0 \
        libdeflate-dev \
        curl \
        ca-certificates \
        runit \
        procps \
"

RUN apt-get update && apt-get install -y --no-install-recommends $DEPS && rm -rf /var/lib/apt/lists/*

# Download the latest lighttpd
RUN latest=$(curl -s https://download.lighttpd.net/lighttpd/releases-1.4.x/latest.txt) \
      && curl -o "$latest.tar.xz" https://download.lighttpd.net/lighttpd/releases-1.4.x/"$latest.tar.xz" \
      && tar -xJf "$latest.tar.xz" \
      && cd "$latest"

# Build lighttpd
RUN cd lighttpd-* \
      && ./autogen.sh \
      && ./configure -C --prefix=/usr --with-zlib --with-zstd --with-brotli --with-libdeflate \
      && make \
      && make install \
      && cd .. \
      && rm -rf lighttpd-* \
      && rm -rf "$latest.tar.xz"

# Delete the service directory before copying the new one
RUN rm -rf /etc/service

# Create the Lighttpd compression cache directory
RUN mkdir -p /var/cache/lighttpd/compress

COPY config /
COPY config-bullseye /

# Set the correct permission for the /var/wwww folder for www-data user
RUN chown -R www-data:www-data /var/www

WORKDIR /var/www

EXPOSE 80

CMD ["/sbin/runit-wrapper"]