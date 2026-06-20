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
option(VAPAA_ENABLE_CFI
       "Build CFI assumed-type/assumed-rank buffer bindings"
       ON)
option(VAPAA_ENABLE_PGIF
       "Build NVHPC PGI descriptor buffer bindings"
       ON)
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF) 

set(CMAKE_Fortran_STANDARD 2018)
set(CMAKE_Fortran_STANDARD_REQUIRED ON)

set(VAPAA_C_WARNING_OPTIONS
  $<$<COMPILE_LANGUAGE:C>:-Wall>
  $<$<COMPILE_LANGUAGE:C>:-Wextra>)
set(VAPAA_FORTRAN_WARNING_OPTIONS)
if(NOT CMAKE_Fortran_COMPILER_ID STREQUAL "LLVMFlang")
  list(APPEND VAPAA_FORTRAN_WARNING_OPTIONS
    $<$<COMPILE_LANGUAGE:Fortran>:-Wall>
    $<$<COMPILE_LANGUAGE:Fortran>:-Wextra>)
endif()

set(VAPAA_FORTRAN_CFI_INCLUDE_DIR "" CACHE PATH
  "Directory containing ISO_Fortran_binding.h for the active Fortran compiler")
if(VAPAA_ENABLE_CFI AND NOT VAPAA_FORTRAN_CFI_INCLUDE_DIR)
  set(vapaa_cfi_include_candidates "")
  if(CMAKE_Fortran_COMPILER_ID STREQUAL "LLVMFlang")
    execute_process(
      COMMAND "${CMAKE_Fortran_COMPILER}" -print-resource-dir
      OUTPUT_VARIABLE vapaa_flang_resource_dir
      ERROR_QUIET
      RESULT_VARIABLE vapaa_flang_resource_result
      OUTPUT_STRIP_TRAILING_WHITESPACE)
    if(vapaa_flang_resource_result EQUAL 0 AND
       NOT vapaa_flang_resource_dir STREQUAL "")
      get_filename_component(vapaa_flang_resource_parent
        "${vapaa_flang_resource_dir}" DIRECTORY)
      get_filename_component(vapaa_flang_lib_dir
        "${vapaa_flang_resource_parent}" DIRECTORY)
      get_filename_component(vapaa_flang_root
        "${vapaa_flang_lib_dir}" DIRECTORY)
      list(APPEND vapaa_cfi_include_candidates
        "${vapaa_flang_root}/include/flang")
    endif()
  endif()

  get_filename_component(vapaa_fortran_compiler_realpath
    "${CMAKE_Fortran_COMPILER}" REALPATH)
  get_filename_component(vapaa_fortran_compiler_bindir
    "${vapaa_fortran_compiler_realpath}" DIRECTORY)
  get_filename_component(vapaa_fortran_compiler_root
    "${vapaa_fortran_compiler_bindir}" DIRECTORY)
  list(APPEND vapaa_cfi_include_candidates
    "${vapaa_fortran_compiler_root}/include"
    "${vapaa_fortran_compiler_root}/include/flang")

  find_path(vapaa_detected_fortran_cfi_include_dir
    NAMES ISO_Fortran_binding.h
    HINTS ${vapaa_cfi_include_candidates}
    NO_DEFAULT_PATH)
  if(vapaa_detected_fortran_cfi_include_dir)
    set(VAPAA_FORTRAN_CFI_INCLUDE_DIR
      "${vapaa_detected_fortran_cfi_include_dir}" CACHE PATH
      "Directory containing ISO_Fortran_binding.h for the active Fortran compiler"
      FORCE)
  endif()
endif()
if(VAPAA_ENABLE_CFI AND VAPAA_FORTRAN_CFI_INCLUDE_DIR)
  message(STATUS
    "Using Fortran compiler CFI header: ${VAPAA_FORTRAN_CFI_INCLUDE_DIR}")
endif()

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

