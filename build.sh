#!/bin/bash

#
# Builds new image from Dockerfile, pushes it to docker registry, tags is as latest
#

set -e

DOCKER_PROJECT=my-dockerhub-account
IMAGE_NAME=thumbnailer


if [ ! $1 ];then
	echo "Usage: $0 <new version number>"
	echo

	repotags=$(docker inspect --format="{{ .RepoTags }}" ${DOCKER_PROJECT}/${IMAGE_NAME}:latest)
	echo $repotags
	exit 1
fi

IMAGE_VERSION=$1
function myprint {
        RED='\033[0;31m'
        NC='\033[0m'
        printf "${RED}===> ${1}${NC}\n"
}

myprint "Building ${DOCKER_PROJECT}/${IMAGE_NAME}:${IMAGE_VERSION}"
docker build -t ${DOCKER_PROJECT}/${IMAGE_NAME}:${IMAGE_VERSION} .

myprint "Tagging ${DOCKER_PROJECT}/${IMAGE_NAME}:${IMAGE_VERSION} as latest"
docker tag ${DOCKER_PROJECT}/${IMAGE_NAME}:${IMAGE_VERSION} ${DOCKER_PROJECT}/${IMAGE_NAME}:latest

myprint "Pushing ${DOCKER_PROJECT}/${IMAGE_NAME}:${IMAGE_VERSION} to repo"
docker push ${DOCKER_PROJECT}/${IMAGE_NAME}:${IMAGE_VERSION}
