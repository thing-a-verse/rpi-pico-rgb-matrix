message(STATUS "------------------------------------------------------------------------------------------")
message(STATUS "${CMAKE_CURRENT_LIST_FILE} ")
message(STATUS "------------------------------------------------------------------------------------------")

#
# Initialise the pico-sdk
# https://github.com/raspberrypi/pico-sdk
#

cmake_minimum_required(VERSION 3.5)

message(STATUS "[${CMAKE_PROJECT_NAME}] PICO_SDK_PATH=${PICO_SDK_PATH}")
message(STATUS "[${CMAKE_PROJECT_NAME}] ENV(PICO_SDK_PATH)=$ENV{PICO_SDK_PATH}")

if (DEFINED ENV{PICO_SDK_PATH} AND (NOT PICO_SDK_PATH))
    set(PICO_SDK_PATH $ENV{PICO_SDK_PATH})
    message("Using PICO_SDK_PATH from environment ('${PICO_SDK_PATH}')")
endif ()

if (DEFINED ENV{PICO_SDK_PATH} )
    message(STATUS "PICO_SDK_PATH is set in environment")
else ()
#    message(FATAL_ERROR "Please set PICO_SDK_PATH in environment - so that LoRaWAN compiles")
    set(PICO_SDK_PATH ${CMAKE_CURRENT_LIST_DIR}/pico-sdk)
endif ()

# Pull in SDK (must be before project)
include(${PICO_SDK_PATH}/external/pico_sdk_import.cmake)

# Defines the project we are building *MUST HAVE THIS*
project(rgb_matrix
      VERSION 1.0.0.0
      DESCRIPTION "Seengreat RGB Matrix"
      LANGUAGES C CXX ASM)

# Compiler Standards
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

# Setup Directories
# https://cmake.org/cmake/help/latest/manual/cmake-variables.7.html
# CMAKE_BINARY_DIR
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/bin)
message (STATUS "CMAKE_RUNTIME_OUTPUT_DIRECTORY=${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
message (STATUS "CMAKE_ARCHIVE_OUTPUT_DIRECTORY=${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}")


# Hardware we are using
set(PICO_BOARD pico_w)     # PICO SDK understands this

pico_sdk_init()

# So as to build the examples
#set(PICO_EXAMPLES_PATH pico-exammples)

#include(example_auto_set_url.cmake)

#add_compile_options(-Wall
#        -Wno-format          # int != int32_t as far as the compiler is concerned because gcc has int32_t as long int
#        -Wno-unused-function # we have some for the docs that aren't called
#        -Wno-maybe-uninitialized
#        )


# Hardware-specific examples in subdirectories:
message(STATUS "------------------------------------------------------------------------------------------")
add_subdirectory(pico-lib)
message(STATUS "Include subdirectory /src")
add_subdirectory(src)
message(STATUS "------------------------------------------------------------------------------------------")
