build: # Build single image image. Usage: make build TAG="phpversion"
	@docker build --no-cache --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` --build-arg VCS_REF=`git rev-parse --short HEAD` -t siebsie23/php-lighttpd:$(TAG) -f docker/$(TAG).Dockerfile docker

build-80: # 8.0
	make build TAG="8.0-alpine"

build-81: # 8.1
	make build TAG="8.1-alpine"

build-82: # 8.2
	make build TAG="8.2-alpine"

build-83: # 8.3
	make build TAG="8.3-alpine"

build-all: # Build all images
	make build-80
	make build-81
	make build-82
	make build-83

push-80: # Push built 8.0 image to Docker Hub
	@docker push siebsie23/php-lighttpd:8.0-alpine

push-81: # Push built 8.1 image to Docker Hub
	@docker push siebsie23/php-lighttpd:8.1-alpine

push-82: # Push built 8.2 image to Docker Hub
	@docker push siebsie23/php-lighttpd:8.2-alpine

push-83: # Push built 8.3 image to Docker Hub
	@docker push siebsie23/php-lighttpd:8.3-alpine

push-all: # Push all built images to Docker Hub
	make push-80
	make push-81
	make push-82
	make push-83

build-and-push-83: # Build and push 8.3 image to Docker Hub
	make build-80
	make build-81
	make build-82
	make build-83
	make push-80
	make push-81
	make push-82
	make push-83

build-and-push: # Build all images and push them to Docker Hub
	make build-all
	make push-all

clean: # Clean all containers and images on the system
	-@docker ps -a -q | xargs docker rm -f
	-@docker images -q | xargs docker rmi -f