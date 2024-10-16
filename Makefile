PORT := 8080
SHORT_SHA := $(shell git rev-parse --short HEAD)
DOCKER_TAG := latest
DOCKER_IMAGE := static-nginx-site-ex

.PHONY: run
run:
	docker build -t $(DOCKER_IMAGE):$(DOCKER_TAG) .
	docker tag $(DOCKER_IMAGE):$(DOCKER_TAG) $(DOCKER_IMAGE):$(SHORT_SHA)
	docker run --rm --name $(DOCKER_IMAGE)-nginx-container \
		-v $(shell pwd)/public:/usr/share/nginx/html \
		-v $(shell pwd)/conf/nginx.conf:/etc/nginx/nginx.conf \
		-p 8080:$(PORT) $(DOCKER_IMAGE):$(DOCKER_TAG)