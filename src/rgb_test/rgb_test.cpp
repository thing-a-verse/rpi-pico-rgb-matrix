// Standardised DEBUG CODE ////////////////////////////////////////////////////
//
// Toggle true or false to turn on globally, or comment out to disable.
#define _DEBUG true

// Manually define this here if you want debugging of the main code only, but
// not the libraries or define in CMakeLists.txt to enable global debugging.
// This MACRO controls if debuig code is included in the binary.
// #define COMPILE_DEBUG_CODE

#ifdef _DEBUG
 bool _debug = _DEBUG;
#else
 bool _debug = false;
#endif

// Our debug header

#include "pico/stdlib.h"
#include <cstdio>


#include "pico_debug.h"

#include "pico_utils.h"

int main(int argc, char** argv) {
    // Our RPI PICO utilities package
    PicoUtils* pu       = new PicoUtils(_debug);

    // Initialise the RPI PICO to get everything ready to start
    if (pu->begin(PICO)==false)
        return -1;

    DEBUG("Hello, World!\n");
 
    // Flash the LED on the RPI PICO
    pu->flashLED(1000);
    pu->flashLED(1000);

    DEBUG("Flash done\n");

    while(1);
}