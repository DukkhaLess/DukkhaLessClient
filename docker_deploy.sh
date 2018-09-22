#!/usr/bin/env bash
echo "$DOCKER_PASSWORD" | docker login --username $DOCKER_USERNAME --password-stdin
if [ "$TRAVIS_PULL_REQUEST" = true]
then
    export DOCKER_BRANCH_TAG=$TRAVIS_PULL_REQUEST_BRANCH
else
    export DOCKER_BRANCH_TAG=$TRAVIS_BRANCH
fi
docker build -t $DOCKER_REPOSITORY:$TRAVIS_COMMIT -t $DOCKER_REPOSITORY:$DOCKER_BRANCH_TAG .
docker push $DOCKER_REPOSITORY
