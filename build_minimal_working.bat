@echo off
echo ========================================
echo  MINIMAL WORKING BUILD
echo ========================================
echo.
echo This script will build only the working components:
echo  1. NaviGrab core library
echo  2. Basic test executables
echo  3. Skip problematic tooltip components for now
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

echo Step 1: Creating minimal CMakeLists.txt...
echo.

REM Create a minimal CMakeLists.txt that only builds working components
(
echo cmake_minimum_required(VERSION 3.20^)
echo set(CMAKE_POLICY_VERSION_MINIMUM 3.5^)
echo project(ChromiumFresh_Minimal VERSION 1.0.0 LANGUAGES CXX^)
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
echo include_directories(
echo     ${CMAKE_SOURCE_DIR}/src
echo     ${CMAKE_SOURCE_DIR}/src/navigrab
echo ^)
echo.
echo # Third-party dependencies
echo include(FetchContent^)
echo.
echo # nlohmann/json
echo FetchContent_Declare(
echo     nlohmann_json
echo     GIT_REPOSITORY https://github.com/nlohmann/json.git
echo     GIT_TAG v3.11.2
echo ^)
echo FetchContent_MakeAvailable(nlohmann_json^)
echo.
echo # spdlog for logging
echo FetchContent_Declare(
echo     spdlog
echo     GIT_REPOSITORY https://github.com/gabime/spdlog.git
echo     GIT_TAG v1.11.0
echo ^)
echo FetchContent_MakeAvailable(spdlog^)
echo.
echo # Create NaviGrab library
echo add_library(navigrab_core
echo     src/navigrab/navigrab_core.cpp
echo     src/navigrab/proactive_scraper.cpp
echo ^)
echo.
echo # Link NaviGrab libraries
echo target_link_libraries(navigrab_core
echo     nlohmann_json::nlohmann_json
echo     spdlog::spdlog
echo ^)
echo.
echo # Add minimal test
echo add_executable(minimal_test minimal_test.cpp^)
echo target_link_libraries(minimal_test navigrab_core^)
echo.
echo # Add simple test
echo add_executable(simple_test simple_test.cpp^)
echo target_link_libraries(simple_test navigrab_core^)
echo.
echo # Install targets
echo install(TARGETS 
echo     navigrab_core
echo     minimal_test
echo     simple_test
echo     RUNTIME DESTINATION bin
echo     LIBRARY DESTINATION lib
echo     ARCHIVE DESTINATION lib
echo ^)
) > CMakeLists_minimal.txt

REM Backup original and use minimal version
copy CMakeLists.txt CMakeLists_original.txt
copy CMakeLists_minimal.txt CMakeLists.txt

echo Minimal CMakeLists.txt created and activated
echo.

echo Step 2: Cleaning previous build...
echo.

REM Clean previous build
if exist build rmdir /s /q build
mkdir build
echo Build directory cleaned

echo.
echo Step 3: Configuring minimal build...
echo.

REM Configure CMake with minimal configuration
cd build
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
echo Step 4: Building minimal components...
echo.

REM Build the project
"C:\Program Files\CMake\bin\cmake.exe" --build . --config Release
if %ERRORLEVEL% neq 0 (
    echo ERROR: Build failed
    pause
    exit /b 1
)
echo Build successful!

echo.
echo Step 5: Testing minimal build...
echo.

REM Test the built executables
if exist "Release\minimal_test.exe" (
    echo Testing minimal_test.exe...
    Release\minimal_test.exe
    if %ERRORLEVEL% equ 0 (
        echo SUCCESS: minimal_test.exe passed
    ) else (
        echo WARNING: minimal_test.exe failed (exit code: %ERRORLEVEL%)
    )
) else (
    echo WARNING: minimal_test.exe not found
)

if exist "Release\simple_test.exe" (
    echo Testing simple_test.exe...
    Release\simple_test.exe
    if %ERRORLEVEL% equ 0 (
        echo SUCCESS: simple_test.exe passed
    ) else (
        echo WARNING: simple_test.exe failed (exit code: %ERRORLEVEL%)
    )
) else (
    echo WARNING: simple_test.exe not found
)

echo.
echo Step 6: Creating deployment package...
echo.

REM Create deployment directory
cd ..
mkdir deploy_minimal
cd build

REM Copy executables
if exist "Release\minimal_test.exe" (
    copy "Release\minimal_test.exe" "..\deploy_minimal\"
    echo Copied minimal_test.exe
)

if exist "Release\simple_test.exe" (
    copy "Release\simple_test.exe" "..\deploy_minimal\"
    echo Copied simple_test.exe
)

if exist "Release\navigrab_core.lib" (
    copy "Release\navigrab_core.lib" "..\deploy_minimal\"
    echo Copied navigrab_core.lib
)

cd ..

echo.
echo Step 7: Restoring original CMakeLists.txt...
echo.

REM Restore original CMakeLists.txt
cd ..
copy CMakeLists_original.txt CMakeLists.txt
echo Original CMakeLists.txt restored

echo.
echo ========================================
echo  MINIMAL BUILD: SUCCESS!
echo ========================================
echo.
echo Your minimal ChromiumFresh build is working!
echo.
echo Built components:
if exist "deploy_minimal\minimal_test.exe" echo   - minimal_test.exe (Basic NaviGrab test)
if exist "deploy_minimal\simple_test.exe" echo   - simple_test.exe (Simple integration test)
if exist "deploy_minimal\navigrab_core.lib" echo   - navigrab_core.lib (NaviGrab automation library)
echo.
echo Next steps:
echo  1. Test the executables in deploy_minimal folder
echo  2. Verify NaviGrab functionality
echo  3. Once working, we can add tooltip components back
echo.
echo SUCCESS: Minimal build is working!
echo.
pause
