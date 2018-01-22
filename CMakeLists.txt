#
# Djinni CMake
#

#
# Building in-tree is not allowed (we take care of your craziness).
#

if(${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR})
    message(FATAL_ERROR "Prevented in-tree built. Please create a build directory outside of the source code and call cmake from there. Thank you.")
endif()

#
# Project configuration
#

project(djinni-cmake)
cmake_minimum_required(VERSION 3.0)

if(NOT CMAKE_BUILD_TYPE)
        set(CMAKE_BUILD_TYPE Debug)
endif(NOT CMAKE_BUILD_TYPE)

if(NOT LIBRARY_TYPE)
    set(LIBRARY_TYPE "Shared")
endif(NOT LIBRARY_TYPE)

set(PROJECT_NAME "djinni-cmake")
set(PROJECT_VERSION_MAJOR 0)
set(PROJECT_VERSION_MINOR 1)
set(PROJECT_VERSION_PATCH 0)
set(PROJECT_VERSION ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH})
set(PROJECT_AUTHOR "Michele Caini")
set(PROJECT_YEAR_COPYRIGHT "2016")
set(PROJECT_AUTHOR_EMAIL "michele.caini@gmail.com")

set(PROJECT_BUILD_MESSAGE ${PROJECT_NAME} " v" ${PROJECT_VERSION} " (" ${LIBRARY_TYPE} "." ${CMAKE_BUILD_TYPE} ")")
set(COPYRIGHT_BUILD_MESSAGE "Copyright (c) " ${PROJECT_YEAR_COPYRIGHT} " " ${PROJECT_AUTHOR}  " <" ${PROJECT_AUTHOR_EMAIL} ">")

message("*")
message("* " ${PROJECT_BUILD_MESSAGE})
message("* " ${COPYRIGHT_BUILD_MESSAGE})
message("*")

#
# Compile stuff
#

if(APPLE)
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,-undefined,dynamic_lookup")
else(APPLE)
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--export-dynamic")
endif(APPLE)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -O0 -g -DDEBUG")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -Os -DRELEASE")

add_definitions(
    -DPROJECT_NAME=${PROJECT_NAME}
    -DPROJECT_VERSION="${PROJECT_VERSION}"
)

#
# CMake configuration
#

set(PROJECT_CMAKE_DIR cmake)
set(PROJECT_CMAKE_MODULES_DIR ${PROJECT_CMAKE_DIR}/modules)
set(PROJECT_INSTALL_DIR install)
set(PROJECT_BUILD_DIR build)
set(PROJECT_DEPS_DIR deps)
set(PROJECT_JNI_DIR jni)
set(PROJECT_OBJC_DIR objc)
set(PROJECT_JAVA_DIR java)
set(PROJECT_DOCS_DIR docs)
set(PROJECT_SRC_DIR src)
set(PROJECT_TEST_DIR test)

set(PROJECT_RUNTIME_OUTPUT_DIRECTORY bin)
set(PROJECT_LIBRARY_OUTPUT_DIRECTORY lib)
set(PROJECT_ARCHIVE_OUTPUT_DIRECTORY lib/static)
set(PROJECT_INCLUDE_OUTPUT_DIRECTORY include)
set(PROJECT_SHARE_OUTPUT_DIRECTORY share)

set(
    CMAKE_MODULE_PATH
    ${CMAKE_MODULE_PATH}
    ${CMAKE_SOURCE_DIR}/${PROJECT_CMAKE_MODULES_DIR}
)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_RUNTIME_OUTPUT_DIRECTORY})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_LIBRARY_OUTPUT_DIRECTORY})
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_ARCHIVE_OUTPUT_DIRECTORY})

#
# Enable test support using ctest
#

include(CTest)

#
# Polly, so useful, so stressful
#