function(vapaa_seed_intel_mpi_root_from_mpicc)
  if(NOT MPI_C_COMPILER OR DEFINED ENV{I_MPI_ROOT})
    return()
  endif()

  set(vapaa_mpicc_path "${MPI_C_COMPILER}")
  if(NOT IS_ABSOLUTE "${vapaa_mpicc_path}")
    find_program(vapaa_mpicc_path NAMES "${MPI_C_COMPILER}")
  endif()
  if(NOT vapaa_mpicc_path)
    return()
  endif()

  execute_process(
    COMMAND "${vapaa_mpicc_path}" -show
    OUTPUT_VARIABLE vapaa_mpicc_show
    ERROR_VARIABLE vapaa_mpicc_show_error
    RESULT_VARIABLE vapaa_mpicc_show_result
    OUTPUT_STRIP_TRAILING_WHITESPACE
    ERROR_STRIP_TRAILING_WHITESPACE)
  if(vapaa_mpicc_show_result EQUAL 0)
    set(vapaa_mpicc_probe "${vapaa_mpicc_show}")
  else()
    set(vapaa_mpicc_probe "${vapaa_mpicc_show_error}")
  endif()

  if(NOT vapaa_mpicc_probe MATCHES "I_MPI_SUBSTITUTE_INSTALLDIR")
    return()
  endif()

  get_filename_component(vapaa_mpicc_realpath "${vapaa_mpicc_path}" REALPATH)
  get_filename_component(vapaa_mpi_bin "${vapaa_mpicc_realpath}" DIRECTORY)
  get_filename_component(vapaa_mpi_root "${vapaa_mpi_bin}" DIRECTORY)
  if(EXISTS "${vapaa_mpi_root}/include/mpi.h" AND EXISTS "${vapaa_mpi_root}/lib")
    set(ENV{I_MPI_ROOT} "${vapaa_mpi_root}")
    message(STATUS "Using Intel MPI root from MPI_C_COMPILER path: ${vapaa_mpi_root}")
  endif()
endfunction()

vapaa_seed_intel_mpi_root_from_mpicc()

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
if(VAPAA_FORTRAN_CFI_INCLUDE_DIR)
  target_include_directories(${vapa_lib}
    BEFORE PRIVATE
      $<$<COMPILE_LANGUAGE:C>:${VAPAA_FORTRAN_CFI_INCLUDE_DIR}>)
endif()

set(VAPAA_GIT_HASH "unknown")
set(VAPAA_GIT_DIRTY "unknown")
find_package(Git QUIET)
if(GIT_FOUND)
  execute_process(
    COMMAND "${GIT_EXECUTABLE}" rev-parse --short=12 HEAD
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
    OUTPUT_VARIABLE VAPAA_GIT_HASH_OUTPUT
    ERROR_QUIET
    OUTPUT_STRIP_TRAILING_WHITESPACE
    RESULT_VARIABLE VAPAA_GIT_HASH_RESULT)
  if(VAPAA_GIT_HASH_RESULT EQUAL 0 AND NOT VAPAA_GIT_HASH_OUTPUT STREQUAL "")
    set(VAPAA_GIT_HASH "${VAPAA_GIT_HASH_OUTPUT}")
  endif()

  execute_process(
    COMMAND "${GIT_EXECUTABLE}" diff-index --quiet HEAD --
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
    OUTPUT_QUIET
    ERROR_QUIET
    RESULT_VARIABLE VAPAA_GIT_DIRTY_RESULT)
  if(VAPAA_GIT_DIRTY_RESULT EQUAL 0)
    set(VAPAA_GIT_DIRTY "clean")
  elseif(VAPAA_GIT_DIRTY_RESULT EQUAL 1)
    set(VAPAA_GIT_DIRTY "dirty")
  endif()
endif()

