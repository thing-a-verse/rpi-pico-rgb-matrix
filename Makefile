#!/usr/bin/make
# makefile for RPI-PICO-W-XC

SHELL = /bin/bash
PWD      := `pwd`
CMAKE    := cmake
MAKE     := make
ARMCC    := arm-none-eabi-gcc

SDK      := pico-sdk
EXAMPLES := pico-examples
PICO_LIB := pico-lib
BUILD    := build
SRC      := src

BUILD_SDK := $(BUILD)/sdk
BUILD_SRC := $(BUILD)/project
BUILD_LORAWAN := $(BUILD)/lorawan

ARMCC_VERSION := $(shell $(ARMCC) --version | grep $(ARMCC) | awk '{print $$8}' | awk -F "." '{print $$1}' )

# This is the list of modules to compile
MODULES = learn rgb_test

# Args to pass to MAKE
MAKE_ARGS += -j4

ROOT_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
# Recipe for compiling modules
PROJECTDIR := $(realpath ./)

# These need to be available to make and cmake, so we export them
export PICO_SDK_PATH :=  $(ROOT_DIR)/pico-sdk
export PICO_TOOLCHAIN_PATH := $(realpath $(shell dirname $(shell command -v $(ARMCC))))
export PICO_BOARD := pico_w
export PROJECT := michael
export WIFI_SSID := "test"
export WIFI_PASSWORD := "test"

#cmake -DPROJECTDIR=${PICODIR}/${PACKAGE} -DPICO_BOARD=${PICO_BOARD} -DWIFI_SSID=${WIFI_SSID} -DWIFI_PASSWORD=${WIFI_PASSWORD}

# Target all has to be first for it to be the default
.PHONY:	all
all:	check-toolchain-installed install-sdk install-pico-lib build-sdk $(MODULES)
	@echo $(@)

check-toolchain-installed:
	@echo "-------------------------------------------------------------------"
	@echo "Check toolchain installed"
	@echo;echo -n "CMAKE: "
	@{ command -v $(CMAKE) && $(CMAKE) --version; } || { echo "CMake not installed. Try 'brew install cmake'"; exit 1; }
	@echo;echo -n "CC: "
	@{ command -v $(CC) && $(CC) --version; } || { echo "ARM Cross Compiler not installed. Try: https://github.com/thing-a-verse/rpi-pico-w-xc-macos-hello/blob/main/docs/arm-xc-toolchain.md"; exit 1; }
	@echo; echo -n "ARM Cross Compiler: "
	@{ command -v $(ARMCC) && echo $(ARMCC_VERSION) | awk '$$1 < 14 { exit 1 }' ;} || { echo "ARM Cross compiler v$(ARMCC_VERSION) old for SDK 2.0, you need v14.x+, get it from https://developer.arm.com/Tools%20and%20Software/GNU%20Toolchain"; exit 1; }
	@echo "Done"

help:
	@echo "-------------------------------------------------------------------"
	@echo "valid targets:"
	@echo "install, uninstall - add/remove the Pico SDK"
	@echo "examples - install the examples"


install-sdk:
	@echo "-------------------------------------------------------------------"
	@echo "Install the SDK"
	@if [ -d $(SDK) ]; then \
		cd $(SDK) && git pull && git submodule init; \
	else \
		git clone -b master https://github.com/raspberrypi/pico-sdk.git && cd $(SDK) &&	git submodule update --init; \
	fi
	@echo "Done"

install-pico-lib:
	@echo "-------------------------------------------------------------------"
	@echo "Install the PICO LIB"
	@if [ -d $(PICO_LIB) ]; then \
		cd $(PICO_LIB) && git pull && git submodule init; \
	else \
		git clone -b main https://github.com/thing-a-verse/rpi-pico-lib.git $(PICO_LIB) && cd $(PICO_LIB) && git submodule update --init; \
	fi
	@echo "Done"

uninstall:
	@echo "-------------------------------------------------------------------"
	@echo "Uninstall the SDK"
	@if [ -d $(SDK) ]; then rm -rf $(SDK); fi
	@echo "Uninstall the Examples"
	@if [ -d $(PICO_LIB) ]; then rm -rf $(EXAMPLES); fi
	@echo "Uninstall the SDK Build environment"
	@if [ -d $(BUILD) ]; then rm -rf $(BUILD); fi
	@echo "Uninstall the SRC Build environment"
	@if [ -d $(SRC)/$(BUILD) ]; then rm -rf $(SRC)/$(BUILD); fi
	@echo "Done"



