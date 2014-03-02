# DeaDBeeF Plugin Builder

## Intro

This is the deadbeef plugin build system, as the name implies.

Each plugin has a subfolder under plugins, and a manifest.json in it.

Example: plugins/bs2b/manifest.json

The folder can also have patch(es), referenced from manifest.

Not all features are supported yet, but it's getting there.

It's early work in progress, so don't expect much yet.

## Requirements

* x86\_64 linux distro with ia32libs installed
* wget, tar, bzip2 for downloading and unpacking dependencies
* perl
* make, autotools for building
* deadbeef installed
    * alternatively, unpack
      [this](http://sourceforge.net/projects/deadbeef/files/staticdeps/ddb-headers-latest.tar.bz2/download) into static-deps/lib-x86-32 and static-deps/lib-x86-64

## Usage examples

### Build bs2b and ddb\_waveform\_seekbar for i686

````
./build --arch=i686 bs2b ddb_waveform_seekbar
````

### Build filebrowser for x86_64 using pre-downloaded sources

````
./build --arch=x86_64 --nofetch ddb_filebrowser
````

This is useful when trying to make a patch, more on this below.

## How to make a patch

1. Run ./build --arch=x86_64 pluginname
2. Look at the errors, and correct them in the cached sources (temp/pluginname)
3. Re-run ./build --nofetch --arch=x86_64 pluginname (notice the nofetch). If you don't use --nofetch -- your local modifications will be lost
4. Repeat until you're happy with the result, then do something like "git diff >../../plugins/pluginname/buildfixes.diff", and add the patch into manifest.

## What works

* fetching sources from svn, hg, git
* patching
* building with GNU Make (make->type=make)
* building with autotools (make->type=autotools)

## What doesn't work (yet)

* generating final zips
* lots of other things

but that will come with time, as I'm trying to make all plugins working.
