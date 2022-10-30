#! /bin/bash

IMAGE_REPOSITORY=ghcr.io/mauroarias
IMAGE_NAME=universal-inbound-agent

image=$IMAGE_REPOSITORY/$IMAGE_NAME

version=$(cat version)

echo "building $image, latest and $version"
docker build --platform linux/amd64 --no-cache -t $image:latest -t $image:$version .
docker push $image:latest
docker push $image:$version