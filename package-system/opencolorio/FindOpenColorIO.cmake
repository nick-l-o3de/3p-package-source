#
# Copyright (c) Contributors to the Open 3D Engine Project.
# For complete copyright and license terms please see the LICENSE at the root of this distribution.
# 
# SPDX-License-Identifier: Apache-2.0 OR MIT
#
#

# this file needs to work outside O3DE so that it can be used to compile OpenColorIO
# do not use O3DE macros and values.

set(OCIO_BASE_PATH ${CMAKE_CURRENT_LIST_DIR}/OpenColorIO)
set(OCIO_BIN_DIR ${OCIO_BASE_PATH}/bin)
set(OCIO_LIB_DIR ${OCIO_BASE_PATH}/lib)
set(OCIO_INCLUDE_DIR ${OCIO_BASE_PATH}/include)

set(OpenColorIO_VERSION 2.4.2)

# Even though its not supposed to be necessary to use global variables here,
# and everything should be using targets and target properties, some libraries still
# depend on the standard global variables like xxxx_INCLUDE_DIR instead of the targets.
set(OpenColorIO_INCLUDE_DIR ${OCIO_INCLUDE_DIR})

if (NOT TARGET OpenColorIO::OpenColorIO)
    add_library(OpenColorIO::OpenColorIO IMPORTED SHARED GLOBAL)
    target_include_directories(OpenColorIO::OpenColorIO SYSTEM INTERFACE ${OCIO_INCLUDE_DIR})

    if (CMAKE_SYSTEM_NAME STREQUAL "Windows")
        set_target_properties(OpenColorIO::OpenColorIO PROPERTIES
            IMPORTED_IMPLIB "${OCIO_LIB_DIR}/OpenColorIO${CMAKE_STATIC_LIBRARY_SUFFIX}"
            IMPORTED_LOCATION "${OCIO_BIN_DIR}/OpenColorIO_2_4${CMAKE_SHARED_LIBRARY_SUFFIX}"
            IMPORTED_IMPLIB_DEBUG "${OCIO_LIB_DIR}/OpenColorIO${CMAKE_STATIC_LIBRARY_SUFFIX}"
            IMPORTED_LOCATION_DEBUG "${OCIO_BIN_DIR}/OpenColorIO_2_4${CMAKE_SHARED_LIBRARY_SUFFIX}"
        )
    else()
        set_target_properties(OpenColorIO::OpenColorIO PROPERTIES 
            IMPORTED_LOCATION "${OCIO_BIN_DIR}/${CMAKE_SHARED_LIBRARY_PREFIX}OpenColorIO${CMAKE_SHARED_LIBRARY_SUFFIX}"
        )
    endif()
endif()

if (NOT TARGET 3rdParty::OpenColorIO)
    add_library(3rdParty::OpenColorIO ALIAS OpenColorIO::OpenColorIO)
endif()

# Executables, added for convenience so you can depend or find the executable you need
# just by looking up OpenColorIO::executable_name's TARGET PROPERTY IMPORTED_LOCATION
set(OCIO_EXECUTABLES
    ocioarchive
    ociobakelut
    ociocheck
    ociochecklut
    ocioconvert
    ociocpuinfo
    ociolutimage
    ociomakeclf
    ocioperf
    ociowrite
)

if (NOT TARGET OpenColorIO::Executables)
    add_library(OpenColorIO::Executables INTERFACE IMPORTED GLOBAL)
endif()

foreach(executable ${OCIO_EXECUTABLES})
    if (NOT TARGET OpenColorIO::${executable})
        add_executable(OpenColorIO::${executable} IMPORTED GLOBAL)
        set_target_properties(OpenColorIO::${executable} PROPERTIES IMPORTED_LOCATION "${OCIO_BIN_DIR}/${executable}${CMAKE_EXECUTABLE_SUFFIX}")
    endif()

    target_link_libraries(OpenColorIO::Executables INTERFACE OpenColorIO::${executable})
endforeach()

# if we're not in O3DE, it's also extremely helpful to show a message to logs to indicate a custom library is in use
if (NOT LY_VERSION_ENGINE_NAME)
    message(STATUS "Using OpenColorIO ${OpenColorIO_VERSION} from ${CMAKE_CURRENT_LIST_DIR}")
endif()

set(OpenColorIO_FOUND TRUE)
