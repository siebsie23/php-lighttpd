PHP_VERSION ?= 8.3
PLATFORM ?= linux/amd64
PHP_BUILD_VERSION ?= 8.3.0
LIGHTTPD_BUILD_VERSION ?= 1.4.73

build: # Build single image image. Usage: make build PHP_VERSION="phpversion" DISTRO="distro"
	@docker build --no-cache --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` --build-arg VCS_REF=`git rev-parse --short HEAD` --build-arg PHP_VER="$(PHP_VERSION)" -t siebsie23/php-lighttpd:$(PHP_VERSION)-$(DISTRO) -f $(DISTRO).Dockerfile .

buildx-build: # Build single image image. Usage: make buildx-build PHP_VERSION="phpversion" DISTRO="distro"
	@docker buildx build --no-cache --platform $(PLATFORM) --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` --build-arg VCS_REF=`git rev-parse --short HEAD` --build-arg PHP_VER="$(PHP_VERSION)" --build-arg PHP_BUILD_VERSION="$(PHP_BUILD_VERSION)" --build-arg LIGHTTPD_BUILD_VERSION="$(LIGHTTPD_BUILD_VERSION)" -t siebsie23/php-lighttpd:$(PHP_VERSION)-$(DISTRO) -f $(DISTRO).Dockerfile .

buildx-push: # Build and push single image image. Usage: make buildx-push PHP_VERSION="phpversion" DISTRO="distro"
	@docker buildx build --no-cache --platform $(PLATFORM) --push --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` --build-arg VCS_REF=`git rev-parse --short HEAD` --build-arg PHP_VER="$(PHP_VERSION)" --build-arg PHP_BUILD_VERSION="$(PHP_BUILD_VERSION)" --build-arg LIGHTTPD_BUILD_VERSION="$(LIGHTTPD_BUILD_VERSION)" -t siebsie23/php-lighttpd:$(PHP_VERSION)-$(DISTRO) -f $(DISTRO).Dockerfile .

build-all: # Build all images with a specific PHP version. Usage: make build-all PHP_VERSION="phpversion"
	make build PHP_VERSION="$(PHP_VERSION)" DISTRO="alpine"
	make build PHP_VERSION="$(PHP_VERSION)" DISTRO="bullseye"

buildx-build-all: # Build all images with a specific PHP version. Usage: make buildx-build-all PHP_VERSION="phpversion"
	make buildx-build PHP_VERSION="$(PHP_VERSION)" PHP_BUILD_VERSION="$(PHP_BUILD_VERSION)" LIGHTTPD_BUILD_VERSION="$(LIGHTTPD_BUILD_VERSION)" DISTRO="alpine"
	make buildx-build PHP_VERSION="$(PHP_VERSION)" PHP_BUILD_VERSION="$(PHP_BUILD_VERSION)" LIGHTTPD_BUILD_VERSION="$(LIGHTTPD_BUILD_VERSION)" DISTRO="bullseye"

buildx-push-all: # Build and push all images with a specific PHP version. Usage: make buildx-push-all PHP_VERSION="phpversion"
	make buildx-push PHP_VERSION="$(PHP_VERSION)" PHP_BUILD_VERSION="$(PHP_BUILD_VERSION)" LIGHTTPD_BUILD_VERSION="$(LIGHTTPD_BUILD_VERSION)" DISTRO="alpine"
	make buildx-push PHP_VERSION="$(PHP_VERSION)" PHP_BUILD_VERSION="$(PHP_BUILD_VERSION)" LIGHTTPD_BUILD_VERSION="$(LIGHTTPD_BUILD_VERSION)" DISTRO="bullseye"

clean: # Clean all containers and images on the system
	-@docker ps -a -q | xargs docker rm -f
	-@docker images -q | xargs docker rmi -f