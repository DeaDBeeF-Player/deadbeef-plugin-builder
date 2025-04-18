#!/bin/sh

mkdir -p docker-artifacts
docker build --platform linux/amd64 --progress plain -t deadbeef-plugin-builder-20.04 -f docker/Dockerfile-build . || exit 1
docker run --platform linux/amd64 --rm -v ${PWD}/docker-artifacts:/usr/src/deadbeef/temp deadbeef-plugin-builder-20.04
