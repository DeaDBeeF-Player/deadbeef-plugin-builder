#!/bin/sh

docker build --platform linux/amd64 --progress plain -f docker/Dockerfile-bootstrap -t deadbeef-plugin-builder-base-20.04 .
