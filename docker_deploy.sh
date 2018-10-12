#!/usr/bin/env bash
if [ "$TRAVIS_PULL_REQUEST" = "false" ]
then
    export DOCKER_BRANCH_TAG=$TRAVIS_BRANCH
else
    export DOCKER_BRANCH_TAG=$TRAVIS_PULL_REQUEST_BRANCH
fi

if [ "$DOCKER_BRANCH_TAG" = "master" ]
then
  docker build -t $DOCKER_REPOSITORY:$TRAVIS_COMMIT -t $DOCKER_REPOSITORY:$DOCKER_BRANCH_TAG -t $DOCKER_REPOSITORY:latest .
else
  docker build -t $DOCKER_REPOSITORY:$TRAVIS_COMMIT -t $DOCKER_REPOSITORY:$DOCKER_BRANCH_TAG .
fi

echo "$DOCKER_PASSWORD" | docker login --username $DOCKER_USERNAME --password-stdin
docker push $DOCKER_REPOSITORY
