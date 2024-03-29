#!/usr/bin/env bash

set -eo pipefail

if [[ "${GITHUB_REF}" == refs/heads/main || "${GITHUB_REF}" == refs/tags/* ]]; then
    # Fetch the latest lighttpd version
    LIGHTTPD_BUILD_VERSION=$(curl -s https://download.lighttpd.net/lighttpd/releases-1.4.x/latest.txt | grep -oP 'lighttpd-\K[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -n1) || true
    # Fetch the php version from docker hub
    docker pull php:${PHP_VERSION}-fpm-alpine
    PHP_BUILD_VERSION=$(docker inspect -f '{{ index .Config.Env }}' php:${PHP_VERSION}-fpm-alpine | grep -oP 'PHP_VERSION=\K[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -n1) || true

    # Pull the siebsie23/php-lighttpd image to check if the lighttpd and php version already exists
    docker pull siebsie23/php-lighttpd:${PHP_VERSION}-alpine || true
    EXISTING_LIGHTTPD_BUILD_VERSION=$(docker inspect -f '{{ index .Config.Labels "LIGHTTPD_VERSION" }}' siebsie23/php-lighttpd:${PHP_VERSION}-alpine) || true
    EXISTING_PHP_BUILD_VERSION=$(docker inspect -f '{{ index .Config.Labels "PHP_VERSION" }}' siebsie23/php-lighttpd:${PHP_VERSION}-alpine) || true

    if [[ "${LIGHTTPD_BUILD_VERSION}" == "${EXISTING_LIGHTTPD_BUILD_VERSION}" && "${PHP_BUILD_VERSION}" == "${EXISTING_PHP_BUILD_VERSION}" ]]; then
        echo "The image siebsie23/php-lighttpd:${PHP_VERSION} with lighttpd ${LIGHTTPD_BUILD_VERSION} and php ${PHP_BUILD_VERSION} already exists. Skipping the build."
        exit 0
    fi

    docker login -u "${DOCKER_USERNAME}" -p "${DOCKER_PASSWORD}";
    make buildx-push-all PHP_VERSION="${PHP_VERSION}" LIGHTTPD_BUILD_VERSION="${LIGHTTPD_BUILD_VERSION}" PHP_BUILD_VERSION=${PHP_BUILD_VERSION};
else
    make buildx-build-all PHP_VERSION="${PHP_VERSION}";
fi
