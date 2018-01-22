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
# drop everything that is not of interest
#

echo "cleaning $DIR/_builds"
rm -rf $DIR/_builds/*
echo "cleaning $DIR/install"
rm -rf $DIR/install/*
echo "cleaning $DIR/_logs"
rm -rf $DIR/_logs/*
echo "cleaning $DIR/build"
rm -rf $DIR/build/*
echo "cleaning generated files..."
rm -rf $DIR/src/interface/*.hpp
rm -rf $DIR/java/djinni/cmake/*.java
rm -rf $DIR/objc/*.h objc/*.mm
rm -rf $DIR/jni/*.jni

#
# go back home
#

cd $DIR
