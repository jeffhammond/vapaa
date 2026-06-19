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
enable_language(Fortran)
enable_language(C)
enable_testing()
include(ExternalProject)
option(VAPAA_ENABLE_MPI_MODULE_TESTS
       "Build imported MPICH f90 tests for the integer-handle mpi module"
       OFF)
option(VAPAA_ENABLE_MPIFH_TESTS
       "Build imported MPICH f77 tests for the mpif.h include binding"
       OFF)
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF) 

set(CMAKE_Fortran_STANDARD 2018)
set(CMAKE_Fortran_STANDARD_REQUIRED ON)

set(VAPAA_MPIEXEC_EXPLICIT FALSE)
if(DEFINED MPIEXEC_EXECUTABLE OR DEFINED CACHE{MPIEXEC_EXECUTABLE})
  set(VAPAA_MPIEXEC_EXPLICIT TRUE)
endif()

function(vapaa_prefer_mpiexec_from_mpicc)
  if(NOT MPI_C_COMPILER)
    return()
  endif()

  set(vapaa_mpicc_path "${MPI_C_COMPILER}")
  if(NOT IS_ABSOLUTE "${vapaa_mpicc_path}")
    find_program(vapaa_mpicc_path NAMES "${MPI_C_COMPILER}")
  endif()
  if(NOT vapaa_mpicc_path)
    return()
  endif()

  get_filename_component(vapaa_mpi_bin "${vapaa_mpicc_path}" DIRECTORY)
  find_program(vapaa_mpiexec_path
    NAMES mpiexec mpiexec.hydra mpirun
    PATHS "${vapaa_mpi_bin}"
    NO_DEFAULT_PATH)
  if(NOT vapaa_mpiexec_path)
    return()
  endif()

  if(NOT MPIEXEC_EXECUTABLE STREQUAL vapaa_mpiexec_path)
    set(MPIEXEC_EXECUTABLE "${vapaa_mpiexec_path}"
      CACHE FILEPATH "MPI launcher matching MPI_C_COMPILER" FORCE)
    set(MPIEXEC_EXECUTABLE "${vapaa_mpiexec_path}" PARENT_SCOPE)
    message(STATUS "Using MPI launcher from MPI_C_COMPILER path: ${vapaa_mpiexec_path}")
  endif()
endfunction()

if(NOT VAPAA_MPIEXEC_EXPLICIT)
  vapaa_prefer_mpiexec_from_mpicc()
endif()

find_package(MPI REQUIRED COMPONENTS C)

if(NOT VAPAA_MPIEXEC_EXPLICIT)
  vapaa_prefer_mpiexec_from_mpicc()
endif()

set(SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/source")

# Create the static library
set(vapa_lib vapa)

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
    set(FLAG_MPI "UnknownMPI")
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
  PROPERTIES ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
             Fortran_MODULE_DIRECTORY "${CMAKE_BINARY_DIR}/modules")

add_subdirectory(source)
add_subdirectory(tests)
add_subdirectory(perf)
