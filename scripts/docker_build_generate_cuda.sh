#!/bin/sh

BC_ENV=prod
GIT_COMMIT=$(git rev-parse HEAD)
DOCKER_REPO="generate-service-cuda"

docker build -e BC_ENV=$BC_ENV -t ${DOCKER_REPO}:${GIT_COMMIT} -f docker/Dockerfile.generate.cuda .
