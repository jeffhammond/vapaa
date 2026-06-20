set(MPICH_MAIN_F90_ROOT "${CMAKE_CURRENT_SOURCE_DIR}")
set(MPICH_MAIN_UTIL_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/../util")
set(MPICH_MAIN_INCLUDE_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/../include")

if(NOT VAPAA_ENABLE_MPI_MODULE_TESTS)
  message(STATUS "Skipping MPICH main f90 tests: VAPAA_ENABLE_MPI_MODULE_TESTS is OFF")
  return()
endif()

find_package(Threads REQUIRED)

set(vapaa_mpich_main_f90_test_environment "")
if(FLAG_MPI MATCHES "OPEN_MPI")
  list(APPEND vapaa_mpich_main_f90_test_environment
    "OMPI_MCA_osc=pt2pt"
    "OMPI_MCA_coll_hcoll_enable=0"
    "OMPI_MCA_coll_ucc_enable=0"
    "OMPI_MCA_hwloc_base_binding_policy=none"
    "UCX_WARN_UNUSED_ENV_VARS=n")
endif()
set(vapaa_mpich_main_f90_library_dirs ${VAPAA_COMPILER_RUNTIME_LIBRARY_DIRS})
foreach(mpi_library IN LISTS MPI_C_LIBRARIES)
  if(IS_ABSOLUTE "${mpi_library}")
    get_filename_component(mpi_library_dir "${mpi_library}" DIRECTORY)
    list(APPEND vapaa_mpich_main_f90_library_dirs "${mpi_library_dir}")
  endif()
endforeach()
if(NOT vapaa_mpich_main_f90_library_dirs AND MPI_C_COMPILER)
  execute_process(
    COMMAND "${MPI_C_COMPILER}" -show
    OUTPUT_VARIABLE vapaa_mpich_main_f90_mpicc_show
    ERROR_VARIABLE vapaa_mpich_main_f90_mpicc_show_error
    RESULT_VARIABLE vapaa_mpich_main_f90_mpicc_show_result
    OUTPUT_STRIP_TRAILING_WHITESPACE)
  if(vapaa_mpich_main_f90_mpicc_show_result EQUAL 0)
    string(REGEX MATCHALL "(^| )-L[^ ]+" vapaa_mpich_main_f90_link_dirs
      "${vapaa_mpich_main_f90_mpicc_show}")
    foreach(link_dir IN LISTS vapaa_mpich_main_f90_link_dirs)
      string(STRIP "${link_dir}" link_dir)
      string(REGEX REPLACE "^-L" "" link_dir "${link_dir}")
      if(IS_ABSOLUTE "${link_dir}")
        list(APPEND vapaa_mpich_main_f90_library_dirs "${link_dir}")
      endif()
    endforeach()
  endif()
endif()
if(vapaa_mpich_main_f90_library_dirs)
  list(REMOVE_DUPLICATES vapaa_mpich_main_f90_library_dirs)
  string(JOIN ":" vapaa_mpich_main_f90_library_path
    ${vapaa_mpich_main_f90_library_dirs})
  if(DEFINED ENV{LD_LIBRARY_PATH} AND NOT "$ENV{LD_LIBRARY_PATH}" STREQUAL "")
    set(vapaa_mpich_main_f90_library_path
      "${vapaa_mpich_main_f90_library_path}:$ENV{LD_LIBRARY_PATH}")
  endif()
  list(APPEND vapaa_mpich_main_f90_test_environment
    "LD_LIBRARY_PATH=${vapaa_mpich_main_f90_library_path}")
endif()

set(vapaa_mpich_main_f90_fortran_options
  ${vapaa_mpich_main_imported_fortran_options}
  $<$<COMPILE_LANG_AND_ID:Fortran,GNU>:-fallow-argument-mismatch>)

add_library(mpich_main_mtest_f90 OBJECT
  "${MPICH_MAIN_UTIL_ROOT}/mtest_f90.f90")
target_compile_options(mpich_main_mtest_f90 PRIVATE
  ${vapaa_mpich_main_f90_fortran_options}
  $<$<COMPILE_LANG_AND_ID:Fortran,GNU>:-std=f2018>)
target_include_directories(mpich_main_mtest_f90
  PRIVATE "${CMAKE_BINARY_DIR}/modules" "${MPICH_MAIN_INCLUDE_ROOT}")
target_link_libraries(mpich_main_mtest_f90 PRIVATE ${vapa_lib})
set_target_properties(mpich_main_mtest_f90 PROPERTIES
  Fortran_MODULE_DIRECTORY "${CMAKE_BINARY_DIR}/tests/mpich_main/f90/modules")

function(vapaa_add_mpich_main_f90_test category test_name np)
  if(category STREQUAL "spawn")
    message(STATUS "Skipping MPICH main f90/spawn/${test_name}: Vapaa does not implement spawn support")
    return()
  endif()
  if(CMAKE_Fortran_COMPILER_ID STREQUAL "NVHPC"
      AND category STREQUAL "attr"
      AND test_name MATCHES "^(attrlangf90|fandcattrf90)$")
    message(STATUS
      "Skipping MPICH main f90/attr/${test_name}: NVHPC rejects old-style external callback actuals for module procedure dummies")
    return()
  endif()
  if(CMAKE_Fortran_COMPILER_ID STREQUAL "NVHPC"
      AND category STREQUAL "datatype"
      AND test_name STREQUAL "structf")
    message(STATUS
      "Skipping MPICH main f90/datatype/${test_name}: NVHPC crashes in MPICH packing for this imported MPI_BOTTOM struct send")
    return()
  endif()

  set(test_dir "${MPICH_MAIN_F90_ROOT}/${category}")
  set(f90_source "${test_dir}/${test_name}.f90")
  set(target_name "mpich_main_f90_${category}_${test_name}")
  set(extra_sources "")

  if(category STREQUAL "attr" AND test_name STREQUAL "attrlangf90")
    list(APPEND extra_sources "${f90_source}" "${test_dir}/attrlangc.c")
  elseif(category STREQUAL "attr" AND test_name STREQUAL "fandcattrf90")
    list(APPEND extra_sources "${f90_source}" "${test_dir}/fandcattrc.c")
  elseif(EXISTS "${f90_source}")
    list(APPEND extra_sources "${f90_source}")
  else()
    message(WARNING "Skipping missing MPICH main f90 test source: ${category}/${test_name}")
    return()
  endif()

  add_executable(${target_name}
    ${extra_sources}
    $<TARGET_OBJECTS:mpich_main_mtest_f90>
    $<TARGET_OBJECTS:mpich_main_mtest_c>)
  target_compile_options(${target_name} PRIVATE
    ${vapaa_mpich_main_f90_fortran_options}
    ${vapaa_mpich_main_imported_c_options}
    $<$<COMPILE_LANGUAGE:C>:-include>
    $<$<COMPILE_LANGUAGE:C>:${MPICH_MAIN_INCLUDE_ROOT}/vapaa_test_handle_compat.h>)
  target_compile_definitions(${target_name} PRIVATE _GNU_SOURCE)
  target_include_directories(${target_name}
    PRIVATE
      "${SOURCE_DIR}"
      "${CMAKE_BINARY_DIR}/modules"
      "${CMAKE_BINARY_DIR}/tests/mpich_main/f90/modules"
      "${MPICH_MAIN_INCLUDE_ROOT}"
      "${MPICH_MAIN_UTIL_ROOT}"
      "${test_dir}")
  target_link_libraries(${target_name} PRIVATE ${vapa_lib} MPI::MPI_C Threads::Threads)
  set_target_properties(${target_name} PROPERTIES
    LINKER_LANGUAGE Fortran
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/tests/mpich_main/f90/${category}")

  add_test(NAME ${target_name}
    COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} ${np} $<TARGET_FILE:${target_name}>)
  set_tests_properties(${target_name} PROPERTIES
    WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/tests/mpich_main/f90/${category}"
    PASS_REGULAR_EXPRESSION "No Errors")
  if(vapaa_mpich_main_f90_test_environment)
    set_tests_properties(${target_name} PROPERTIES
      ENVIRONMENT "${vapaa_mpich_main_f90_test_environment}")
  endif()
endfunction()

file(STRINGS "${MPICH_MAIN_F90_ROOT}/testlist.in" mpich_main_f90_root_entries)
foreach(entry IN LISTS mpich_main_f90_root_entries)
  string(REGEX REPLACE "#.*$" "" entry "${entry}")
  string(STRIP "${entry}" entry)
  if(entry STREQUAL "")
    continue()
  endif()
  string(REGEX REPLACE "^@[^@]+@" "" category "${entry}")
  string(STRIP "${category}" category)
  if(category STREQUAL "")
    continue()
  endif()
  if(EXISTS "${MPICH_MAIN_F90_ROOT}/${category}")
    list(APPEND mpich_main_f90_categories "${category}")
  else()
    message(STATUS "Skipping MPICH main f90/${category}: upstream main has no f90 directory")
  endif()
endforeach()
list(REMOVE_DUPLICATES mpich_main_f90_categories)

foreach(category IN LISTS mpich_main_f90_categories)
  if(EXISTS "${MPICH_MAIN_F90_ROOT}/${category}/testlist")
    set(testlist "${MPICH_MAIN_F90_ROOT}/${category}/testlist")
  elseif(EXISTS "${MPICH_MAIN_F90_ROOT}/${category}/testlist.in")
    set(testlist "${MPICH_MAIN_F90_ROOT}/${category}/testlist.in")
  elseif(EXISTS "${MPICH_MAIN_F90_ROOT}/${category}/testlist.ap")
    set(testlist "${MPICH_MAIN_F90_ROOT}/${category}/testlist.ap")
  else()
    message(STATUS "No MPICH main f90 testlist for ${category}; imported sources only")
    continue()
  endif()

  file(STRINGS "${testlist}" test_entries)
  foreach(entry IN LISTS test_entries)
    string(REGEX REPLACE "#.*$" "" entry "${entry}")
    string(STRIP "${entry}" entry)
    if(entry STREQUAL "")
      continue()
    endif()
    string(REGEX REPLACE "^@[^@]+@" "" entry "${entry}")
    string(STRIP "${entry}" entry)
    if(entry STREQUAL "")
      continue()
    endif()
    separate_arguments(parts UNIX_COMMAND "${entry}")
    list(LENGTH parts part_count)
    if(part_count LESS 2)
      continue()
    endif()
    list(GET parts 0 test_name)
    list(GET parts 1 np)
    vapaa_add_mpich_main_f90_test("${category}" "${test_name}" "${np}")
  endforeach()
endforeach()
