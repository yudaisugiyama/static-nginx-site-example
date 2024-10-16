include .env
export

PORT := 8080
SHORT_SHA := $(shell git rev-parse --short HEAD)
PROJECT_ID := hair-station-mika-381110
GAR_REPOSITORY := docker-images
GCP_SERVICE := static-nginx-site-ex

.PHONY: run
run:
	docker build -t $(GCP_SERVICE):$(SHORT_SHA) .
	docker run --rm \
		-v $(shell pwd)/public:/usr/share/nginx/html \
		-v $(shell pwd)/conf/nginx.conf:/etc/nginx/nginx.conf \
		-p 8080:$(PORT) $(GCP_SERVICE):$(SHORT_SHA)

.PHONY: login
login:
	gcloud auth login
	gcloud auth application-default login --disable-quota-project
	gcloud config set project $(PROJECT_ID)

.PHONY: create-repository
create-repository:
	gcloud artifacts repositories create $(GAR_REPOSITORY) \
		--repository-format=Docker \
		--location=asia-east1


.PHONY: deploy
deploy: login
	gcloud builds submit --tag asia-east1-docker.pkg.dev/$(PROJECT_ID)/$(GAR_REPOSITORY)/$(GCP_SERVICE):$(SHORT_SHA) \
		--region=asia-east1
	gcloud run deploy $(GCP_SERVICE) \
		--image asia-east1-docker.pkg.dev/$(PROJECT_ID)/$(GAR_REPOSITORY)/$(GCP_SERVICE):$(SHORT_SHA) \
		--region asia-east1 \
		--platform managed \
		--allow-unauthenticated