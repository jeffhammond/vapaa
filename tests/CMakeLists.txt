# Find all Fortran files in the current directory
file(GLOB TEST_SOURCES "*.F90")

# Number of MPI processes
set(MPI_NUM_PROCESSES 4)

# These tests exercise non-contiguous CFI datatypes (MPIX_Iov) or rely on
# MPICH-specific datatype-handle semantics. Skip them when not building
# against MPICH so CTest reports them as disabled rather than failed.
set(VAPAA_MPICH_ONLY_TESTS
  mpich_uallreducef08
  test_matrix_noncontig_2
  test_serialization_2
  test_user_reduction
)

if(NOT FLAG_MPI STREQUAL "MPICH")
  string(REPLACE ";" ", " _vapaa_skipped_tests "${VAPAA_MPICH_ONLY_TESTS}")
  message(WARNING
    "MPI vendor is not MPICH (FLAG_MPI=${FLAG_MPI}); the following tests "
    "require MPICH MPIX_Iov support and will be marked DISABLED: "
    "${_vapaa_skipped_tests}")
endif()

# Iterate over the test files and create executables
foreach(TEST_SOURCE ${TEST_SOURCES})
  # Extract the file name without the extension
  get_filename_component(TEST_NAME ${TEST_SOURCE} NAME_WE)

  # Add the executable for this test
  add_executable(${TEST_NAME} ${TEST_SOURCE})

  # Link the library to the test
  target_compile_options(${TEST_NAME} PRIVATE -Wall -Wextra -g -std=f2018 -fPIE)
  target_compile_definitions(${TEST_NAME} PRIVATE HAVE_CFI)
  target_link_libraries(${TEST_NAME} PRIVATE ${vapaa_lib})
  # this is because on mac it compiles so fast it can trigger race conditions, wait for 
  # the vapa lib to be built
  add_dependencies(${TEST_NAME} ${vapaa_lib})

  # Set the output directory for the executables
  set_target_properties(${TEST_NAME} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/tests"
  )

    add_test(NAME ${TEST_NAME}
           COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} ${MPI_NUM_PROCESSES} $<TARGET_FILE:${TEST_NAME}>)

  # Optionally set working directory or environment variables for the test
  set_tests_properties(${TEST_NAME} PROPERTIES
    WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/tests"
    PASS_REGULAR_EXPRESSION "Test passed" # Adjust this to match expected output
  )

  if(NOT FLAG_MPI STREQUAL "MPICH" AND TEST_NAME IN_LIST VAPAA_MPICH_ONLY_TESTS)
    set_tests_properties(${TEST_NAME} PROPERTIES
      DISABLED TRUE)
  endif()
endforeach()

