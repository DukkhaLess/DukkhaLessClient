#!/usr/bin/env bash
echo "$DOCKER_PASSWORD" | docker login --username $DOCKER_USERNAME --password-stdin
echo "$TRAVIS_PULL_REQUEST"
if [ "$TRAVIS_PULL_REQUEST" = false]
then
    echo "Not a pr build"
    export DOCKER_BRANCH_TAG=$TRAVIS_BRANCH
else
    echo "PR Build"
    export DOCKER_BRANCH_TAG=$TRAVIS_PULL_REQUEST_BRANCH
fi

if [ "$DOCKER_BRANCH" = "master" ]
then
  docker build -t $DOCKER_REPOSITORY:$TRAVIS_COMMIT -t $DOCKER_REPOSITORY:$DOCKER_BRANCH_TAG -t $DOCKER_REPOSITORY:latest .
else
  docker build -t $DOCKER_REPOSITORY:$TRAVIS_COMMIT -t $DOCKER_REPOSITORY:$DOCKER_BRANCH_TAG .
fi
docker push $DOCKER_REPOSITORY
