case "$TRAVIS_OS_NAME" in
    linux)
        echo "building HTML..."
        ./build-html || exit 1
    ;;
esac