examples:
	@echo "-------------------------------------------------------------------"
	@echo "Install the Examples"
	@if [ -d $(EXAMPLES) ]; then \
		cd $(EXAMPLES) && git pull && git submodule init; \
	else \
	  git clone https://github.com/raspberrypi/pico-examples.git --branch master && cd $(EXAMPLES) &&	git submodule update --init; \
	fi
	@echo "Done"



build-sdk:
	@echo "-------------------------------------------------------------------"
	@echo "Install the Build environment & initialise it"
	@echo PICO_SDK_PATH=${PICO_SDK_PATH}
	@echo PICO_TOOLCHAIN_PATH=${PICO_TOOLCHAIN_PATH}
	@mkdir -p $(PROJECTDIR)/bin
	#@mkdir -p $(BUILD_SDK) && cd $(BUILD_SDK) && $(CMAKE) -B . -S  $(PROJECTDIR)/pico-sdk && $(MAKE) -j4
	@$(CMAKE) -B $(BUILD_SDK) -S $(PROJECTDIR)/pico-sdk && $(MAKE) -C $(BUILD_SDK) -j4 
	@echo "Done"




clean:
	@echo "-------------------------------------------------------------------"
	@echo "Clean"
	@echo "Remove compiled binries"
	@if [ -d $(PROJECTDIR)/bin ]; then rm -rf $(PROJECTDIR)/bin; fi
	@echo "Remove compiled libraries"
	@if [ -d $(PROJECTDIR)/lib ]; then rm -rf $(PROJECTDIR)/lib; fi
	@echo "Remove build files"
#	@if [ -d $(BUILD) ]; then rm -rf $(BUILD)/; fi
	@if [ -d $(BUILD_SDK) ]; then rm -rf $(BUILD_SDK)/; fi
	@if [ -d $(BUILD_SRC) ]; then rm -rf $(BUILD_SRC)/; fi
	-rm -rf src/pico-lorawan/download


clobber: clean
		@echo "-------------------------------------------------------------------"
		@echo "Clobber"
		@echo "Remove SDK build files"
		@if [ -d $(SDK) ]; then rm -rf $(SDK)/; fi
		@if [ -d $(PICO_LIB) ]; then rm -rf $(PICO_LIB)/; fi
		@if [ -d $(BUILD) ]; then rm -rf $(BUILD)/; fi
		@if [ -d $(BUILD_SDK) ]; then rm -rf $(BUILD_SDK)/; fi

$(MODULES):
	@echo "-------------------------------------------------------------------"
	@echo "Build target $@ --> $(TARGET)"
	@echo PICO_SDK_PATH=$(PICO_SDK_PATH)
	@echo PICO_TOOLCHAIN_PATH=$(PICO_TOOLCHAIN_PATH)
	@echo PROJECTDIR=$(PROJECTDIR)
	mkdir -p $(BUILD_SRC) && cd $(BUILD_SRC) && $(CMAKE) -B ./ -S $(PROJECTDIR) \
	 -DMAKE_TARGET=$@ \
	 -DPICO_SDK_PATH=$(PICO_SDK_PATH) \
	 -DPICO_BOARD=$(PICO_BOARD) \
	 -DPROJECTDIR=$(PROJECTDIR) \
	 -DWIFI_SSID=$(WIFI_SSID) \
	 -DWIFI_PASSWORD=$(WIFI_PASSWORD)  \
	&& $(MAKE) $(MAKE_ARGS) -j4
	@echo "Upload firmware to device"
	cp $(PROJECTDIR)/bin/$@.uf2 /Volumes/RPI-RP2
	@sleep 3
	@echo "Examine log: Use CTRL-A, CTRL-\ to exit"
	-screen /dev/cu.usbmodem14101
	# -screen /dev/cu.usbmodem142101
	-stty sane

monitor:
	@echo "-------------------------------------------------------------------"
	@echo "Logger"
	@echo "Examine log: Use CTRL-A, CTRL-\ to exit"
	screen /dev/cu.usbmodem14101
# end
