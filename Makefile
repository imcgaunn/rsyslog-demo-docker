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
build-app-image:
	cd app-node && docker build -t $(APP_IMAGE_NAME) .

.PHONY : build-log-image
LOG_IMAGE_NAME := rsyslog-example-logserver
build-log-image:
	cd log-node && docker build -t $(LOG_IMAGE_NAME) .

### running experiments
.PHONY : start-docker-network
start-docker-network :
	@echo "creating docker bridge network"

.PHONY : stop-docker-network
stop-docker-network :
	@echo "stopping and removing docker bridge network"

.PHONY : start-app-servers
start-app-servers :
	@echo "starting app server containers"
	docker run --name rsys-app-1 -dit $(APP_IMAGE_NAME)
	docker run --name rsys-app-2 -dit $(APP_IMAGE_NAME)
	docker run --name rsys-app-3 -dit $(APP_IMAGE_NAME)

.PHONY : stop-app-servers
stop-app-servers :
	@echo "shutting down and removing app server containers"

.PHONY : start-log-servers
start-log-servers :
	@echo "starting log server containers"

.PHONY : stop-log-servers
stop-log-servers :
	@echo "shutting down and removing log server containers"