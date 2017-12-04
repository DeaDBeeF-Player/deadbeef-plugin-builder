#!/bin/sh

docker build -t deadbeef-plugin-builder .
docker run deadbeef-plugin-builder
