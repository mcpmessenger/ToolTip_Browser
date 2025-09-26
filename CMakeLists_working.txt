cmake_minimum_required(VERSION 3.20)
set(CMAKE_POLICY_VERSION_MINIMUM 3.5)
project(ChromiumFresh_NaviGrab_Integration VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()

# Set Chromium root directory
set(CHROMIUM_ROOT_DIR "${CMAKE_SOURCE_DIR}/chrome" CACHE PATH "Path to Chromium source directory")

# Check if Chromium directory exists
if(EXISTS "${CHROMIUM_ROOT_DIR}/browser/tooltip/tooltip_service.h")
    message(STATUS "✅ Found real Chromium fork at: ${CHROMIUM_ROOT_DIR}")
    add_compile_definitions(USE_REAL_CHROMIUM=ON)
    set(USE_REAL_CHROMIUM TRUE)
else()
    message(WARNING "⚠️ Chromium fork not found, using mock implementation")
    add_compile_definitions(USE_REAL_CHROMIUM=OFF)
    set(USE_REAL_CHROMIUM FALSE)
endif()

# Also check for the chrome directory
if(EXISTS "${CMAKE_SOURCE_DIR}/chrome/browser/tooltip/tooltip_service.h")
    message(STATUS "✅ Found real Chromium fork at: ${CMAKE_SOURCE_DIR}/chrome")
    add_compile_definitions(USE_REAL_CHROMIUM=ON)
    set(USE_REAL_CHROMIUM TRUE)
    set(CHROMIUM_ROOT_DIR "${CMAKE_SOURCE_DIR}/chrome")
endif()

# Include directories
include_directories(
    ${CMAKE_SOURCE_DIR}/include
    ${CMAKE_SOURCE_DIR}/src
    ${CMAKE_SOURCE_DIR}/src/chromium_integration
    ${CMAKE_SOURCE_DIR}/NaviGrab/include
)

# Third-party dependencies
include(FetchContent)

# Google Test
FetchContent_Declare(
    googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG v1.14.0
)
FetchContent_MakeAvailable(googletest)

# nlohmann/json
FetchContent_Declare(
    nlohmann_json
    GIT_REPOSITORY https://github.com/nlohmann/json.git
    GIT_TAG v3.11.2
)
FetchContent_MakeAvailable(nlohmann_json)

# spdlog for logging
FetchContent_Declare(
    spdlog
    GIT_REPOSITORY https://github.com/gabime/spdlog.git
    GIT_TAG v1.11.0
)
FetchContent_MakeAvailable(spdlog)

# Create NaviGrab library
add_library(navigrab_core
    src/navigrab/navigrab_core.cpp
    src/navigrab/proactive_scraper.cpp
)

# Link NaviGrab libraries
target_link_libraries(navigrab_core
    nlohmann_json::nlohmann_json
    spdlog::spdlog
)

# Create a simple library for integration
add_library(chromium_fresh_unified
    # Client-side only - no API server needed
)

# Link libraries
target_link_libraries(chromium_fresh_unified
    navigrab_core
    nlohmann_json::nlohmann_json
    spdlog::spdlog
)

# Add compile definitions
target_compile_definitions(chromium_fresh_unified
    PRIVATE
        CHROMIUM_FRESH_INTEGRATION=ON
        USE_REAL_CHROMIUM=${USE_REAL_CHROMIUM}
)

# API server removed - client-side only

# Add integration examples
add_executable(web_automation_demo examples/web_automation_demo.cpp)
target_link_libraries(web_automation_demo chromium_fresh_unified)

# Add simple test
add_executable(simple_test simple_test.cpp)
target_link_libraries(simple_test navigrab_core)

# Add minimal test
add_executable(minimal_test minimal_test.cpp)
target_link_libraries(minimal_test navigrab_core)

add_executable(tooltip_automation_demo examples/tooltip_automation_demo.cpp)
target_link_libraries(tooltip_automation_demo chromium_fresh_unified)

# Add real Chromium demo if available
if(USE_REAL_CHROMIUM)
    add_executable(real_chromium_demo examples/real_chromium_demo.cpp)
    target_link_libraries(real_chromium_demo chromium_fresh_unified)
    
    # Include Chromium headers
    target_include_directories(real_chromium_demo PRIVATE
        ${CHROMIUM_ROOT_DIR}
        ${CHROMIUM_ROOT_DIR}/base
        ${CHROMIUM_ROOT_DIR}/content/public
        ${CHROMIUM_ROOT_DIR}/ui
        ${CHROMIUM_ROOT_DIR}/chrome/browser/tooltip
    )
endif()

# Integration tests
enable_testing()
add_executable(chromium_fresh_integration_tests
    tests/integration/chromium_fresh_integration_test.cpp
    tests/integration/navigrab_integration_test.cpp
)

target_link_libraries(chromium_fresh_integration_tests
    chromium_fresh_unified
    gtest_main
    gmock_main
)

add_test(NAME chromium_fresh_integration_tests COMMAND chromium_fresh_integration_tests)

# Set test properties
set_tests_properties(chromium_fresh_integration_tests PROPERTIES
    TIMEOUT 600
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
)

# Install targets
install(TARGETS 
    navigrab_core
    chromium_fresh_unified
    web_automation_demo 
    tooltip_automation_demo
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)

# Install real Chromium demo if available
if(USE_REAL_CHROMIUM)
    install(TARGETS real_chromium_demo
        RUNTIME DESTINATION bin
    )
endif()

# Print configuration summary
message(STATUS "")
message(STATUS "🎯 ChromiumFresh + NaviGrab Integration Configuration:")
message(STATUS "  Version: ${PROJECT_VERSION}")
message(STATUS "  Build Type: ${CMAKE_BUILD_TYPE}")
message(STATUS "  C++ Standard: ${CMAKE_CXX_STANDARD}")
message(STATUS "  Chromium Root: ${CHROMIUM_ROOT_DIR}")
message(STATUS "  Use Real Chromium: ${USE_REAL_CHROMIUM}")
message(STATUS "  Install Prefix: ${CMAKE_INSTALL_PREFIX}")
message(STATUS "")
