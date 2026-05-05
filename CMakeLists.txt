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

set(CMAKE_Fortran_STANDARD 2018)
set(CMAKE_Fortran_STANDARD_REQUIRED ON)

find_package(MPI REQUIRED COMPONENTS C)

set(SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/source")

# Create the static library
set(vapa_lib vapaa)

add_library(${vapa_lib} STATIC)

if(DEFINED MPI_VENDOR)
  set(FLAG_MPI ${MPI_VENDOR})
  message(STATUS "MPI Vendor explicitly set to: ${MPI_VENDOR}")
else()
  if(MPI_Fortran_COMPILER MATCHES "openmpi|ompi")
    set(FLAG_MPI -DOPEN_MPI)
  elseif(MPI_Fortran_COMPILER MATCHES "mpich")
    set(FLAG_MPI -DMPICH)
  elseif(MPI_Fortran_COMPILER MATCHES "intel")
    set(FLAG_MPI -DMPICH)
  elseif(MPI_Fortran_COMPILER MATCHES "cray")
    set(FLAG_MPI -DMPICH)
  else()
    #set(FLAG_MPI "UnknownMPI")
    set(FLAG_MPI -DOPEN_MPI)
    set(WARNING "Automatic detection failed, assuming OpenMPI")
  endif()
  message(STATUS "Automatically detected MPI Vendor: ${FLAG_MPI}")
endif()

message(STATUS "Final MPI Vendor Flag: ${FLAG_MPI}")

target_compile_options(${vapa_lib} PRIVATE -Wall -Wextra -fPIE) 
target_compile_definitions(${vapa_lib} PRIVATE -DHAVE_CFI ${FLAG_MPI})
target_link_libraries(${vapa_lib} PRIVATE MPI::MPI_C)

# Set the library output and module directories
set_target_properties(
  ${vapa_lib}
  PROPERTIES ARCHIVE_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/lib"
             Fortran_MODULE_DIRECTORY "${PROJECT_BINARY_DIR}/include")

target_include_directories(${vapa_lib}
  PUBLIC
    $<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/include>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)


add_subdirectory(source)
if(VAPAA_ENABLE_TESTING)
add_subdirectory(tests)
endif()

install(TARGETS ${vapa_lib}
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

