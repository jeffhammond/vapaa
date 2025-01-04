# Find all Fortran files in the current directory
file(GLOB TEST_SOURCES "*.F90")

# Number of MPI processes
set(MPI_NUM_PROCESSES 4)
# Iterate over the test files and create executables
foreach(TEST_SOURCE ${TEST_SOURCES})
  # Extract the file name without the extension
  get_filename_component(TEST_NAME ${TEST_SOURCE} NAME_WE)
  
  # Add the executable for this test
  add_executable(${TEST_NAME} ${TEST_SOURCE})
  
  # Link the library to the test
  target_compile_options(${TEST_NAME} PRIVATE -Wall -Wextra -g -std=f2018 -DHAVE_CFI -fPIE)
target_include_directories(${TEST_NAME}
                           PRIVATE "${CMAKE_BINARY_DIR}/modules")
  target_link_libraries(${TEST_NAME} PRIVATE ${vapa_lib})
  
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
endforeach()

