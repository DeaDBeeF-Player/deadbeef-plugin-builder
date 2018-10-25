#!/bin/sh

docker build -t deadbeef-plugin-builder .
mkdir -p docker-build
docker run -v ${PWD}/docker-artifacts:/usr/src/deadbeef/temp deadbeef-plugin-builder
