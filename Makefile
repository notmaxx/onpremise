REGISTRY ?= quay.io/
IMAGE_PREFIX ?= workato
COMPONENT ?= sentry
SHORT_NAME ?= $(COMPONENT)
MUTABLE_VERSION ?= latest

VERSION ?= git-$(shell git rev-parse --short HEAD)
TS_TAG := $(shell date -u "+%Y-%m-%dT%H-%M-%SZ")
TAG := "${VERSION}-${TS_TAG}"

IMAGE := ${REGISTRY}${IMAGE_PREFIX}/${SHORT_NAME}:${TAG}
MUTABLE_IMAGE := ${REGISTRY}${IMAGE_PREFIX}/${SHORT_NAME}:${MUTABLE_VERSION}

OK_COLOR=\033[32;01m
NO_COLOR=\033[0m

info:
	@echo "Build tag:       ${VERSION}"
	@echo "Registry:        ${REGISTRY}"
	@echo "Immutable tag:   ${IMAGE}"
	@echo "Mutable tag:     ${MUTABLE_IMAGE}"

docker-push: docker-mutable-push docker-immutable-push

docker-immutable-push:
	docker push ${IMAGE}

docker-mutable-push:
	docker push ${MUTABLE_IMAGE}

docker-build:
	@docker build --rm -t $(IMAGE) .
	@docker build --rm -t $(MUTABLE_IMAGE) .

build: docker-build

push: docker-push

all: docker-build docker-push

.PHONY: all docker-build docker-push docker-mutable-push docker-immutable-push docker-push build push
