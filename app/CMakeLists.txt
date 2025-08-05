add_executable(demo_test demo_test.cpp)

target_link_library(demo_test 
        PRIVATE
        gtest
        gtest_main
        android
        log
)

set_target_properties(demo_test PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
