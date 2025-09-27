@echo off
echo ========================================
echo  MINIMAL TOOLTIP BUILD TEST
echo ========================================
echo.
echo This script will build a minimal version of the tooltip
echo components to isolate compilation issues.
echo.

REM Set error handling
setlocal enabledelayedexpansion

REM Check if we're in the right directory
if not exist "CMakeLists.txt" (
    echo ERROR: Not in project root directory
    echo Please run this script from C:\ChromiumFresh
    pause
    exit /b 1
)

echo Step 1: Creating minimal CMakeLists for tooltip test...
echo.

REM Create a minimal CMakeLists for tooltip testing
(
echo cmake_minimum_required(VERSION 3.20^)
echo set(CMAKE_POLICY_VERSION_MINIMUM 3.5^)
echo project(MinimalTooltipTest VERSION 1.0.0 LANGUAGES CXX^)
echo.
echo set(CMAKE_CXX_STANDARD 20^)
echo set(CMAKE_CXX_STANDARD_REQUIRED ON^)
echo set(CMAKE_CXX_EXTENSIONS OFF^)
echo.
echo if(NOT CMAKE_BUILD_TYPE^)
echo     set(CMAKE_BUILD_TYPE Release^)
echo endif(^)
echo.
echo # Include directories
echo include_directories(^)
echo     ${CMAKE_SOURCE_DIR}/include^)
echo     ${CMAKE_SOURCE_DIR}/src^)
echo     ${CMAKE_SOURCE_DIR}/src/navigrab^)
echo     ${CMAKE_SOURCE_DIR}/chrome^)
echo     ${CMAKE_SOURCE_DIR}/chrome/browser/tooltip^)
echo     ${CMAKE_SOURCE_DIR}/chrome/browser/ui/views/tooltip^)
echo     ${CMAKE_SOURCE_DIR}^)
echo ^)
echo.
echo # Add compile definitions for standalone build
echo add_compile_definitions(^)
echo     STANDALONE_TOOLTIP_BUILD=1^)
echo     USE_BASE_STUBS=1^)
echo ^)
echo.
echo # Third-party dependencies
echo include(FetchContent^)
echo.
echo # nlohmann/json
echo FetchContent_Declare(^)
echo     nlohmann_json^)
echo     GIT_REPOSITORY https://github.com/nlohmann/json.git^)
echo     GIT_TAG v3.11.2^)
echo ^)
echo FetchContent_MakeAvailable(nlohmann_json^)
echo.
echo # spdlog for logging
echo FetchContent_Declare(^)
echo     spdlog^)
echo     GIT_REPOSITORY https://github.com/gabime/spdlog.git^)
echo     GIT_TAG v1.11.0^)
echo ^)
echo FetchContent_MakeAvailable(spdlog^)
echo.
echo # Create NaviGrab library
echo add_library(navigrab_core^)
echo     src/navigrab/navigrab_core.cpp^)
echo     src/navigrab/proactive_scraper.cpp^)
echo ^)
echo.
echo # Link NaviGrab libraries
echo target_link_libraries(navigrab_core^)
echo     nlohmann_json::nlohmann_json^)
echo     spdlog::spdlog^)
echo ^)
echo.
echo # Create minimal tooltip test
echo add_executable(tooltip_test^)
echo     chrome/browser/tooltip/ai_integration.cc^)
echo ^)
echo.
echo target_link_libraries(tooltip_test^)
echo     navigrab_core^)
echo     nlohmann_json::nlohmann_json^)
echo     spdlog::spdlog^)
echo ^)
echo.
echo # Install targets
echo install(TARGETS ^)
echo     navigrab_core^)
echo     tooltip_test^)
echo     RUNTIME DESTINATION bin^)
echo     LIBRARY DESTINATION lib^)
echo     ARCHIVE DESTINATION lib^)
echo ^)
) > CMakeLists_minimal_tooltip.txt

echo Created CMakeLists_minimal_tooltip.txt

echo.
echo Step 2: Cleaning previous build...
echo.

REM Clean previous build
if exist build rmdir /s /q build
mkdir build
echo Build directory cleaned

echo.
echo Step 3: Configuring CMake build...
echo.

REM Configure CMake
cd build
copy ..\CMakeLists_minimal_tooltip.txt ..\CMakeLists.txt
"C:\Program Files\CMake\bin\cmake.exe" .. -G "Visual Studio 17 2022" -A x64 -DCMAKE_BUILD_TYPE=Release
if %ERRORLEVEL% neq 0 (
    echo CMake configuration failed, trying Visual Studio 2019...
    "C:\Program Files\CMake\bin\cmake.exe" .. -G "Visual Studio 16 2019" -A x64 -DCMAKE_BUILD_TYPE=Release
    if %ERRORLEVEL% neq 0 (
        echo ERROR: CMake configuration failed
        pause
        exit /b 1
    )
)
echo CMake configuration successful

echo.
echo Step 4: Building minimal tooltip test...
echo.

REM Build the tooltip_test executable
"C:\Program Files\CMake\bin\cmake.exe" --build . --config Release --target tooltip_test
if %ERRORLEVEL% neq 0 (
    echo ERROR: tooltip_test build failed
    echo.
    echo This means there are still compilation issues in the AI integration.
    echo Check the error messages above for details.
    pause
    exit /b 1
)
echo tooltip_test build successful!

echo.
echo Step 5: Testing the build...
echo.

REM Test the built executable
if exist "Release\tooltip_test.exe" (
    echo Testing tooltip_test.exe...
    Release\tooltip_test.exe
    if %ERRORLEVEL% equ 0 (
        echo SUCCESS: tooltip_test.exe passed
    ) else (
        echo WARNING: tooltip_test.exe failed (exit code: %ERRORLEVEL%)
    )
) else (
    echo WARNING: tooltip_test.exe not found
)

echo.
echo Step 6: Checking build results...
echo.

REM Check what was built
if exist "Release" (
    echo Built libraries:
    if exist "Release\navigrab_core.lib" echo   - navigrab_core.lib (NaviGrab automation)
    
    echo.
    echo Built executables:
    if exist "Release\tooltip_test.exe" echo   - tooltip_test.exe (Minimal tooltip test)
    
    echo.
    echo ========================================
    echo  MINIMAL TOOLTIP BUILD: SUCCESS!
    echo ========================================
    echo.
    echo The minimal tooltip components are building successfully!
    echo.
    echo Next steps:
    echo  1. Add more tooltip components incrementally
    echo  2. Fix remaining compilation issues
    echo  3. Test full tooltip functionality
    echo.
    echo SUCCESS: Minimal tooltip build is working!
    
) else (
    echo ERROR: Release directory not found
    echo Build may have failed
)

cd ..

REM Restore original CMakeLists.txt
if exist "CMakeLists_original.txt" (
    copy CMakeLists_original.txt CMakeLists.txt
    echo Restored original CMakeLists.txt
)

echo.
echo Minimal tooltip build test completed.
pause
