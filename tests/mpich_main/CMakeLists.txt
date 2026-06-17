set(MPICH_MAIN_F08_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/f08")
set(MPICH_MAIN_UTIL_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/util")
set(MPICH_MAIN_INCLUDE_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/include")

find_package(Threads REQUIRED)

set(vapaa_mpich_main_test_environment "")
if(FLAG_MPI STREQUAL "OPEN_MPI")
  list(APPEND vapaa_mpich_main_test_environment "OMPI_MCA_osc=pt2pt")
endif()

add_library(mpich_main_mtest_f08 OBJECT
  "${MPICH_MAIN_UTIL_ROOT}/mtest_f08.f90")
target_compile_options(mpich_main_mtest_f08 PRIVATE -Wall -Wextra -g -std=f2018 -fPIE)
target_include_directories(mpich_main_mtest_f08
  PRIVATE "${CMAKE_BINARY_DIR}/modules" "${MPICH_MAIN_INCLUDE_ROOT}")
target_link_libraries(mpich_main_mtest_f08 PRIVATE ${vapa_lib})
set_target_properties(mpich_main_mtest_f08 PROPERTIES
  Fortran_MODULE_DIRECTORY "${CMAKE_BINARY_DIR}/tests/mpich_main/modules")

add_library(mpich_main_mtest_c OBJECT
  "${MPICH_MAIN_UTIL_ROOT}/mtest.c"
  "${MPICH_MAIN_UTIL_ROOT}/mtest_common.c"
  "${MPICH_MAIN_UTIL_ROOT}/mtest_thread.c")
target_compile_options(mpich_main_mtest_c PRIVATE -Wall -Wextra -g -fPIE)
target_compile_definitions(mpich_main_mtest_c PRIVATE _GNU_SOURCE)
target_include_directories(mpich_main_mtest_c
  PRIVATE "${MPICH_MAIN_INCLUDE_ROOT}" "${MPICH_MAIN_UTIL_ROOT}")
target_link_libraries(mpich_main_mtest_c PRIVATE MPI::MPI_C Threads::Threads)

function(vapaa_add_mpich_main_f08_test category test_name np)
  set(test_dir "${MPICH_MAIN_F08_ROOT}/${category}")
  set(f90_source "${test_dir}/${test_name}.f90")
  set(c_source "${test_dir}/${test_name}.c")
  set(target_name "mpich_main_f08_${category}_${test_name}")
  set(extra_sources "")
  set(c_main_test FALSE)

  if(category STREQUAL "info" AND test_name STREQUAL "infocrenvf90")
    message(STATUS "Skipping MPICH main f08/info/infocrenvf90: it includes mpif.h, which Vapaa does not provide")
    return()
  endif()
  if(category STREQUAL "misc" AND test_name STREQUAL "statusconv" AND NOT FLAG_MPI STREQUAL "MPICH")
    message(STATUS "Skipping MPICH main f08/misc/statusconv: its C helper uses MPICH's MPI_F08_status type")
    return()
  endif()

  if(category STREQUAL "pt2pt" AND EXISTS "${test_dir}/utilsf08.f90")
    list(APPEND extra_sources "${test_dir}/utilsf08.f90")
  endif()
  if(category STREQUAL "pt2pt" AND test_name STREQUAL "greqf08")
    list(APPEND extra_sources "${test_dir}/dummyf08.f90")
  endif()
  if(category STREQUAL "attr" AND test_name STREQUAL "attrlangf08")
    list(APPEND extra_sources "${test_dir}/attrlangc.c")
  endif()
  if(category STREQUAL "attr" AND test_name STREQUAL "fandcattrf08")
    list(APPEND extra_sources "${test_dir}/fandcattrc.c")
  endif()
  if(category STREQUAL "ext" AND test_name STREQUAL "c2f2cf90")
    list(APPEND extra_sources "${f90_source}" "${test_dir}/c2f902c.c")
  elseif(category STREQUAL "ext" AND test_name STREQUAL "ctypesinf90")
    list(APPEND extra_sources "${f90_source}" "${test_dir}/ctypesfromc.c")
  elseif(category STREQUAL "ext" AND test_name STREQUAL "c2f90mult")
    list(APPEND extra_sources "${c_source}")
    set(c_main_test TRUE)
  elseif(category STREQUAL "io" AND test_name STREQUAL "c2f90multio")
    list(APPEND extra_sources "${c_source}")
    set(c_main_test TRUE)
  elseif(category STREQUAL "misc" AND test_name STREQUAL "statusconv")
    list(APPEND extra_sources "${test_dir}/statusconvf08.f90" "${test_dir}/statusconv.c")
  elseif(category STREQUAL "io" AND test_name STREQUAL "c2f2ciof90")
    list(APPEND extra_sources "${f90_source}" "${test_dir}/c2f902cio.c")
  elseif(category STREQUAL "rma" AND test_name STREQUAL "c2f2cwinf08")
    list(APPEND extra_sources "${f90_source}" "${test_dir}/c2f902cwin.c")
  elseif(EXISTS "${f90_source}")
    list(APPEND extra_sources "${f90_source}")
  elseif(EXISTS "${c_source}")
    list(APPEND extra_sources "${c_source}")
  else()
    message(WARNING "Skipping missing MPICH main f08 test source: ${category}/${test_name}")
    return()
  endif()

  add_executable(${target_name}
    ${extra_sources}
    $<TARGET_OBJECTS:mpich_main_mtest_f08>
    $<TARGET_OBJECTS:mpich_main_mtest_c>)
  target_compile_options(${target_name} PRIVATE
    -Wall -Wextra -g -fPIE
    $<$<COMPILE_LANGUAGE:C>:-include>
    $<$<COMPILE_LANGUAGE:C>:${MPICH_MAIN_INCLUDE_ROOT}/vapaa_test_handle_compat.h>)
  target_compile_definitions(${target_name} PRIVATE _GNU_SOURCE)
  target_include_directories(${target_name}
    PRIVATE
      "${SOURCE_DIR}"
      "${CMAKE_BINARY_DIR}/modules"
      "${CMAKE_BINARY_DIR}/tests/mpich_main/modules"
      "${MPICH_MAIN_INCLUDE_ROOT}"
      "${MPICH_MAIN_UTIL_ROOT}"
      "${test_dir}")
  target_link_libraries(${target_name} PRIVATE ${vapa_lib} MPI::MPI_C Threads::Threads)
  if(c_main_test AND CMAKE_Fortran_COMPILER_ID MATCHES "Intel")
    target_link_options(${target_name} PRIVATE -nofor-main)
  endif()
  set_target_properties(${target_name} PROPERTIES
    LINKER_LANGUAGE Fortran
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/tests/mpich_main/${category}")

  add_test(NAME ${target_name}
    COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} ${np} $<TARGET_FILE:${target_name}>)
  set_tests_properties(${target_name} PROPERTIES
    WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/tests/mpich_main/${category}"
    PASS_REGULAR_EXPRESSION "No Errors")
  if(vapaa_mpich_main_test_environment)
    set_tests_properties(${target_name} PROPERTIES
      ENVIRONMENT "${vapaa_mpich_main_test_environment}")
  endif()
  if(category STREQUAL "io")
    set_tests_properties(${target_name} PROPERTIES
      RESOURCE_LOCK mpich_main_f08_io_files)
  endif()
  if(category STREQUAL "coll" AND
     (test_name STREQUAL "uallreducef08" OR test_name STREQUAL "reducelocalf08") AND
     NOT FLAG_MPI STREQUAL "MPI_ABI")
    set_tests_properties(${target_name} PROPERTIES
      WILL_FAIL TRUE)
  endif()
  if(category STREQUAL "io" AND test_name STREQUAL "atomicityf90" AND FLAG_MPI STREQUAL "OPEN_MPI")
    set_tests_properties(${target_name} PROPERTIES
      WILL_FAIL TRUE)
  endif()
endfunction()

set(mpich_main_f08_categories
  attr
  pt2pt
  coll
  datatype
  comm
  rma
  subarray
  topo
  ext
  info
  init
  io
  misc
  timer
  profile)

foreach(category IN LISTS mpich_main_f08_categories)
  if(EXISTS "${MPICH_MAIN_F08_ROOT}/${category}/testlist")
    set(testlist "${MPICH_MAIN_F08_ROOT}/${category}/testlist")
  elseif(EXISTS "${MPICH_MAIN_F08_ROOT}/${category}/testlist.in")
    set(testlist "${MPICH_MAIN_F08_ROOT}/${category}/testlist.in")
  else()
    message(WARNING "No MPICH main f08 testlist for ${category}")
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
    vapaa_add_mpich_main_f08_test("${category}" "${test_name}" "${np}")
  endforeach()
endforeach()
