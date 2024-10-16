include .env
export

PORT := 8080
SHORT_SHA := $(shell git rev-parse --short HEAD)
DOCKER_TAG := latest
DOCKER_IMAGE := static-nginx-site-ex

PROJECT_NAME := hair-station-mika-381110
AR_REPOSITORY := docker-images
CLOUDRUN_SERVICE_NAME := hsm-frontend

.PHONY: run
run:
	docker build -t $(DOCKER_IMAGE):$(DOCKER_TAG) .
	docker tag $(DOCKER_IMAGE):$(DOCKER_TAG) $(DOCKER_IMAGE):$(SHORT_SHA)
	docker run --rm --name $(DOCKER_IMAGE)-nginx-container \
		-v $(shell pwd)/public:/usr/share/nginx/html \
		-v $(shell pwd)/conf/nginx.conf:/etc/nginx/nginx.conf \
		-p 8080:$(PORT) $(DOCKER_IMAGE):$(DOCKER_TAG)

.PHONY: login
login:
	gcloud auth login
	gcloud auth application-default login --disable-quota-project
	gcloud config set project $(PROJECT_NAME)

.PHONY: create-repository
create-repository:
	gcloud artifacts repositories create $(AR_REPOSITORY) \
		--repository-format=Docker \
		--location=asia-east1


.PHONY: deploy
deploy: login
	gcloud builds submit --tag asia-east1-docker.pkg.dev/$(PROJECT_NAME)/$(AR_REPOSITORY)/$(DOCKER_IMAGE):$(DOCKER_TAG) \
		--region=asia-east1
	gcloud run deploy $(CLOUDRUN_SERVICE_NAME) \
		--image asia-east1-docker.pkg.dev/$(PROJECT_NAME)/$(AR_REPOSITORY)/$(DOCKER_IMAGE):$(DOCKER_TAG) \
		--region asia-east1 \
		--platform managed \
		--allow-unauthenticated