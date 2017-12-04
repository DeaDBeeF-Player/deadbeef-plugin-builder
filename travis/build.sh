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
        tar jxf temp/ddb-headers-latest.tar.bz2 -C static-deps/lib-x86-32/include/ || exit 1
        echo "building for x86_64..."
        ./build --arch=x86_64 || exit 1
        echo "building for i686..."
        ./build --arch=i686 --nofetch || exit 1
        echo "building HTML..."
        ./build-html || exit 1
    ;;
esac
