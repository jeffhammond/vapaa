option(VAPAA_ENABLE_PERF_TESTS "Build Vapaa MPI f08 performance microbenchmarks" OFF)

if(NOT VAPAA_ENABLE_PERF_TESTS)
  return()
endif()

set(VAPAA_PERF_SOURCES
  vapaa_perf_f08.F90)

foreach(src ${VAPAA_PERF_SOURCES})
  get_filename_component(test_name "${src}" NAME_WE)
  add_executable(${test_name} "${src}")
  target_include_directories(${test_name}
    PRIVATE
      "${CMAKE_BINARY_DIR}/modules"
      "${MPI_C_HEADER_DIR}")
  target_link_libraries(${test_name} PRIVATE ${vapa_lib} MPI::MPI_C)
  target_compile_definitions(${test_name} PRIVATE VAPAA_PERF_BINDING=\"vapaa\")
  set_target_properties(${test_name} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/perf")
endforeach()
