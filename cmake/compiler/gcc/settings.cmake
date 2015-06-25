# -*- mode: cmake; -*-
#
#  Figure out the version of the used compiler
#  Variables set by this module
#  CMAKE_CXX_COMPILER_MAJOR  major version of compiler
#  CMAKE_CXX_COMPILER_MINR   minor version of compiler
#  CMAKE_CXX_COMPILER_PATCH  patch level (e.g. gcc 4.1.0)
#

# check the version of the compiler
set(CMAKE_CXX_COMPILER_MAJOR "CMAKE_CXX_COMPILER_MAJOR-NOTFOUND")
set(CMAKE_CXX_COMPILER_MINOR "CMAKE_CXX_COMPILER_MINOR-NOTFOUND")
set(CMAKE_CXX_COMPILER_PATCH "CMAKE_CXX_COMPILER_PATCH-NOTFOUND")

# only available in Cmake 2.8.9, 
# extract version from command line if not available
if(NOT CMAKE_CXX_COMPILER_VERSION) 
  # extract the version of the compiler
  execute_process(COMMAND ${CMAKE_CXX_COMPILER} -dumpversion
      OUTPUT_VARIABLE CMAKE_CXX_COMPILER_VERSION)
  string(REGEX REPLACE "^([0-9]+)\\.([0-9]+).*$" "\\1"
         CMAKE_CXX_COMPILER_MAJOR ${CMAKE_CXX_COMPILER_VERSION})
  string(REGEX REPLACE "^([0-9]+)\\.([0-9]+).*" "\\2"
         CMAKE_CXX_COMPILER_MINOR ${CMAKE_CXX_COMPILER_VERSION})
  set(CMAKE_CXX_COMPILER_PATCH "")
else(NOT CMAKE_CXX_COMPILER_VERSION)
  string(REGEX MATCH "([0-9]*)\\.([0-9]*)\\.([0-9]*)" major ${CMAKE_CXX_COMPILER_VERSION})
  set(CMAKE_CXX_COMPILER_MAJOR ${CMAKE_MATCH_1})
  set(CMAKE_CXX_COMPILER_MINOR ${CMAKE_MATCH_2})
  set(CMAKE_CXX_COMPILER_PATCH ${CMAKE_MATCH_3})
endif(NOT CMAKE_CXX_COMPILER_VERSION)


# just print the results if requested
function(info_compiler)
  message(STATUS "CMAKE_FORCE_CXX_COMPILER  = '${CMAKE_FORCE_CXX_COMPILER}'")
  message(STATUS "CMAKE_CXX_COMPILER        = '${CMAKE_CXX_COMPILER}'")
  message(STATUS "CMAKE_CXX_COMPILER_ID     = '${CMAKE_CXX_COMPILER_ID}'")
  message(STATUS "CMAKE_CXX_COMPILER_INIT   = '${CMAKE_CXX_COMPILER_INIT}'")
  message(STATUS "CMAKE_GENERATOR_CXX       = '${CMAKE_GENERATOR_CXX}'")
  message(STATUS "CMAKE_GNULD_IMAGE_VERSION = '${CMAKE_GNULD_IMAGE_VERSION}'")
  message(STATUS "CMAKE_CXX_COMPILER_VERSION= '${CMAKE_CXX_COMPILER_VERSION}'")
  message(STATUS "CMAKE_CXX_COMPILER_MAJOR  = '${CMAKE_CXX_COMPILER_MAJOR}'")
  message(STATUS "CMAKE_CXX_COMPILER_MINOR  = '${CMAKE_CXX_COMPILER_MINOR}'")
  message(STATUS "CMAKE_CXX_COMPILER_PATCH  = '${CMAKE_CXX_COMPILER_PATCH}'")
endfunction(info_compiler)

# Set build-directive (used in core to tell which buildtype we used)
add_definitions(-D_BUILD_DIRECTIVE='"${CMAKE_BUILD_TYPE}"')

set(GCC_EXPECTED_VERSION 4.7.2)

if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS GCC_EXPECTED_VERSION)
  message(FATAL_ERROR "GCC: TrinityCore requires version ${GCC_EXPECTED_VERSION} to build but found ${CMAKE_CXX_COMPILER_VERSION}")
endif()

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
message(STATUS "GCC: Enabled c++11 support")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=gnu99")
message(STATUS "GCC: Enabled C99 support")

if(PLATFORM EQUAL 32)
  # Required on 32-bit systems to enable SSE2 (standard on x64)
  set(SSE_FLAGS "-msse2 -mfpmath=sse")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${SSE_FLAGS}")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${SSE_FLAGS}")
endif()
add_definitions(-DHAVE_SSE2 -D__SSE2__)
message(STATUS "GCC: SFMT enabled, SSE2 flags forced")

if( WITH_WARNINGS )
  set(WARNING_FLAGS "-W -Wall -Wextra -Winit-self -Winvalid-pch -Wfatal-errors")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${WARNING_FLAGS}")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${WARNING_FLAGS} -Woverloaded-virtual")
  message(STATUS "GCC: All warnings enabled")
endif()

if( WITH_COREDEBUG )
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g3")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g3")
  message(STATUS "GCC: Debug-flags set (-g3)")
endif()
