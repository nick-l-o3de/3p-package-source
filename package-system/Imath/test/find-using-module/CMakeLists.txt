#
# Copyright (c) Contributors to the Open 3D Engine Project.
# For complete copyright and license terms please see the LICENSE at the root of this distribution.
# 
# SPDX-License-Identifier: Apache-2.0 OR MIT
#
#

cmake_minimum_required(VERSION 3.20)

PROJECT(test_imath VERSION 1.0 LANGUAGES C CXX)

find_package(Imath MODULE REQUIRED)

add_executable(test_imath ${CMAKE_CURRENT_LIST_DIR}/../imathtest.cpp)
target_link_libraries(test_imath PRIVATE Imath::Imath)

