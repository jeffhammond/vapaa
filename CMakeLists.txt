cmake_minimum_required(VERSION 3.21)
cmake_policy(SET CMP0074 NEW)
cmake_policy(SET CMP0083 NEW)
cmake_policy(SET CMP0104 NEW)
if(POLICY CMP0135)
  cmake_policy(SET CMP0135 NEW)
endif()
cmake_policy(SET CMP0054 NEW)
cmake_policy(SET CMP0048 NEW)

project(
  vapaa
  VERSION 0.0.0
  LANGUAGES Fortran C)
set(project_name vapaa)
include(GNUInstallDirs)

option(VAPAA_ENABLE_TESTING "Build tests" OFF)

if(VAPAA_ENABLE_TESTING)
enable_testing()
endif()
include(ExternalProject)
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF) 

set(CMAKE_Fortran_STANDARD 2018)
set(CMAKE_Fortran_STANDARD_REQUIRED ON)

find_package(MPI REQUIRED COMPONENTS C Fortran)

# this was needed on mac for some reason (?)
find_file(ISO_FORTRAN_BINDING_HEADER
  NAMES ISO_Fortran_binding.h
  HINTS ${MPI_Fortran_INCLUDE_DIRS})
if(NOT ISO_FORTRAN_BINDING_HEADER)
  execute_process(
    COMMAND ${CMAKE_Fortran_COMPILER} -print-file-name=include
    OUTPUT_VARIABLE _fc_include_dir
    OUTPUT_STRIP_TRAILING_WHITESPACE
    RESULT_VARIABLE _fc_include_rc)
  if(_fc_include_rc EQUAL 0 AND EXISTS "${_fc_include_dir}/ISO_Fortran_binding.h")
    set(ISO_FORTRAN_BINDING_HEADER "${_fc_include_dir}/ISO_Fortran_binding.h"
        CACHE FILEPATH "Path to ISO_Fortran_binding.h" FORCE)
  endif()
endif()
if(NOT ISO_FORTRAN_BINDING_HEADER)
  message(FATAL_ERROR "Could not locate ISO_Fortran_binding.h - set ISO_FORTRAN_BINDING_HEADER manually.")
endif()
message(STATUS "ISO_Fortran_binding.h found at: ${ISO_FORTRAN_BINDING_HEADER}")
set(ISO_FORTRAN_BINDING_STAGE_DIR "${PROJECT_BINARY_DIR}/iso_fortran_binding")
file(MAKE_DIRECTORY "${ISO_FORTRAN_BINDING_STAGE_DIR}")
configure_file("${ISO_FORTRAN_BINDING_HEADER}"
               "${ISO_FORTRAN_BINDING_STAGE_DIR}/ISO_Fortran_binding.h" COPYONLY)

set(SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/source")

# Create the static library
set(vapaa_lib vapaa)

add_library(${vapaa_lib} STATIC)

# MPI vendor selection.
#
# CMake cannot reliably tell which MPI implementation is in use from the
# compiler wrapper alone (e.g. on Cray the same `cc` wrapper can sit on top of
# MPICH, Cray-MPICH, or other libraries). The reliable way is to probe mpi.h
# itself for vendor macros. Users may also pin the choice explicitly via
# -DVAPAA_MPI_VENDOR=MPICH or -DVAPAA_MPI_VENDOR=OPEN_MPI.
set(VAPAA_MPI_VENDOR "" CACHE STRING "MPI vendor: MPICH or OPEN_MPI (auto-detected if empty)")
set_property(CACHE VAPAA_MPI_VENDOR PROPERTY STRINGS "" MPICH OPEN_MPI)

if(VAPAA_MPI_VENDOR)
  if(NOT VAPAA_MPI_VENDOR MATCHES "^(MPICH|OPEN_MPI)$")
    message(FATAL_ERROR "VAPAA_MPI_VENDOR must be either MPICH or OPEN_MPI (got: ${VAPAA_MPI_VENDOR})")
  endif()
  set(FLAG_MPI ${VAPAA_MPI_VENDOR})
  message(STATUS "MPI vendor explicitly set to: ${VAPAA_MPI_VENDOR}")
else()
  include(CheckCSourceCompiles)
  set(_save_includes ${CMAKE_REQUIRED_INCLUDES})
  set(_save_libraries ${CMAKE_REQUIRED_LIBRARIES})
  set(CMAKE_REQUIRED_INCLUDES ${MPI_C_INCLUDE_DIRS})
  set(CMAKE_REQUIRED_LIBRARIES ${MPI_C_LIBRARIES})
  check_c_source_compiles("
    #include <mpi.h>
    #ifndef MPICH
    #error not mpich
    #endif
    int main(void) { return 0; }
  " VAPAA_MPI_IS_MPICH)
  check_c_source_compiles("
    #include <mpi.h>
    #ifndef OPEN_MPI
    #error not openmpi
    #endif
    int main(void) { return 0; }
  " VAPAA_MPI_IS_OPENMPI)
  set(CMAKE_REQUIRED_INCLUDES ${_save_includes})
  set(CMAKE_REQUIRED_LIBRARIES ${_save_libraries})

  if(VAPAA_MPI_IS_MPICH)
    set(FLAG_MPI MPICH)
  elseif(VAPAA_MPI_IS_OPENMPI)
    set(FLAG_MPI OPEN_MPI)
  else()
    message(FATAL_ERROR
      "Could not auto-detect MPI vendor from mpi.h (neither MPICH nor "
      "OPEN_MPI macro is defined). Re-run cmake with -DVAPAA_MPI_VENDOR=MPICH or "
      "-DVAPAA_MPI_VENDOR=OPEN_MPI.")
  endif()
  message(STATUS "Auto-detected MPI vendor from mpi.h: ${FLAG_MPI}")
endif()

target_compile_options(${vapaa_lib} PRIVATE -Wall -Wextra -fPIE)
target_compile_definitions(${vapaa_lib} PRIVATE HAVE_CFI ${FLAG_MPI})
target_include_directories(${vapaa_lib} PRIVATE ${ISO_FORTRAN_BINDING_STAGE_DIR})
target_link_libraries(${vapaa_lib} PRIVATE MPI::MPI_C)

# Set the library output and module directories
set_target_properties(
  ${vapaa_lib}
  PROPERTIES ARCHIVE_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/lib"
             Fortran_MODULE_DIRECTORY "${PROJECT_BINARY_DIR}/include")

target_include_directories(${vapaa_lib}
  PUBLIC
    $<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/include>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)


add_subdirectory(source)
if(VAPAA_ENABLE_TESTING)
add_subdirectory(tests)
endif()

install(TARGETS ${vapaa_lib}
  EXPORT vapaaTargets
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  RUNTIME DESTINATION bin
)

install(DIRECTORY "${PROJECT_BINARY_DIR}/include/"
        DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
        )

install(EXPORT vapaaTargets
        FILE vapaaTargets.cmake
        NAMESPACE vapaa::
        DESTINATION lib/cmake/vapaa)

