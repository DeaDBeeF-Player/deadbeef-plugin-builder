#!/bin/sh

docker build -t deadbeef-plugin-builder .
docker run deadbeef-plugin-builder
docker run -v ${PWD}/docker-artifacts:/usr/src/deadbeef/temp deadbeef-plugin-builder
