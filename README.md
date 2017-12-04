[![Build Status](https://travis-ci.org/DeaDBeeF-Player/deadbeef-plugin-builder.svg?branch=master)](https://travis-ci.org/DeaDBeeF-Player/deadbeef-plugin-builder)

# DeaDBeeF Plugin Builder

## Intro

This is the deadbeef plugin build system, as the name implies.

This tool is for the plugin developers, and __not__ for the end-users.

It lets you write a simple configuration file, and build statically linked cross-distro binaries for your plugins using the `build` tool, both for i686 and x86\_64.

The tool called `build-md` can be used to generate markdown file, which is used for publishing all the plugins on the deadbeef website.

Each plugin has a subfolder in the `plugins` folder, and a file called `manifest.json` in it.

Example: plugins/bs2b/manifest.json

The folder can also have patch(es), referenced from the manifest.

## Features

* fetching sources from svn, hg, git
* patching
* building with GNU Make (make->type=make)
* building with autotools (make->type=autotools)
* generating packages (versioned zip files)
* extracting descriptions/authorship/licenses (this would have to be written in the manifests)
* generating the final plugin downloads page

## Requirements for running the deadbeef-plugin-builder tools

* x86\_64 linux distro with ia32libs installed (build on i686 also works, but no cross-compilation to x86\_64)
* wget, tar, bzip2 for downloading and unpacking dependencies
* git, svn, hg for fetching plugin sources
* perl
* make and autotools for building
* deadbeef installed
    * alternatively, unpack
      [this](http://sourceforge.net/projects/deadbeef/files/staticdeps/ddb-headers-latest.tar.bz2/download) into static-deps/lib-x86-32 and static-deps/lib-x86-64

## Requirements to plugins

* Hosted on the internet, using svn, hg or git (no tarballs supported here).
* Using GNU make or autotools. If your plugin uses anything else -- you'll have to write a Makefile, and supply it as a patch.
* Ability to link the dependencies statically. The static versions of many libs are supplied automatically by this system. If there are no static libs for the stuff that your plugin needs -- you're out of luck for now. Make a feature request to add the lib(s) which you need.

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

## Why patch?

When you're adding a new plugin to the system, in most cases, you'll need to apply a patch, so that it works with static linking. Many plugins use weird build systems, such as shell scripts, cmake, qmake, etc. Even when they use makefiles or autotools -- there are bugs, which prevent building the static binaries. So when you make the manifest, and run "build" - you'll get errors. Or you simply won't be able to build, because the plugin uses e.g. cmake. So you'll need to add a Makefile. Of course, the best way to do this, is to fix your code. But if for some reasons you don't want to do it, or you're not the developer of the plugin -- you'll need to create a patch, and reference it from the manifest.json. Look at how it's done in other plugins.

## How to make a patch

(assuming you're testing on x86_64)

1. Run ```./build --arch=x86_64 pluginname```
2. Look at the errors, and correct them in the cached sources (```temp/pluginname```)
3. Re-run ```./build --nofetch --arch=x86_64 pluginname```. Notice the ```--nofetch```. If you don't use ```--nofetch``` -- your local modifications will be lost!
4. Repeat until you're happy with the result, then do something like ```git diff >../../plugins/pluginname/buildfixes.diff```, and add the patch into manifest.

## Step by step instructions on adding a new plugin

1. Clone this repository
2. Run ```./build --arch=x86_64``` to verify that everything works. All plugins should build without errors. NOTE that the 1st time you run it -- a large archive with libraries will be downloaded.
3. Create a new folder with manifest.json file for your plugin. Copy a manifest.json from any other plugin as a template, try to find one which looks close to what you need. E.g. using the same VCS, same build system, same libraries, etc.
4. run ```./build --arch=x86_64 pluginname```. The pluginname here is the name of the folder you've created.
5. Fix the errors in the manifest. Fix the errors in the code. Rerun with --nofetch argument, so that your changes are not deleted.
6. Repeat step 5, until the plugin builds completes successfully. At this point, you may create a patch. See the section ```How to make a patch``` above for instructions.
7. Verify that the plugin builds without errors. Copy the plugin to a place where deadbeef can find it. Run deadbeef, and verify that your plugin works.
8. Run readelf -d on all your *.so files, to verify they link to what they need to link.
9. After this is done - you're ready to submit a pull request. Hopefully you know how to do it. If not -- please refer to github manual.

## Running a build locally, via docker

1. Install docker
2. Run once: `./docker-bootstrap.sh` -- this would create the base image.
3. Run for each build: `./docker-build.sh`

