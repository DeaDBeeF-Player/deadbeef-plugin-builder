#!/bin/sh

mkdir -p docker-artifacts
docker build -t deadbeef-plugin-builder . || exit 1
docker run --rm -v ${PWD}/docker-artifacts:/usr/src/deadbeef/temp deadbeef-plugin-builder
