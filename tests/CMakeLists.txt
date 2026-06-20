set(TYPECHECK_WARNING_TEST_SOURCE "${CMAKE_CURRENT_SOURCE_DIR}/test_typecheck_warnings.F90")
set(PGIF_DESCRIPTOR_TEST_SOURCE "${CMAKE_CURRENT_SOURCE_DIR}/test_pgif_descriptor.F90")
set(PGIF_DESCRIPTOR_TEST_C_SOURCE "${CMAKE_CURRENT_SOURCE_DIR}/test_pgif_descriptor.c")
set(PGIF_MPI_BYTE_TEST_SOURCE "${CMAKE_CURRENT_SOURCE_DIR}/test_pgif_mpi_byte_noncontig.F90")
set(MPIFH_COVERAGE_TEST_SOURCE "${CMAKE_CURRENT_SOURCE_DIR}/test_mpifh_coverage.f")

set(vapaa_cfi_element_type_warnings_available TRUE)
if(NOT VAPAA_ENABLE_CFI OR CMAKE_Fortran_COMPILER_ID MATCHES "Intel|NVHPC")
  set(vapaa_cfi_element_type_warnings_available FALSE)
endif()

# Find all Fortran files in the current directory
file(GLOB TEST_SOURCES "*.F90")
list(REMOVE_ITEM TEST_SOURCES "${TYPECHECK_WARNING_TEST_SOURCE}")
if(NOT VAPAA_HAVE_PGIF)
  list(REMOVE_ITEM TEST_SOURCES "${PGIF_DESCRIPTOR_TEST_SOURCE}")
  list(REMOVE_ITEM TEST_SOURCES "${PGIF_MPI_BYTE_TEST_SOURCE}")
endif()

# Number of MPI processes
set(MPI_NUM_PROCESSES 4)
set(vapaa_test_environment "")
if(FLAG_MPI MATCHES "OPEN_MPI")
  list(APPEND vapaa_test_environment
    "OMPI_MCA_osc=pt2pt"
    "OMPI_MCA_coll_hcoll_enable=0"
    "OMPI_MCA_coll_ucc_enable=0"
    "OMPI_MCA_hwloc_base_binding_policy=none"
    "UCX_WARN_UNUSED_ENV_VARS=n")
endif()
set(vapaa_test_mpi_library_dirs "")
foreach(mpi_library IN LISTS MPI_C_LIBRARIES)
  if(IS_ABSOLUTE "${mpi_library}")
    get_filename_component(mpi_library_dir "${mpi_library}" DIRECTORY)
    list(APPEND vapaa_test_mpi_library_dirs "${mpi_library_dir}")
  endif()
endforeach()
if(NOT vapaa_test_mpi_library_dirs AND MPI_C_COMPILER)
  execute_process(
    COMMAND "${MPI_C_COMPILER}" -show
    OUTPUT_VARIABLE vapaa_test_mpicc_show
    ERROR_VARIABLE vapaa_test_mpicc_show_error
    RESULT_VARIABLE vapaa_test_mpicc_show_result
    OUTPUT_STRIP_TRAILING_WHITESPACE)
  if(vapaa_test_mpicc_show_result EQUAL 0)
    string(REGEX MATCHALL "(^| )-L[^ ]+" vapaa_test_link_dirs
      "${vapaa_test_mpicc_show}")
    foreach(link_dir IN LISTS vapaa_test_link_dirs)
      string(STRIP "${link_dir}" link_dir)
      string(REGEX REPLACE "^-L" "" link_dir "${link_dir}")
      if(IS_ABSOLUTE "${link_dir}")
        list(APPEND vapaa_test_mpi_library_dirs "${link_dir}")
      endif()
    endforeach()
  endif()
endif()
if(vapaa_test_mpi_library_dirs)
  list(REMOVE_DUPLICATES vapaa_test_mpi_library_dirs)
  string(JOIN ":" vapaa_test_mpi_library_path ${vapaa_test_mpi_library_dirs})
  if(DEFINED ENV{LD_LIBRARY_PATH} AND NOT "$ENV{LD_LIBRARY_PATH}" STREQUAL "")
    set(vapaa_test_mpi_library_path
      "${vapaa_test_mpi_library_path}:$ENV{LD_LIBRARY_PATH}")
  endif()
  list(APPEND vapaa_test_environment "LD_LIBRARY_PATH=${vapaa_test_mpi_library_path}")
