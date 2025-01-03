
file(GLOB C_files *.c)
file(GLOB FC_files *.F90)
target_sources(${vapa_lib} PRIVATE ${C_files} ${FC_files})
