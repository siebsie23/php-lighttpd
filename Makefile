build: # Build single image image. Usage: make build PHP_VERSION="phpversion" DISTRO="distro"
	@docker build --no-cache --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` --build-arg VCS_REF=`git rev-parse --short HEAD` --build-arg PHP_VER="$(PHP_VERSION)" -t siebsie23/php-lighttpd:$(PHP_VERSION)-$(DISTRO) -f docker/$(DISTRO).Dockerfile docker

build-all: # Build all images with a specific PHP version. Usage: make build-all PHP_VERSION="phpversion"
	make build PHP_VERSION="$(PHP_VERSION)" DISTRO="alpine"
	make build PHP_VERSION="$(PHP_VERSION)" DISTRO="bullseye"

push-all: # Push all built distro images to Docker Hub. Usage: make push-all PHP_VERSION="phpversion"
	@docker push siebsie23/php-lighttpd:$(PHP_VERSION)-alpine
	@docker push siebsie23/php-lighttpd:$(PHP_VERSION)-bullseye

build-and-push: # Build and push all images with a specific PHP version. Usage: make build-and-push PHP_VERSION="phpversion"
	make build-all PHP_VERSION="$(PHP_VERSION)"
	make push-all PHP_VERSION="$(PHP_VERSION)"

clean: # Clean all containers and images on the system
	-@docker ps -a -q | xargs docker rm -f
	-@docker images -q | xargs docker rmi -f