function(vapaa_set_mpi_compatibility vapaa_mpi_vendor)
  string(TOUPPER "${vapaa_mpi_vendor}" vapaa_mpi_vendor_upper)
  string(REGEX REPLACE "^-D" "" vapaa_mpi_vendor_upper "${vapaa_mpi_vendor_upper}")

  if(vapaa_mpi_vendor_upper MATCHES "^(MPI_ABI|ABI)$")
    set(FLAG_MPI MPI_ABI PARENT_SCOPE)
    set(VAPAA_MPI_VENDOR_LABEL MPI_ABI PARENT_SCOPE)
  elseif(vapaa_mpi_vendor_upper MATCHES "^(NVIDIA_HPCX|HPCX|NVHPC)$")
    set(FLAG_MPI OPEN_MPI PARENT_SCOPE)
    set(VAPAA_MPI_VENDOR_LABEL NVIDIA_HPCX PARENT_SCOPE)
  elseif(vapaa_mpi_vendor_upper MATCHES "^(OPEN_MPI|OPENMPI|OMPI)$")
    set(FLAG_MPI OPEN_MPI PARENT_SCOPE)
    set(VAPAA_MPI_VENDOR_LABEL OPEN_MPI PARENT_SCOPE)
  elseif(vapaa_mpi_vendor_upper MATCHES "^(INTEL_MPI|INTELMPI|INTEL|ONEAPI|IMPI)$")
    set(FLAG_MPI MPICH PARENT_SCOPE)
    set(VAPAA_MPI_VENDOR_LABEL INTEL_MPI PARENT_SCOPE)
  elseif(vapaa_mpi_vendor_upper MATCHES "^(CRAY_HPE_MPI|CRAY_MPICH|CRAYMPI|CRAY|HPE_MPI|HPE-MPI|HPE|MPT)$")
    set(FLAG_MPI MPICH PARENT_SCOPE)
    set(VAPAA_MPI_VENDOR_LABEL CRAY_HPE_MPI PARENT_SCOPE)
  elseif(vapaa_mpi_vendor_upper STREQUAL "MPICH")
    set(FLAG_MPI MPICH PARENT_SCOPE)
    set(VAPAA_MPI_VENDOR_LABEL MPICH PARENT_SCOPE)
  else()
    message(FATAL_ERROR
      "Unsupported MPI_VENDOR='${vapaa_mpi_vendor}'. "
      "Use MPICH, OPEN_MPI, MPI_ABI, NVIDIA_HPCX, INTEL_MPI, or CRAY_HPE_MPI.")
  endif()
endfunction()

if(DEFINED MPI_VENDOR)
  vapaa_set_mpi_compatibility("${MPI_VENDOR}")
  message(STATUS
    "MPI Vendor explicitly set to: ${VAPAA_MPI_VENDOR_LABEL} "
    "(using ${FLAG_MPI} compatibility)")
