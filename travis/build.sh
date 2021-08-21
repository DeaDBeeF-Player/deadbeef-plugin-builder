case "$TRAVIS_OS_NAME" in
    linux)
        STATICDEPS_URL="http://sourceforge.net/projects/deadbeef/files/staticdeps/ddb-static-deps-latest.tar.bz2/download"
        mkdir -p temp
        if [ ! -d static-deps ]; then
            mkdir static-deps
            echo "downloading static deps..."
            wget -q $STATICDEPS_URL -O temp/ddb-static-deps.tar.bz2 || exit 1
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
        ./build --arch=x86_64 deadbeef-dr-meter || exit 1
#        echo "building for i686..."
#        ./build --arch=i686 --nofetch || exit 1
        echo "building HTML..."
        ./build-html || exit 1
    ;;
    osx)
        echo "downloading deadbeef headers..."
        mkdir -p temp
        mkdir -p static-deps/lib-x86-64/include
        curl -L http://sourceforge.net/projects/deadbeef/files/staticdeps/ddb-headers-latest.tar.bz2/download -o temp/ddb-headers-latest.tar.bz2
        echo "unpacking deadbeef headers..."
        tar jxf temp/ddb-headers-latest.tar.bz2 -C static-deps/lib-x86-64/include/ || exit 1
        echo "compiling deadbeef pluginfo..."
        make -C tools/pluginfo/ || exit 1
        echo "building for Mac x86_64..."
        ./build || exit 1
    ;;
    windows)
        echo "downloading deadbeef headers..."
        mkdir -p temp
        mkdir -p static-deps/lib-x86-64/include
        curl -L http://sourceforge.net/projects/deadbeef/files/staticdeps/ddb-headers-latest.tar.bz2/download -o temp/ddb-headers-latest.tar.bz2
        echo "unpacking deadbeef headers..."
        $mingw64 tar jxf temp/ddb-headers-latest.tar.bz2 -C static-deps/lib-x86-64/include/ || exit 1
        echo "compiling deadbeef pluginfo..."
        $mingw64 make -C tools/pluginfo/ || exit 1
        echo "building for Windows x86_64..."
        $mingw64 ./build --arch=x86_64 deadbeef-dr-meter || exit 1
        #STATICDEPS_URL="http://sourceforge.net/projects/deadbeef/files/staticdeps/ddb-xdispatch-win-latest.zip/download"
        #echo "downloading xdispatch_ddb..."
        #wget -q "$STATICDEPS_URL" -O ddb-xdispatch-win-latest.zip || exit 1
        #echo "unpacking xdispatch_ddb..."
        #$mingw64 unzip ddb-xdispatch-win-latest.zip || exit 1
    ;;
esac
