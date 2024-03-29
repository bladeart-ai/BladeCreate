#!/bin/sh

GIT_COMMIT=$(git rev-parse HEAD)
DOCKER_IMAGE_NAME="generate-service"

docker run --runtime=nvidia -p 8081:8081 -v /tmp:/tmp ${DOCKER_IMAGE_NAME}:${GIT_COMMIT}
