message(STATUS "${CMAKE_CURRENT_LIST_FILE} ")
cmake_minimum_required(VERSION 3.5)

if (PICO_CYW43_SUPPORTED) # set by BOARD=pico-w
    if (NOT TARGET pico_cyw43_arch)
        message(WARNING "Skipping Pico W examples as support is not available")
    else()
        set(WIFI_SSID "${WIFI_SSID}" CACHE INTERNAL "WiFi SSID for examples")
        set(WIFI_PASSWORD "${WIFI_PASSWORD}" CACHE INTERNAL "WiFi password for examples")
        message(STATUS "WIFI Credentials set")


        if ("${WIFI_SSID}" STREQUAL "")
            message("Skipping some Pico W examples as WIFI_SSID is not defined")
        elseif ("${WIFI_PASSWORD}" STREQUAL "")
            message("Skipping some Pico W examples as WIFI_PASSWORD is not defined")
        else()

        endif()
    endif()
endif()


message(STATUS "------------------------------------------------------------------------------------------")
message(STATUS "Including subdirectory ${MAKE_TARGET} (because it is the MAKE_TARGET)")
add_subdirectory(${MAKE_TARGET})
#add_subdirectory(learn)
message(STATUS "------------------------------------------------------------------------------------------")