endif()

# Iterate over the test files and create executables
foreach(TEST_SOURCE ${TEST_SOURCES})
  # Extract the file name without the extension
  get_filename_component(TEST_NAME ${TEST_SOURCE} NAME_WE)
  
  # Add the executable for this test
  add_executable(${TEST_NAME} ${TEST_SOURCE})
  
  # Link the library to the test
  target_compile_options(${TEST_NAME} PRIVATE
    ${VAPAA_C_WARNING_OPTIONS}
    ${VAPAA_FORTRAN_WARNING_OPTIONS}
    -g
    $<$<COMPILE_LANG_AND_ID:Fortran,GNU>:-std=f2018>
    $<$<BOOL:${VAPAA_ENABLE_CFI}>:-DHAVE_CFI>
    -fPIE)
  target_include_directories(${TEST_NAME}
                             PRIVATE "${CMAKE_BINARY_DIR}/modules" "${SOURCE_DIR}")
  target_link_libraries(${TEST_NAME} PRIVATE ${vapa_lib})
  if(TEST_NAME STREQUAL "test_pgif_descriptor")
    target_sources(${TEST_NAME} PRIVATE "${PGIF_DESCRIPTOR_TEST_C_SOURCE}")
    target_include_directories(${TEST_NAME} PRIVATE "${CMAKE_SOURCE_DIR}/source")
    target_link_libraries(${TEST_NAME} PRIVATE MPI::MPI_C)
  endif()
  
  # Set the output directory for the executables
  set_target_properties(${TEST_NAME} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/tests"
    Fortran_MODULE_DIRECTORY "${CMAKE_BINARY_DIR}/tests/modules/${TEST_NAME}"
  )

    add_test(NAME ${TEST_NAME}
           COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} ${MPI_NUM_PROCESSES} $<TARGET_FILE:${TEST_NAME}>)

  # Optionally set working directory or environment variables for the test
  set(test_properties
    WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/tests"
    PASS_REGULAR_EXPRESSION "Test passed" # Adjust this to match expected output
  )
  if(TEST_NAME STREQUAL "mpich_uallreducef08" AND NOT FLAG_MPI MATCHES "MPI_ABI")
    list(APPEND test_properties WILL_FAIL TRUE)
  endif()
  set_tests_properties(${TEST_NAME} PROPERTIES ${test_properties})
  if(vapaa_test_environment)
    set_property(TEST ${TEST_NAME} PROPERTY ENVIRONMENT "${vapaa_test_environment}")
  endif()
endforeach()

add_executable(test_mpifh_coverage ${MPIFH_COVERAGE_TEST_SOURCE})
target_compile_options(test_mpifh_coverage PRIVATE
  ${VAPAA_FORTRAN_WARNING_OPTIONS}
  -g -fPIE
  $<$<COMPILE_LANG_AND_ID:Fortran,GNU>:-std=legacy>
  $<$<COMPILE_LANG_AND_ID:Fortran,GNU>:-ffixed-line-length-none>
  $<$<COMPILE_LANG_AND_ID:Fortran,GNU>:-fallow-argument-mismatch>
  $<$<COMPILE_LANG_AND_ID:Fortran,GNU>:-Wno-unused-parameter>)
