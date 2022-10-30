#! /bin/bash

IMAGE_REPOSITORY=ghcr.io/mauroarias
IMAGE_NAME=universal-inbound-agent

image=$IMAGE_REPOSITORY/$IMAGE_NAME

docker build --platform linux/amd64 --no-cache -t :latest -t ghcr.io/mauroarias/universal-inbound-agent:$(cat version) .
docker push build --platform linux/amd64 --no-cache -t $image:latest -t $image:$(cat version) .
docker push $image:latest
docker push $image:$(cat version)