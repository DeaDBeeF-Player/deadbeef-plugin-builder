case "$TRAVIS_OS_NAME" in
    linux)
        STATICDEPS_URL="http://sourceforge.net/projects/deadbeef/files/staticdeps/ddb-static-deps-latest.tar.bz2/download"
        mkdir -p temp
        if [ ! -d static-deps ]; then
            if [ ! -f temp/ddb-static-deps.tar.bz2 ]; then
                echo "downloading static deps..."
                wget -q $STATICDEPS_URL -O temp/ddb-static-deps.tar.bz2 || exit 1
            fi
            mkdir static-deps
            echo "unpacking static deps..."
            tar jxf temp/ddb-static-deps.tar.bz2 -C static-deps || exit 1
        fi

        echo "downloading deadbeef headers..."
        wget -q http://sourceforge.net/projects/deadbeef/files/staticdeps/ddb-headers-latest.tar.bz2/download -O temp/ddb-headers-latest.tar.bz2
        echo "unpacking deadbeef headers..."
        tar jxf temp/ddb-headers-latest.tar.bz2 -C static-deps/lib-x86-64/include/ || exit 1
        #tar jxf temp/ddb-headers-latest.tar.bz2 -C static-deps/lib-x86-32/include/ || exit 1
        echo "compiling deadbeef pluginfo..."
        make -C tools/pluginfo/ || exit 1
        echo "building for x86_64..."
        ./build --arch=x86_64 || exit 1
#        echo "building for i686..."
#        ./build --arch=i686 --nofetch || exit 1
    ;;
    osx)
        echo "downloading deadbeef headers..."
        mkdir -p temp
        mkdir -p static-deps/lib-x86-64/include
        curl -L http://sourceforge.net/projects/deadbeef/files/staticdeps/ddb-headers-latest.tar.bz2/download -o temp/ddb-headers-latest.tar.bz2
        echo "unpacking deadbeef headers..."
        tar jxf temp/ddb-headers-latest.tar.bz2 -C static-deps/lib-x86-64/include/ || exit 1
        echo "compiling deadbeef pluginfo..."
        mkdir -p tools/pluginfo/x86_64
        mkdir -p tools/pluginfo/arm64
        mkdir -p tools/pluginfo/universal
        CFLAGS="-arch x86_64" make x86_64 -C tools/pluginfo/ || exit 1
        CFLAGS="-arch arm64" make arm64 -C tools/pluginfo/ || exit 1
        lipo -create -output tools/pluginfo/universal/pluginfo tools/pluginfo/x86_64/pluginfo tools/pluginfo/arm64/pluginfo
        echo "building for Mac Universal..."
        ./build || exit 1
    ;;
    windows)
        echo "Downgrading openssh"
        wget http://repo.msys2.org/msys/x86_64/openssh-8.7p1-1-x86_64.pkg.tar.zst
        pacman --noconfirm -U openssh-8.7p1-1-x86_64.pkg.tar.zst
        echo "downloading deadbeef headers..."
        mkdir -p temp
        mkdir -p static-deps/lib-x86-64/include
        curl -L http://sourceforge.net/projects/deadbeef/files/staticdeps/ddb-headers-latest.tar.bz2/download -o temp/ddb-headers-latest.tar.bz2
        echo "unpacking deadbeef headers..."
        $mingw64 tar jxf temp/ddb-headers-latest.tar.bz2 -C static-deps/lib-x86-64/include/ || exit 1
        echo "compiling deadbeef pluginfo..."
        $mingw64 make -C tools/pluginfo/ || exit 1
        echo "building for Windows x86_64..."
        $mingw64 ./build --arch=x86_64 || exit 1
        echo "converting .descr files to Unix format..."
        $mingw64 dos2unix temp/output/x86_64/*.descr
    ;;
esac
