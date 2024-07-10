# SPDX-FileCopyrightText: 2021 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
#
# SPDX-License-Identifier: BSD-3-Clause

cmake_minimum_required(VERSION 3.20.0)

project(Liri
    DESCRIPTION "Liri"
    HOMEPAGE_URL "https://liri.io/"
    LANGUAGES CXX C
)

## Include function to print variables:
include(CMakePrintHelpers)

## This is a super build
set(LIRI_SUPERBUILD TRUE)

## Add some paths to check for CMake modules:
set(LIRI_LOCAL_ECM TRUE)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake-shared/modules")
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake-shared/find-modules")

## Include internal functions:
include(LiriSubprojects)

## Liri specific setup common for all modules:
include(LiriSetup)

## QML import path:
set(QML_IMPORT_PATH ${CMAKE_SOURCE_DIR}/bin CACHE STRING "" FORCE)

## ECM:
find_package(ECM 5.245.0 REQUIRED NO_MODULE)
list(APPEND CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

## Installation directories:
include(KDEInstallDirs)

## Subprojects to build:
include(.dependencies.cmake)
set(LIRI_BUILD_SUBPROJECTS "" CACHE STRING "List of subprojects to build")
if(DEFINED ENV{LIRI_BUILD_SUBPROJECTS})
    set(LIRI_BUILD_SUBPROJECTS "${ENV{LIRI_BUILD_SUBPROJECTS}")
endif()
_liri_internal_find_subprojects(_subprojects "${LIRI_BUILD_SUBPROJECTS}")

## Add subprojects to build:
cmake_print_variables(_subprojects)
foreach(subproject IN LISTS _subprojects)
    message("== Add ${subproject}")
    add_subdirectory(${subproject})
endforeach()

## Features:
include(FeatureSummary)
feature_summary(QUIET_ON_EMPTY WHAT ENABLED_FEATURES DISABLED_FEATURES)
