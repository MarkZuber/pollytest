#!/usr/bin/env bash

#
# google docet - jump within the directory which contains this script
#

SOURCE="${BASH_SOURCE[0]}"

while [ -h "$SOURCE" ]; do
    DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done

#
# set aside the base dir for future references
#

DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"

#
# update the dependencies and the generated classes
#

. "$DIR"/deps.sh
. "$DIR"/idl.sh

#
# import the configuration file
#

source "$DIR"/config.build

#
# build configuration
#

if [ "x$BUILD_TYPE" != "xRelease" ]; then
    BUILD_TYPE="Debug"
fi

if [ "x$LIBRARY_TYPE" != "xStatic" ]; then
    LIBRARY_TYPE="Shared"
fi

if [ "x$IOS_SIM" = "xYES" ]; then
    IOSSIM="--iossim"
fi

#
# default build
#

if [ "x$ENABLE_DEFAULT" = "xYES" ]; then
    cd "$DIR"

    python3 "$DIR"/deps/polly/bin/build.py                \
        --reconfig                                      \
        --config $BUILD_TYPE                            \
        --home .                                        \
        --install                                       \
        --jobs 3                                        \
        --toolchain default                             \
        --test                                          \
        --pack TGZ                                      \
        --fwd LIBRARY_TYPE=$LIBRARY_TYPE                \
        --verbose
fi

#
# android builds
#

if [ "x$ENABLE_ANDROID" = "xYES" ]; then
    cd "$DIR"

    export ANDROID_NDK=$ANDROID_NDK_PATH

    for TOOLCHAIN in ${ANDROID_TOOLCHAINS[@]}; do
        python3 "$DIR"/deps/polly/bin/build.py                \
            --reconfig                                      \
            --config $BUILD_TYPE                            \
            --home .                                        \
            --install                                       \
            --jobs 3                                        \
            --toolchain $TOOLCHAIN                          \
            --pack TGZ                                      \
            --fwd LIBRARY_TYPE=$LIBRARY_TYPE                \
            --verbose
    done
fi

#
# ios builds
#

if [ "x$ENABLE_APPLE" = "xYES" ]; then
    cd "$DIR"

    for TOOLCHAIN in ${APPLE_TOOLCHAINS[@]}; do
        python3 "$DIR"/deps/polly/bin/build.py                \
            --reconfig                                      \
            --config $BUILD_TYPE                            \
            --home .                                        \
            --install                                       \
            --jobs 3                                        \
            --toolchain $TOOLCHAIN                          \
            --pack TGZ                                      \
            --fwd LIBRARY_TYPE=$LIBRARY_TYPE                \
            $IOSSIM                                         \
            --verbose
    done
fi

#
# go back home
#

cd "$DIR"
