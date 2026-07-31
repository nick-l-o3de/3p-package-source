#
# Copyright (c) Contributors to the Open 3D Engine Project.
# For complete copyright and license terms please see the LICENSE at the root of this distribution.
# 
# SPDX-License-Identifier: Apache-2.0 OR MIT
#
#

# this file needs to work outside O3DE so that it can be used to compile OpenColorIO
# do not use O3DE macros and values.

set(OIIO_BASE_PATH ${CMAKE_CURRENT_LIST_DIR}/OpenImageIO)
set(OIIO_BIN_DIR ${OIIO_BASE_PATH}/bin)
set(OIIO_LIB_DIR ${OIIO_BASE_PATH}/lib)
set(OIIO_INCLUDE_DIR ${OIIO_BASE_PATH}/include)
set(OpenImageIO_VERSION 3.1.15.0)

# Even though its not supposed to be necessary to use global variables here,
# and everything should be using targets and target properties, some libraries still
# depend on the standard global variables

set(OpenImageIO_INCLUDE_DIR ${OIIO_INCLUDE_DIR})

###### Executables
set(OIIO_EXECUTABLES
    iconvert
    idiff
    igrep
    iinfo
    maketx
    oiiotool
    testtex
)

if (NOT TARGET OpenImageIO::Executables)
    add_library(OpenImageIO::Executables INTERFACE IMPORTED GLOBAL)
endif()

foreach(executable ${OIIO_EXECUTABLES})
    if (NOT TARGET OpenImageIO::${executable})
        add_executable(OpenImageIO::${executable} IMPORTED GLOBAL)
        set_target_properties(OpenImageIO::${executable} PROPERTIES IMPORTED_LOCATION "${OIIO_BIN_DIR}/${executable}${CMAKE_EXECUTABLE_SUFFIX}")
    endif()
    target_link_libraries(OpenImageIO::Executables INTERFACE OpenImageIO::${executable})
endforeach()

####### OpenImageIO_Util
if (NOT TARGET OpenImageIO::OpenImageIO_Util)
    add_library(OpenImageIO::OpenImageIO_Util IMPORTED SHARED GLOBAL)
    target_include_directories(OpenImageIO::OpenImageIO_Util SYSTEM INTERFACE ${OIIO_INCLUDE_DIR})

    if (CMAKE_SYSTEM_NAME STREQUAL "Windows")
        set_target_properties(OpenImageIO::OpenImageIO_Util PROPERTIES
            IMPORTED_IMPLIB "${OIIO_LIB_DIR}/OpenImageIO_Util${CMAKE_STATIC_LIBRARY_SUFFIX}"
            IMPORTED_LOCATION "${OIIO_BIN_DIR}/OpenImageIO_Util${CMAKE_SHARED_LIBRARY_SUFFIX}"
            IMPORTED_IMPLIB_DEBUG "${OIIO_LIB_DIR}/OpenImageIO_Util_d${CMAKE_STATIC_LIBRARY_SUFFIX}"
            IMPORTED_LOCATION_DEBUG "${OIIO_BIN_DIR}/OpenImageIO_Util_d${CMAKE_SHARED_LIBRARY_SUFFIX}"
        )
    else()
        set_target_properties(OpenImageIO::OpenImageIO_Util PROPERTIES 
            IMPORTED_LOCATION "${OIIO_BIN_DIR}/${CMAKE_SHARED_LIBRARY_PREFIX}OpenImageIO_Util${CMAKE_SHARED_LIBRARY_SUFFIX}"
        )
    endif()
endif()

####### OpenImageIO (depends on Util)
if (NOT TARGET OpenImageIO::OpenImageIO)
    add_library(OpenImageIO::OpenImageIO IMPORTED SHARED GLOBAL)
    target_include_directories(OpenImageIO::OpenImageIO SYSTEM INTERFACE ${OIIO_INCLUDE_DIR})

    if (CMAKE_SYSTEM_NAME STREQUAL "Windows")
        set_target_properties(OpenImageIO::OpenImageIO PROPERTIES
            IMPORTED_IMPLIB "${OIIO_LIB_DIR}/OpenImageIO${CMAKE_STATIC_LIBRARY_SUFFIX}"
            IMPORTED_LOCATION "${OIIO_BIN_DIR}/OpenImageIO${CMAKE_SHARED_LIBRARY_SUFFIX}"
            IMPORTED_IMPLIB_DEBUG "${OIIO_LIB_DIR}/OpenImageIO_d${CMAKE_STATIC_LIBRARY_SUFFIX}"
            IMPORTED_LOCATION_DEBUG "${OIIO_BIN_DIR}/OpenImageIO_d${CMAKE_SHARED_LIBRARY_SUFFIX}"
        )

        if(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC") # as opposed to running clang on windows...
            target_compile_options(OpenImageIO::OpenImageIO INTERFACE "/utf-8")
        endif()

    else()
        set_target_properties(OpenImageIO::OpenImageIO PROPERTIES 
            IMPORTED_LOCATION "${OIIO_BIN_DIR}/${CMAKE_SHARED_LIBRARY_PREFIX}OpenImageIO${CMAKE_SHARED_LIBRARY_SUFFIX}"
        )
    endif()

    target_link_libraries(OpenImageIO::OpenImageIO INTERFACE OpenImageIO::OpenImageIO_Util)
endif()

###### O3DE 3P aliases
if (NOT TARGET 3rdParty::OpenImageIO)
    add_library(3rdParty::OpenImageIO ALIAS OpenImageIO::OpenImageIO)
endif()

if (NOT TARGET 3rdParty::OpenImageIO_Util)
    add_library(3rdParty::OpenImageIO_Util ALIAS OpenImageIO::OpenImageIO_Util)
endif()

# if we're not in O3DE, it's also extremely helpful to show a message to logs to indicate a custom library is in use
if (NOT LY_VERSION_ENGINE_NAME)
    message(STATUS "Using OpenImageIO ${OpenImageIO_VERSION} from ${CMAKE_CURRENT_LIST_DIR}")
endif()

set(OpenImageIO_FOUND TRUE)
