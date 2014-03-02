# DeaDBeeF Plugin Builder

## Intro

This is the deadbeef plugin build system, as the name implies.

Each plugin has a subfolder under plugins, and a manifest.json in it.

Example: plugins/bs2b/manifest

The folder can also have patch(es), referenced from manifest.

Not all features are supported yet, but it's getting there.

It's early work in progress, so don't expect much yet.

## Requirements

* x86\_64 linux distro with ia32libs installed
* wget, tar, bzip2 for downloading and unpacking dependencies
* perl
* make, autotools for building

## How to use

````
ARCH=i686 ./build bs2b
ARCH=x86_64./build bs2b
````

This will produce static build of bs2b plugin

## What works

* fetching sources from svn, hg, git
* patching
* building with GNU Make (make->type=make)
* building with autotools (make->type=autotools)

## What doesn't work (yet)

* generating final zips
* lots of other things

but that will come with time, as I'm trying to make all plugins working.
