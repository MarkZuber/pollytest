# FindJSON11
# ---------
#
# Locate JSON11 library (headers only)
#
# This module defines:
#
# ::
#
#   JSON11_INCLUDE_DIRS, where to find the headers
#   JSON11_SOURCES, list of sources files to be compiled
#   JSON11_FOUND, if false, do not try to link against
#

set(BUILD_DEPS_DIR ${CMAKE_SOURCE_DIR}/${PROJECT_DEPS_DIR})
set(JSON11_DEPS_DIR json11)

find_path(
    JSON11_INCLUDE_DIR NAMES json11.hpp
    PATHS ${BUILD_DEPS_DIR}/${JSON11_DEPS_DIR}
    NO_DEFAULT_PATH
)


find_file(
    JSON11_CPP NAMES json11.cpp
    PATHS ${BUILD_DEPS_DIR}/${JSON11_DEPS_DIR}
    NO_DEFAULT_PATH
)

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(
    JSON11
    FOUND_VAR JSON11_FOUND
    REQUIRED_VARS
        JSON11_INCLUDE_DIR
        JSON11_CPP
)

if(JSON11_FOUND)
    set(JSON11_INCLUDE_DIRS ${JSON11_INCLUDE_DIR})
    set(JSON11_SOURCES ${JSON11_CPP})
endif(JSON11_FOUND)

mark_as_advanced(JSON11_INCLUDE_DIR JSON11_CPP)
