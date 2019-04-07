#!/bin/sh

# run this script once to create the base container image,
# which would contain all necessary dependencies and build tools

mkdir -p temp
mkdir -p static-deps

rm temp/ddb-static-deps.tar.bz2
curl -L http://sourceforge.net/projects/deadbeef/files/staticdeps/ddb-static-deps-latest.tar.bz2/download -o temp/ddb-static-deps.tar.bz2

tar jxf temp/ddb-static-deps.tar.bz2 -C static-deps

docker build -f Dockerfile-builder -t deadbeef-builder .
