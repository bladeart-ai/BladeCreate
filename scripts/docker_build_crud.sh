#!/bin/sh

GIT_COMMIT=$(git rev-parse HEAD)
DOCKER_REPO=bladecreate-crud

docker build -t $DOCKER_REPO:$GIT_COMMIT -f docker/Dockerfile.crud .
