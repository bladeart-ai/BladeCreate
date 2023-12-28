#!/bin/sh

GIT_COMMIT=$(git rev-parse HEAD)
DOCKER_REPO="generate-service-cuda"

docker build -t ${DOCKER_REPO}:${GIT_COMMIT} -f docker/Dockerfile.generate.cuda .