target_include_directories(test_mpifh_coverage PRIVATE "${SOURCE_DIR}")
target_link_libraries(test_mpifh_coverage PRIVATE ${vapa_lib})
set_target_properties(test_mpifh_coverage PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/tests")
add_test(NAME test_mpifh_coverage
         COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 2
                 $<TARGET_FILE:test_mpifh_coverage>)
set_tests_properties(test_mpifh_coverage PROPERTIES
  WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/tests"
  PASS_REGULAR_EXPRESSION "Test passed")
if(vapaa_test_environment)
  set_property(TEST test_mpifh_coverage PROPERTY
    ENVIRONMENT "${vapaa_test_environment}")
endif()

add_test(NAME test_verbose_init
         COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 1
                 $<TARGET_FILE:test_core>)
set(verbose_test_environment "${vapaa_test_environment}")
list(APPEND verbose_test_environment "VAPAA_VERBOSE=1")
set_tests_properties(test_verbose_init PROPERTIES
  WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/tests"
  PASS_REGULAR_EXPRESSION "Vapaa verbose init begin"
  ENVIRONMENT "${verbose_test_environment}"
)

add_executable(test_typecheck_warnings ${TYPECHECK_WARNING_TEST_SOURCE})
target_compile_options(test_typecheck_warnings PRIVATE
  ${VAPAA_C_WARNING_OPTIONS}
  ${VAPAA_FORTRAN_WARNING_OPTIONS}
  -g
  $<$<COMPILE_LANG_AND_ID:Fortran,GNU>:-std=f2018>
  $<$<BOOL:${VAPAA_ENABLE_CFI}>:-DHAVE_CFI>
  -fPIE)
target_include_directories(test_typecheck_warnings
                           PRIVATE "${CMAKE_BINARY_DIR}/modules")
target_link_libraries(test_typecheck_warnings PRIVATE ${vapa_lib})
set_target_properties(test_typecheck_warnings PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/tests"
  Fortran_MODULE_DIRECTORY "${CMAKE_BINARY_DIR}/tests/modules/test_typecheck_warnings"
)

function(vapaa_add_typecheck_warning_test TEST_NAME TEST_MODE WARNING_POLICY)
  add_test(NAME ${TEST_NAME}
           COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 2
                   $<TARGET_FILE:test_typecheck_warnings> ${TEST_MODE})

  set(typecheck_test_properties
    WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/tests"
  )

  set(typecheck_test_environment "${vapaa_test_environment}")
  foreach(extra_env IN LISTS ARGN)
    list(APPEND typecheck_test_environment "${extra_env}")
  endforeach()

  if(WARNING_POLICY STREQUAL "EXPECT_WARNING")
    if(vapaa_cfi_element_type_warnings_available)
      list(APPEND typecheck_test_properties
        PASS_REGULAR_EXPRESSION "CFI element type.*does not match MPI datatype")
    else()
      list(APPEND typecheck_test_properties
        SKIP_REGULAR_EXPRESSION "Test passed")
    endif()
  elseif(WARNING_POLICY STREQUAL "NO_WARNING")
    list(APPEND typecheck_test_properties
      PASS_REGULAR_EXPRESSION "Test passed"
      FAIL_REGULAR_EXPRESSION "CFI element type|does not match MPI datatype")
  else()
    message(FATAL_ERROR "Unknown typecheck warning policy: ${WARNING_POLICY}")
  endif()

  set_tests_properties(${TEST_NAME} PROPERTIES ${typecheck_test_properties})
  if(typecheck_test_environment)
    set_property(TEST ${TEST_NAME} PROPERTY ENVIRONMENT "${typecheck_test_environment}")
  endif()
endfunction()

vapaa_add_typecheck_warning_test(test_typecheck_match_integer
  match_integer NO_WARNING)
vapaa_add_typecheck_warning_test(test_typecheck_warn_byte
  warn_byte EXPECT_WARNING)
vapaa_add_typecheck_warning_test(test_typecheck_disable_byte_warning
  warn_byte NO_WARNING VAPAA_WARN_CFI_DATATYPE_MISMATCH=0)
vapaa_add_typecheck_warning_test(test_typecheck_match_int32
  match_int32 NO_WARNING)
vapaa_add_typecheck_warning_test(test_typecheck_warn_int32_as_int64
  warn_int32_as_int64 EXPECT_WARNING)
vapaa_add_typecheck_warning_test(test_typecheck_match_character
  match_character NO_WARNING)
vapaa_add_typecheck_warning_test(test_typecheck_match_packed
  match_packed NO_WARNING)
vapaa_add_typecheck_warning_test(test_typecheck_match_2integer
  match_2integer NO_WARNING)
vapaa_add_typecheck_warning_test(test_typecheck_user_dtype_default_off
  user_dtype_mismatch NO_WARNING)
vapaa_add_typecheck_warning_test(test_typecheck_user_dtype_warn_enabled
  user_dtype_mismatch EXPECT_WARNING VAPAA_CHECK_CFI_USER_DATATYPE_MISMATCH=1)
vapaa_add_typecheck_warning_test(test_typecheck_user_dtype_match_enabled
  user_dtype_match NO_WARNING VAPAA_CHECK_CFI_USER_DATATYPE_MISMATCH=1)

add_subdirectory(mpich_main)