else()
  set(vapaa_mpi_probe_text "")
  foreach(vapaa_mpi_probe_var IN ITEMS
      MPI_C_COMPILER
      MPI_C_LIBRARIES
      MPI_C_INCLUDE_DIRS
      MPI_C_COMPILE_OPTIONS
      MPI_C_LINK_FLAGS
      MPI_C_HEADER_DIR
      MPIEXEC_EXECUTABLE)
    if(DEFINED ${vapaa_mpi_probe_var})
      string(APPEND vapaa_mpi_probe_text " ${${vapaa_mpi_probe_var}}")
    endif()
  endforeach()

  if(MPI_C_COMPILER)
    execute_process(
      COMMAND "${MPI_C_COMPILER}" -show
      OUTPUT_VARIABLE vapaa_mpicc_show
      ERROR_VARIABLE vapaa_mpicc_show_error
      RESULT_VARIABLE vapaa_mpicc_show_result
      OUTPUT_STRIP_TRAILING_WHITESPACE
      ERROR_STRIP_TRAILING_WHITESPACE)
    if(vapaa_mpicc_show_result EQUAL 0)
      string(APPEND vapaa_mpi_probe_text " ${vapaa_mpicc_show}")
    else()
      string(APPEND vapaa_mpi_probe_text " ${vapaa_mpicc_show_error}")
    endif()
  endif()

  string(TOLOWER "${vapaa_mpi_probe_text}" vapaa_mpi_probe_text_lower)
  if(vapaa_mpi_probe_text_lower MATCHES "mpi[_-]abi|mpi-abi-stubs|libmpi_abi")
    set(FLAG_MPI MPI_ABI)
    set(VAPAA_MPI_VENDOR_LABEL MPI_ABI)
  elseif(vapaa_mpi_probe_text_lower MATCHES "hpcx|nvhpc|nvidia.*/.*hpc_sdk")
    set(FLAG_MPI OPEN_MPI)
    set(VAPAA_MPI_VENDOR_LABEL NVIDIA_HPCX)
  elseif(vapaa_mpi_probe_text_lower MATCHES "open[ -]?mpi|openmpi|/ompi/|/openmpi/|ompi")
    set(FLAG_MPI OPEN_MPI)
    set(VAPAA_MPI_VENDOR_LABEL OPEN_MPI)
  elseif(vapaa_mpi_probe_text_lower MATCHES "intel|oneapi|impi")
    set(FLAG_MPI MPICH)
    set(VAPAA_MPI_VENDOR_LABEL INTEL_MPI)
  elseif(vapaa_mpi_probe_text_lower MATCHES "cray|hpe|hpe-mpi|cray-mpich|mpt")
    set(FLAG_MPI MPICH)
    set(VAPAA_MPI_VENDOR_LABEL CRAY_HPE_MPI)
  elseif(vapaa_mpi_probe_text_lower MATCHES "mpich|hydra")
    set(FLAG_MPI MPICH)
    set(VAPAA_MPI_VENDOR_LABEL MPICH)
  else()
    message(FATAL_ERROR
      "Could not auto-detect MPI vendor from CMake MPI_C variables. "
      "Set MPI_VENDOR to one of MPICH, OPEN_MPI, MPI_ABI, NVIDIA_HPCX, "
      "INTEL_MPI, or CRAY_HPE_MPI.")
  endif()
  message(STATUS
    "Automatically detected MPI Vendor: ${VAPAA_MPI_VENDOR_LABEL} "
    "(using ${FLAG_MPI} compatibility)")
endif()

message(STATUS "Final MPI compatibility flag: ${FLAG_MPI}")

if(CMAKE_Fortran_COMPILER_ID STREQUAL "NVHPC" AND VAPAA_ENABLE_CFI)
  message(WARNING
    "Disabling VAPAA_ENABLE_CFI for NVHPC: this compiler currently forwards "
    "assumed-type CFI buffer descriptors without reliable element metadata.")
  set(VAPAA_ENABLE_CFI OFF CACHE BOOL
      "Build CFI assumed-type/assumed-rank buffer bindings" FORCE)
endif()

set(VAPAA_HAVE_PGIF OFF)
if(CMAKE_Fortran_COMPILER_ID STREQUAL "NVHPC" AND VAPAA_ENABLE_PGIF)
  set(VAPAA_HAVE_PGIF ON)
  message(STATUS "Enabling NVHPC PGI descriptor buffer bindings")
endif()

target_compile_options(${vapa_lib} PRIVATE
  ${VAPAA_C_WARNING_OPTIONS}
  ${VAPAA_FORTRAN_WARNING_OPTIONS}
  -fPIE)
target_compile_definitions(${vapa_lib} PRIVATE
  ${FLAG_MPI}
  VAPAA_MPI_VENDOR_LABEL="${VAPAA_MPI_VENDOR_LABEL}"
  VAPAA_GIT_HASH="${VAPAA_GIT_HASH}"
  VAPAA_GIT_DIRTY="${VAPAA_GIT_DIRTY}")
if(VAPAA_ENABLE_CFI)
  target_compile_definitions(${vapa_lib} PRIVATE HAVE_CFI)
endif()
if(VAPAA_HAVE_PGIF)
  target_compile_definitions(${vapa_lib} PRIVATE HAVE_PGIF)
endif()
target_link_libraries(${vapa_lib} PRIVATE MPI::MPI_C)

# Set the library output and module directories
set_target_properties(
  ${vapa_lib}
  PROPERTIES ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
             Fortran_MODULE_DIRECTORY "${CMAKE_BINARY_DIR}/modules")

add_subdirectory(source)
add_subdirectory(tests)
add_subdirectory(perf)
