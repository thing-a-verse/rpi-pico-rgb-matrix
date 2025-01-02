#
# Project: Seengreat 64x64 RGB Matrix
#

message(STATUS "CMAKE: ${CMAKE_CURRENT_LIST_DIR}/CmakeLists.txt")

#


project (learn
        LANGUAGES C CXX ASM)

message(STATUS "PROJECT: ${PROJECT_NAME}")
# so we know we're compiling with PICO_SDK
# enables #define PICO_SDK
add_compile_definitions(PICO_SDK)


# // Standardised DEBUG CODE ////////////////////////////////////////////////////
# Uncomment this to allow DEBUG code to be included in the compile binary
add_definitions(-DCOMPILE_DEBUG_CODE)
add_definitions(-D_DEBUG)
# ///////////////////////////////////////////////////////////////////////////////

add_executable(${PROJECT_NAME}
        learn.cpp
        )

target_link_libraries(${PROJECT_NAME} PRIVATE
        pico_stdlib                   # for core functionality
        pico_cyw43_arch_none          # we need Wifi to access the GPIO, but we don't need anything else
        pico_bootsel_via_double_reset # Double tap reset into bootrom is injected by linking with the
        hardware_i2c                  # for ssd1306
        hardware_spi                  # for SF toolkit
        hardware_rtc                  # real time clock
        pico_cyw43_arch_lwip_threadsafe_background # wifi_ap
        pico_rand                     # random numbers


        # Our Libraries

        pico_lib
        )



#target_sources(${PROJECT_NAME} PUBLIC
#       ${CMAKE_CURRENT_LIST_DIR}/learn.cpp
#        )


# Make sure TinyUSB can find tusb_config.h
target_include_directories(${PROJECT_NAME} PUBLIC
        ${CMAKE_CURRENT_LIST_DIR})



# create map/bin/hex file etc. (Ensure CMAKE_ARCHIVE_OUTPUT_DIRECTORY is set properly)
# either pico_add_extra_outputs() or pico_add_uf2_output() is fine
pico_add_uf2_output(${PROJECT_NAME})


# output to usb, turn off UART
pico_enable_stdio_usb(${PROJECT_NAME} 1)
pico_enable_stdio_uart(${PROJECT_NAME} 0)

# linker options
target_link_options(${PROJECT_NAME}
    PRIVATE "LINKER:--print-memory-usage"
)
