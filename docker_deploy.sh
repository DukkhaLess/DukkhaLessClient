#!/usr/bin/env bash
echo "$DOCKER_PASSWORD" | docker login --username $DOCKER_USERNAME --password-stdin
docker build -t $TRAVIS_COMMIT -t MySelfcareClient .
docker push $DOCKER_REPOSITORY
