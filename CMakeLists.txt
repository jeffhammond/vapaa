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
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
include(GNUInstallDirs)
enable_language(Fortran)
enable_language(C)

option(VAPAA_ENABLE_TESTING "Build tests" OFF)

if(VAPAA_ENABLE_TESTING)
enable_testing()
endif()
include(ExternalProject)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF) 

find_package(MPI REQUIRED COMPONENTS C)

set(SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/source")

# Create the static library
set(vapaa_lib vapaa)

add_library(${vapaa_lib} STATIC)

if(DEFINED MPI_VENDOR)
  set(FLAG_MPI ${MPI_VENDOR})
  message(STATUS "MPI Vendor explicitly set to: ${MPI_VENDOR}")
else()
  message(STATUS "The mpi compiler is in: ${MPI_C_COMPILER}")
  # the "finding" MPI really depends on the path having the name of the MPI
  # cmake does not have a MPI_LIBRARY_NAME variable that will 100% give us the 
  # name. Additionally, these flags are set based on the Makefiles included with 
  # vapaa upon which this CMake is based on
  if(MPI_C_COMPILER MATCHES "openmpi|ompi")
    set(FLAG_MPI -DOPEN_MPI)
  elseif(MPI_C_COMPILER MATCHES "mpich")
    set(FLAG_MPI -DMPICH)
  elseif(MPI_C_COMPILER MATCHES "intel")
    set(FLAG_MPI -DMPICH)
  elseif(MPI_C_COMPILER MATCHES "cray")
    # this is based on most cray machines using cray-mpich
    set(FLAG_MPI -DMPICH)
  else()
    #set(FLAG_MPI "UnknownMPI")
    set(FLAG_MPI -DOPEN_MPI)
    set(WARNING "Automatic detection failed, assuming OpenMPI")
  endif()
  message(STATUS "Automatically detected MPI Vendor: ${FLAG_MPI}")
endif()

message(STATUS "Final MPI Vendor Flag: ${FLAG_MPI}")

set(WARNFLAGS "-Wall -Wextra -fPIE") 
if(CMAKE_Fortran_COMPILER_ID MATCHES "GNU")
    set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} ${WARNFLAGS} -g -std=f2018")
elseif(CMAKE_Fortran_COMPILER_ID MATCHES "LLVMFlang")
    set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS}  -g -std=f2018")
elseif(CMAKE_Fortran_COMPILER_ID MATCHES "NAG")
# this is a hack for now
    # Get the full path to the NAG Fortran compiler
    get_filename_component(NAGFOR_PATH "${CMAKE_Fortran_COMPILER}" REALPATH)
    # Go up two directories to reach $NAG_ROOT (assuming $NAG_ROOT/bin/nagfor)
    get_filename_component(NAG_ROOT "${NAGFOR_PATH}" DIRECTORY) # bin/
    get_filename_component(NAG_ROOT "${NAG_ROOT}" DIRECTORY)    # $NAG_ROOT/
    message(STATUS "NAG HOME is in ${NAG_ROOT}")
    target_include_directories(${vapaa_lib} PRIVATE ${NAG_ROOT}/lib)
    set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -g -f2018")
elseif(CMAKE_Fortran_COMPILER_ID MATCHES "Intel")
    set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS}  -g -stand f18")
elseif(CMAKE_Fortran_COMPILER_ID MATCHES "IntelLLVM")
    set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS}  -g -stand f18")
elseif(CMAKE_Fortran_COMPILER_ID MATCHES "Cray")
    set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS}  -g ")
elseif(CMAKE_Fortran_COMPILER_ID MATCHES "NVHPC")
    set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS}  -g ")
else()
    message(WARNING "Unknown Fortran compiler: ${CMAKE_Fortran_COMPILER_ID}")
    message(WARNING "F2018 standard may not be properly set")
    set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} ${WARNFLAGS} -g")
endif()

# Display final flags
message(STATUS "Fortran compiler flags: ${CMAKE_Fortran_FLAGS}")

target_compile_definitions(${vapaa_lib} PRIVATE -DHAVE_CFI ${FLAG_MPI})
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

