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
# update generated files
#

cd "$DIR"

rm -rf "$DIR"/src/interface/*.hpp
rm -rf "$DIR"/java/djinni/cmake/*.java
rm -rf "$DIR"/objc/*.mm
rm -rf "$DIR"/objc/*.h
rm -rf "$DIR"/jni/*

./deps/djinni/src/run                                       \
    --cpp-optional-header "<experimental/optional>"         \
    --cpp-optional-template std::experimental::optional     \
    --cpp-out src/interface                                 \
    --cpp-namespace djinni_cmake                            \
    --java-out java/djinni/cmake                            \
    --java-package djinni.cmake                             \
    --ident-java-field mFooBar                              \
    --jni-out jni                                           \
    --jni-namespace djinni_cmake_jni                        \
    --jni-include-cpp-prefix interface/                     \
    --objc-out objc                                         \
    --objc-type-prefix DjinniCmake                          \
    --objcpp-out objc                                       \
    --objcpp-namespace djinni_cmake_objc                    \
    --objcpp-include-cpp-prefix interface/                  \
    --ident-jni-class NativeFooBar                          \
    --ident-jni-file native_foo_bar                         \
    --idl ./djinni/djinni_cmake.djinni

#
# go back home
#

cd "$DIR"
