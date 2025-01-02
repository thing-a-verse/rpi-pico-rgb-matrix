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

int main(int argc, char** argv) {
   stdio_init_all();
   sleep_ms(5000);
   STATUS ("Hello, World!\n");
   DEBUG("Hello, World!\n");
   while(1);
}