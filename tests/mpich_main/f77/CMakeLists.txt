set(MPICH_MAIN_F77_ROOT "${CMAKE_CURRENT_SOURCE_DIR}")
set(MPICH_MAIN_UTIL_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/../util")
set(MPICH_MAIN_INCLUDE_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/../include")

if(NOT VAPAA_ENABLE_MPIFH_TESTS)
  message(STATUS "Skipping MPICH main f77 tests: VAPAA_ENABLE_MPIFH_TESTS is OFF")
  return()
endif()

find_package(Threads REQUIRED)

set(vapaa_mpich_main_f77_test_environment "")
if(FLAG_MPI MATCHES "OPEN_MPI")
  list(APPEND vapaa_mpich_main_f77_test_environment
    "OMPI_MCA_osc=pt2pt"
    "OMPI_MCA_coll_hcoll_enable=0"
    "OMPI_MCA_coll_ucc_enable=0"
    "OMPI_MCA_hwloc_base_binding_policy=none"
    "UCX_WARN_UNUSED_ENV_VARS=n")
endif()
set(vapaa_mpich_main_f77_mpi_library_dirs
  ${VAPAA_COMPILER_RUNTIME_LIBRARY_DIRS})
foreach(mpi_library IN LISTS MPI_C_LIBRARIES)
  if(IS_ABSOLUTE "${mpi_library}")
    get_filename_component(mpi_library_dir "${mpi_library}" DIRECTORY)
    list(APPEND vapaa_mpich_main_f77_mpi_library_dirs "${mpi_library_dir}")
  endif()
endforeach()
if(NOT vapaa_mpich_main_f77_mpi_library_dirs AND MPI_C_COMPILER)
  execute_process(
    COMMAND "${MPI_C_COMPILER}" -show
    OUTPUT_VARIABLE vapaa_mpich_main_f77_mpicc_show
    ERROR_VARIABLE vapaa_mpich_main_f77_mpicc_show_error
    RESULT_VARIABLE vapaa_mpich_main_f77_mpicc_show_result
    OUTPUT_STRIP_TRAILING_WHITESPACE)
  if(vapaa_mpich_main_f77_mpicc_show_result EQUAL 0)
    string(REGEX MATCHALL "(^| )-L[^ ]+" vapaa_mpich_main_f77_link_dirs
      "${vapaa_mpich_main_f77_mpicc_show}")
    foreach(link_dir IN LISTS vapaa_mpich_main_f77_link_dirs)
      string(STRIP "${link_dir}" link_dir)
      string(REGEX REPLACE "^-L" "" link_dir "${link_dir}")
      if(IS_ABSOLUTE "${link_dir}")
        list(APPEND vapaa_mpich_main_f77_mpi_library_dirs "${link_dir}")
      endif()
    endforeach()
  endif()
endif()
if(vapaa_mpich_main_f77_mpi_library_dirs)
  list(REMOVE_DUPLICATES vapaa_mpich_main_f77_mpi_library_dirs)
  string(JOIN ":" vapaa_mpich_main_f77_mpi_library_path
    ${vapaa_mpich_main_f77_mpi_library_dirs})
  if(DEFINED ENV{LD_LIBRARY_PATH} AND NOT "$ENV{LD_LIBRARY_PATH}" STREQUAL "")
    set(vapaa_mpich_main_f77_mpi_library_path
      "${vapaa_mpich_main_f77_mpi_library_path}:$ENV{LD_LIBRARY_PATH}")
  endif()
  list(APPEND vapaa_mpich_main_f77_test_environment
    "LD_LIBRARY_PATH=${vapaa_mpich_main_f77_mpi_library_path}")
endif()

set(vapaa_mpich_main_f77_fortran_options
  ${vapaa_mpich_main_imported_fortran_options}
  $<$<COMPILE_LANG_AND_ID:Fortran,GNU>:-std=legacy>
  $<$<COMPILE_LANG_AND_ID:Fortran,GNU>:-ffixed-line-length-none>
  $<$<COMPILE_LANG_AND_ID:Fortran,GNU>:-fallow-argument-mismatch>
  $<$<COMPILE_LANG_AND_ID:Fortran,GNU>:-Wno-unused-parameter>)

add_library(mpich_main_mtest_f77 OBJECT
  "${MPICH_MAIN_UTIL_ROOT}/mtest_f77.f")
target_compile_options(mpich_main_mtest_f77 PRIVATE
  ${vapaa_mpich_main_f77_fortran_options})
target_include_directories(mpich_main_mtest_f77
  PRIVATE "${SOURCE_DIR}" "${MPICH_MAIN_INCLUDE_ROOT}")
target_link_libraries(mpich_main_mtest_f77 PRIVATE ${vapa_lib})

function(vapaa_add_mpich_main_f77_test category test_name np)
  set(test_dir "${MPICH_MAIN_F77_ROOT}/${category}")
  set(fortran_source "${test_dir}/${test_name}.f")
  set(c_source "${test_dir}/${test_name}.c")
  set(target_name "mpich_main_f77_${category}_${test_name}")
  set(extra_sources "")
  set(c_main_test FALSE)

  if(category STREQUAL "pt2pt" AND EXISTS "${test_dir}/utilsf.f")
    list(APPEND extra_sources "${test_dir}/utilsf.f")
  endif()
  if(category STREQUAL "pt2pt" AND test_name STREQUAL "greqf")
    list(APPEND extra_sources "${test_dir}/dummyf.f")
  endif()
  if(category STREQUAL "pt2pt" AND test_name STREQUAL "rsendf")
    list(APPEND extra_sources "${test_dir}/bottom_pt2pt.f")
  endif()

  if(category STREQUAL "datatype" AND test_name STREQUAL "bottom")
    list(APPEND extra_sources "${test_dir}/bottomf.f" "${test_dir}/bottomc.c")
  elseif(category STREQUAL "datatype" AND test_name STREQUAL "packef")
    list(APPEND extra_sources "${fortran_source}"
      "${test_dir}/packef_i.f"
      "${test_dir}/packef_r8.f"
      "${test_dir}/packef_c.f")
  elseif(category STREQUAL "ext" AND test_name STREQUAL "c2f2cf")
    list(APPEND extra_sources "${fortran_source}" "${test_dir}/c2f2c.c")
  elseif(category STREQUAL "ext" AND test_name STREQUAL "ctypesinf")
    list(APPEND extra_sources "${fortran_source}" "${test_dir}/ctypesfromc.c")
  elseif(category STREQUAL "ext" AND test_name STREQUAL "c2fmult")
    list(APPEND extra_sources "${c_source}")
    set(c_main_test TRUE)
  elseif(EXISTS "${fortran_source}")
    list(APPEND extra_sources "${fortran_source}")
  elseif(EXISTS "${c_source}")
    list(APPEND extra_sources "${c_source}")
    set(c_main_test TRUE)
  else()
    message(WARNING "Skipping missing MPICH main f77 test source: ${category}/${test_name}")
    return()
  endif()

  add_executable(${target_name}
    ${extra_sources}
    $<TARGET_OBJECTS:mpich_main_mtest_f77>
    $<TARGET_OBJECTS:mpich_main_mtest_c>)
  target_compile_options(${target_name} PRIVATE
    ${vapaa_mpich_main_f77_fortran_options}
    ${vapaa_mpich_main_imported_c_options}
    $<$<COMPILE_LANGUAGE:C>:-include>
    $<$<COMPILE_LANGUAGE:C>:${MPICH_MAIN_INCLUDE_ROOT}/vapaa_test_handle_compat.h>)
  target_compile_definitions(${target_name} PRIVATE
    _GNU_SOURCE F77_NAME_LOWER_USCORE)
  target_include_directories(${target_name}
    PRIVATE
      "${SOURCE_DIR}"
      "${MPICH_MAIN_INCLUDE_ROOT}"
      "${MPICH_MAIN_UTIL_ROOT}"
      "${test_dir}")
  target_link_libraries(${target_name} PRIVATE ${vapa_lib} MPI::MPI_C Threads::Threads)
  if(c_main_test)
    if(CMAKE_Fortran_COMPILER_ID MATCHES "Intel")
      target_link_options(${target_name} PRIVATE -nofor-main)
    elseif(CMAKE_Fortran_COMPILER_ID STREQUAL "NVHPC")
      target_link_options(${target_name} PRIVATE -Mnomain)
    endif()
  endif()
  set_target_properties(${target_name} PROPERTIES
    LINKER_LANGUAGE Fortran
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/tests/mpich_main/f77/${category}")

  add_test(NAME ${target_name}
    COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} ${np} $<TARGET_FILE:${target_name}>)
  set_tests_properties(${target_name} PROPERTIES
    WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/tests/mpich_main/f77/${category}"
    PASS_REGULAR_EXPRESSION "No Errors")
  if(vapaa_mpich_main_f77_test_environment)
    set_tests_properties(${target_name} PROPERTIES
      ENVIRONMENT "${vapaa_mpich_main_f77_test_environment}")
  endif()
  if(category STREQUAL "coll" AND
     test_name STREQUAL "uallreducef" AND
     NOT FLAG_MPI MATCHES "MPI_ABI")
    set_tests_properties(${target_name} PROPERTIES
      WILL_FAIL TRUE)
  endif()
  if(category STREQUAL "info" AND test_name STREQUAL "infocrenvf" AND
     FLAG_MPI MATCHES "OPEN_MPI")
    set_tests_properties(${target_name} PROPERTIES
      WILL_FAIL TRUE)
  endif()
endfunction()

file(STRINGS "${MPICH_MAIN_F77_ROOT}/testlist.in" mpich_main_f77_root_entries)
foreach(entry IN LISTS mpich_main_f77_root_entries)
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
  if(EXISTS "${MPICH_MAIN_F77_ROOT}/${category}")
    list(APPEND mpich_main_f77_categories "${category}")
  else()
    message(STATUS "Skipping MPICH main f77/${category}: upstream main has no f77 directory")
  endif()
endforeach()
list(REMOVE_DUPLICATES mpich_main_f77_categories)

foreach(category IN LISTS mpich_main_f77_categories)
  if(EXISTS "${MPICH_MAIN_F77_ROOT}/${category}/testlist")
    set(testlist "${MPICH_MAIN_F77_ROOT}/${category}/testlist")
  elseif(EXISTS "${MPICH_MAIN_F77_ROOT}/${category}/testlist.in")
    set(testlist "${MPICH_MAIN_F77_ROOT}/${category}/testlist.in")
  else()
    message(STATUS "No MPICH main f77 testlist for ${category}; imported sources only")
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
    vapaa_add_mpich_main_f77_test("${category}" "${test_name}" "${np}")
  endforeach()
endforeach()
