# PHP-Lighttpd

[![GitHub](https://img.shields.io/badge/Star_on-GitHub-8A2BE2)](https://github.com/siebsie23/php-lighttpd)
[![Build Status](https://img.shields.io/github/actions/workflow/status/siebsie23/php-lighttpd/.github%2Fworkflows%2Fbuild-and-push.yml)](https://github.com/siebsie23/docker-postal/actions)

* * *

## About

PHP-Lighttpd is a Dockerfile to build a [Lighttpd](https://www.lighttpd.net/) image with PHP-FPM and FastCGI.

## Installation

### Use the pre-built package
Prebuilt images are built weekly and are available on [Docker Hub](https://hub.docker.com/repository/docker/siebsie23/php-lighttpd) at `siebsie23/php-lighttpd`

The images are built on multiple distros which can be found in the table below. All images are built to support the `amd64` and `arm64` architectures.

**Available tags**:
| PHP Version | Tags |
| ------------- | --------|
| 8.3 | `8.3-alpine` <br/> `8.3-bullseye` |
| 8.2 | `8.2-alpine` <br/> `8.2-bullseye` |
| 8.1 | `8.1-alpine` <br/> `8.1-bullseye` |
| 8.0 | `8.0-alpine` <br/> `8.0-bullseye` |

### Build from Source
Clone the git repository and build the image with `make build PHP_VERSION="phpversion" DISTRO="distro"` phpversion being a valid php-fpm docker image version and distro being one of `alpine` or `bullseye`.

## Configuration

### Quick Start

* The quickest way to get started is by using a prebuilt image i.e. `siebsie23/php-lighttpd:8.3-alpine` and linking the `/var/www/` directory to a host directory containing your HTML or PHP files.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.

### Persistent Storage

The following directories are used for configuration and can be mapped for persistent storage.

| Directory        | Description                                    |
| ---------------- | ---------------------------------------------- |
| `/var/www/`      | Directory to serve your static or PHP files.   |

### Base Images used

This image relies on the official [PHP](https://hub.docker.com/_/php)-fpm image.
While building either one of the following is used based on the requested distribution:
- php:*-fpm-alpine
- php:*-fpm-bullseye

### Networking

| Port   | Description                         |
| ------ | ----------------------------------- |
| `80`   | Default port serving your web files |

* * *
## Support

### Bugfixes
- Please, submit a [Bug Report](issues/new) if something isn't working as expected. I'll do my best to issue a fix in short order.

## License
GNU GPLv3. See [LICENSE](LICENSE) for more details.
