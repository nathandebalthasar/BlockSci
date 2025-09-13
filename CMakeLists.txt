cmake_minimum_required(VERSION 3.5)
project(blocksci)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake/")

set(BlockSci_VERSION 0.7.0)

include(GNUInstallDirs)

add_subdirectory(external)

add_subdirectory(src)

# Fix error "ISO C++17 does not allow dynamic exception specifications" with jsonrpccpp lib
add_compile_options(-Wno-deprecated-dynamic-exception-spec -Wno-error=deprecated-dynamic-exception-spec)
add_subdirectory(tools)
add_subdirectory(benchmark)

add_subdirectory(test)
add_subdirectory(example)
