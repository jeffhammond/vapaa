cmake_minimum_required(VERSION 3.21)
cmake_policy(SET CMP0074 NEW)
cmake_policy(SET CMP0083 NEW)
cmake_policy(SET CMP0104 NEW)
if(POLICY CMP0135)
  cmake_policy(SET CMP0135 NEW)
endif()
cmake_policy(SET CMP0054 NEW)
cmake_policy(SET CMP0048 NEW)

# Project name and settings
project(
  pic
  VERSION 0.0.0
  LANGUAGES Fortran C)
set(project_name vapaa)
enable_language(Fortran)
enable_language(C)
enable_testing()
include(ExternalProject)
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)  # Optionally enforce standard compliance

# Set the Fortran standard to Fortran 2018
set(CMAKE_Fortran_STANDARD 2018)
set(CMAKE_Fortran_STANDARD_REQUIRED ON)

find_package(MPI)
# Set the source directory path
set(SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/source")

# Create the static library
set(vapa_lib vapa)
#set(math_lib pic_math)
#set(debug_exec_name ${project_name})

add_library(${vapa_lib} STATIC)

#add_library(${math_lib} STATIC)
target_compile_options(${vapa_lib} PRIVATE -Wall -Wextra -fPIE) 
target_compile_definitions(${vapa_lib} PRIVATE -DHAVE_CFI -DOPEN_MPI)
target_link_libraries(${vapa_lib} PRIVATE MPI::MPI_Fortran MPI::MPI_C)

# Set the library output and module directories
set_target_properties(
  ${vapa_lib}
  PROPERTIES ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
             Fortran_MODULE_DIRECTORY "${CMAKE_BINARY_DIR}/modules")
set_target_properties(
  ${math_lib} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
                         Fortran_MODULE_DIRECTORY "${CMAKE_BINARY_DIR}/modules")

add_subdirectory(source)
add_subdirectory(tests)
#add_executable(${debug_exec_name} ${PROJECT_SOURCE_DIR}/app/main.f90)
# Set the module directory for the executable
#target_include_directories(${debug_exec_name}
#                           PRIVATE "${CMAKE_BINARY_DIR}/modules")

# ${PROJECT_SOURCE_DIR}/lib/test-drive/lib/libtest-drive.a) Link the library to
# the executable
#target_link_libraries(
#  ${debug_exec_name}
#  PRIVATE ${vapa_lib} BLAS::BLAS LAPACK::LAPACK MPI::MPI_Fortran
#          ${PROJECT_SOURCE_DIR}/lib/test-drive/lib/libtest-drive.a)