if(POLLY_TOOLCHAIN_TAG)
    set(CMAKE_INSTALL_PREFIX ${PROJECT_SOURCE_DIR}/${PROJECT_INSTALL_DIR}/${POLLY_TOOLCHAIN_TAG})
    set(PROJECT_DJINNI_SUPPORT_LIB_DIR ${PROJECT_DEPS_DIR}/djinni/support-lib)
    set(PROJECT_DJINNI_SUPPORT_LIB_JNI_DIR ${PROJECT_DJINNI_SUPPORT_LIB_DIR}/jni)
    set(PROJECT_DJINNI_SUPPORT_LIB_OBJC_DIR ${PROJECT_DJINNI_SUPPORT_LIB_DIR}/objc)

    string(REGEX MATCH "^android.*$" POLLY_TOOLCHAIN_ANDROID ${POLLY_TOOLCHAIN_TAG})
    string(REGEX MATCH "^ios.*$" POLLY_TOOLCHAIN_IOS ${POLLY_TOOLCHAIN_TAG})
    string(REGEX MATCH "^osx.*$" POLLY_TOOLCHAIN_OSX ${POLLY_TOOLCHAIN_TAG})
    string(REGEX MATCH "^default$" POLLY_TOOLCHAIN_DEFAULT ${POLLY_TOOLCHAIN_TAG})

    if(POLLY_TOOLCHAIN_ANDROID)
        add_definitions(-DTOOLCHAIN_ANDROID)

        file(
            GLOB
            TOOLCHAIN_ADDITIONAL_SOURCES
            ${PROJECT_DJINNI_SUPPORT_LIB_JNI_DIR}/*.cpp
            ${PROJECT_JNI_DIR}/*.cpp
        )

        set(
            TOOLCHAIN_ADDITIONAL_INCLUDE_DIRS
            ${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_DJINNI_SUPPORT_LIB_JNI_DIR}
            ${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_SRC_DIR}
            ${PROJECT_JNI_DIR}
        )

        install(
            DIRECTORY ${PROJECT_JAVA_DIR}
            DESTINATION ..
        )
    endif(POLLY_TOOLCHAIN_ANDROID)

    if(POLLY_TOOLCHAIN_IOS OR POLLY_TOOLCHAIN_OSX)
        if(POLLY_TOOLCHAIN_IOS)
            add_definitions(-DTOOLCHAIN_IOS)
        endif(POLLY_TOOLCHAIN_IOS)

        if(POLLY_TOOLCHAIN_OSX)
            add_definitions(-DTOOLCHAIN_OSX)
        endif(POLLY_TOOLCHAIN_OSX)

        file(
            GLOB
            TOOLCHAIN_ADDITIONAL_SOURCES
            ${PROJECT_DJINNI_SUPPORT_LIB_OBJC_DIR}/*.mm
            ${PROJECT_OBJC_DIR}/*Private.mm
        )

        set(
            TOOLCHAIN_ADDITIONAL_INCLUDE_DIRS
            ${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_DJINNI_SUPPORT_LIB_OBJC_DIR}
            ${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_SRC_DIR}
            ${PROJECT_OBJC_DIR}
        )

        set(
            TOOLCHAIN_ADDITIONAL_COMPILE_OPTIONS
            "-fobjc-arc"
        )

        install(
            DIRECTORY ${PROJECT_OBJC_DIR}
            DESTINATION ..
            PATTERN *Private.mm EXCLUDE
            PATTERN *Private.h EXCLUDE
        )
    endif(POLLY_TOOLCHAIN_IOS OR POLLY_TOOLCHAIN_OSX)
else(POLLY_TOOLCHAIN_TAG)
    set(CMAKE_INSTALL_PREFIX ${PROJECT_SOURCE_DIR}/${PROJECT_INSTALL_DIR}/default)
endif(POLLY_TOOLCHAIN_TAG)

#
# Referenced packages
#

if(NOT POLLY_TOOLCHAIN_TAG)
    # documentation and tests are available only to the core way
    find_package(GoogleTest)
    find_package(Doxygen 1.8)
    find_package(JSON11 REQUIRED)
    find_package(Threads REQUIRED)
else(NOT POLLY_TOOLCHAIN_TAG)
    if(COMMAND find_host_package)
        find_host_package(JSON11 REQUIRED)
        find_host_package(Threads REQUIRED)
    else(COMMAND find_host_package)
        find_package(JSON11 REQUIRED)
        find_package(Threads REQUIRED)
    endif(COMMAND find_host_package)
endif(NOT POLLY_TOOLCHAIN_TAG)

#
# Referenced directories and targets
#

set(TARGET_DJINNI_CMAKE djinni_cmake)
set(TARGET_DOCS docs)

add_subdirectory(${PROJECT_SRC_DIR})

if(DOXYGEN_FOUND)
    add_subdirectory(${PROJECT_DOCS_DIR})
endif(DOXYGEN_FOUND)

if(GOOGLETEST_FOUND)
    add_subdirectory(${PROJECT_TEST_DIR})
endif(GOOGLETEST_FOUND)

#
# Keep your stuff and go further away, foolish.
#

set(CPACK_PACKAGE_NAME ${PROJECT_NAME})
set(CPACK_PACKAGE_VENDOR ${PROJECT_AUTHOR})
set(CPACK_PACKAGE_VERSION_MAJOR ${PROJECT_VERSION_MAJOR})
set(CPACK_PACKAGE_VERSION_MINOR ${PROJECT_VERSION_MINOR})
set(CPACK_PACKAGE_VERSION_PATCH ${PROJECT_VERSION_PATCH})
set(CPACK_PACKAGE_VERSION ${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH})
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Djinni CMake")
set(CPACK_PACKAGE_FILE_NAME ${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION})
set(CPACK_SOURCE_PACKAGE_FILE_NAME ${CPACK_PACKAGE_FILE_NAME}-src)
set(CPACK_RESOURCE_FILE_LICENSE ${CMAKE_SOURCE_DIR}/LICENSE)
set(CPACK_RESOURCE_FILE_README ${CMAKE_SOURCE_DIR}/README.md)
set(CPACK_GENERATOR TGZ)
set(CPACK_SOURCE_GENERATOR TGZ)
set(CPACK_PACKAGING_INSTALL_DIRECTORY "djinni_cmake-${CMake_VERSION_MAJOR}.${CMake_VERSION_MINOR}")

include(CPack)

#
# I use QtCreator and I need the lines below, so do not ask. :-)
#

file(
    GLOB_RECURSE PROJECT_FILES FOLLOW_SYMLINKS
    *.txt *.mk *.c *.cpp *.hpp *.h *.java *.in *.cmake *.m *.mm
    *.djinni *.idl *.dox *.sh Makefile *.example *.config *.build
    *.xml *.py *.scala README *.sql
)

add_custom_target(
    QTCREATOR_FALLBACK ALL
    COMMENT "Feel free to ignore this target, but please do not remove it."
    SOURCES ${PROJECT_FILES}
)
