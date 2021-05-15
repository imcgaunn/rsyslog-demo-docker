.SHELL := /bin/bash
.DEFAULT_GOAL := help

.PHONY : help
help :
	@echo "'make help' to print list of available targets"
	@echo "'make build-app-image' to build docker image for an app emitting log messages"
	@echo "'make build-log-image' to build docker image for rsyslog 'sink' server that will accept log messages"
	@echo "'make start-docker-network' to create docker bridge network to which all containers will be attached"
	@echo "'make stop-docker-network' to stop and remove all running containers and remove network"
	@echo "'make start-app-servers' to start a few copies of the 'app' docker image and attach them to network"
	@echo "'make stop-app-servers' to stop and remove all running copies of the 'app' docker image"
	@echo "'make start-log-servers' to start a couple copies of the 'log' docker image and attach them to network"
	@echo "'make stop-log-servers' to stop all running copies of the 'log' docker image and remove them"

.PHONY : build-app-image
APP_IMAGE_NAME := rsyslog-example-app
build-app-image: app-node/Dockerfile
	cd app-node && docker build -t $(APP_IMAGE_NAME) .

.PHONY : build-log-image
LOG_IMAGE_NAME := rsyslog-example-logserver
build-log-image: log-node/Dockerfile
	cd log-node && docker build -t $(LOG_IMAGE_NAME) .

.PHONY : fmt
fmt :
	@echo "running formatter on project"
	prettier -w .

### starting/stopping experiments
DOCKER_NETWORK := rsyslognet
.PHONY : start-docker-network
start-docker-network : | stop-docker-network
	@echo "creating docker bridge network"
	docker network create --attachable --driver bridge --subnet 10.8.9.0/24 $(DOCKER_NETWORK)

.PHONY : stop-docker-network
stop-docker-network : | stop-all-containers
	@echo "stopping and removing docker bridge network"
	-docker network rm $(DOCKER_NETWORK)

.PHONY : start-app-servers
start-app-servers : | stop-app-servers start-docker-network
	@echo "starting app server containers"
	docker run --name rsys-app-1 --network $(DOCKER_NETWORK) -dit $(APP_IMAGE_NAME)
	docker run --name rsys-app-2 --network $(DOCKER_NETWORK) -dit $(APP_IMAGE_NAME)
	docker run --name rsys-app-3 --network $(DOCKER_NETWORK) -dit $(APP_IMAGE_NAME)

.PHONY : stop-app-servers
stop-app-servers :
	@echo "shutting down and removing app server containers"
	-docker rm -f rsys-app-1
	-docker rm -f rsys-app-2
	-docker rm -f rsys-app-3

.PHONY : start-log-servers
start-log-servers :
	@echo "starting log server containers"
	docker run --name rsys-log-1 -dit $(LOG_IMAGE_NAME)
	docker run --name rsys-log-2 -dit $(LOG_IMAGE_NAME)

.PHONY : stop-log-servers
stop-log-servers :
	@echo "shutting down and removing log server containers"
	-docker rm -f rsys-log-1
	-docker rm -f rsys-log-2
 
.PHONY : stop-all-containers
stop-all-containers : | stop-log-servers stop-app-servers
	@echo "stopped all running containers"
