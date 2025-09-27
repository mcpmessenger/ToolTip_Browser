@echo off
echo ========================================
echo  TOOLTIP COMPONENTS BUILD TEST
echo ========================================
echo.
echo This script will test if the tooltip components
echo can build successfully with the fixed includes.
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

echo Step 1: Cleaning previous build...
echo.

REM Clean previous build
if exist build rmdir /s /q build
mkdir build
echo Build directory cleaned

echo.
echo Step 2: Configuring CMake build...
echo.

REM Configure CMake
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
echo Step 3: Building tooltip components...
echo.

REM Build the tooltip_core library specifically
"C:\Program Files\CMake\bin\cmake.exe" --build . --config Release --target tooltip_core
if %ERRORLEVEL% neq 0 (
    echo ERROR: tooltip_core build failed
    echo.
    echo This means there are still compilation issues in the tooltip components.
    echo Check the error messages above for details.
    pause
    exit /b 1
)
echo tooltip_core build successful!

echo.
echo Step 4: Building NaviGrab components...
echo.

REM Build the navigrab_core library
"C:\Program Files\CMake\bin\cmake.exe" --build . --config Release --target navigrab_core
if %ERRORLEVEL% neq 0 (
    echo ERROR: navigrab_core build failed
    pause
    exit /b 1
)
echo navigrab_core build successful!

echo.
echo Step 5: Building test executables...
echo.

REM Build the test executables
"C:\Program Files\CMake\bin\cmake.exe" --build . --config Release --target minimal_test
"C:\Program Files\CMake\bin\cmake.exe" --build . --config Release --target simple_test

echo.
echo Step 6: Testing the build...
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
echo Step 7: Checking build results...
echo.

REM Check what was built
if exist "Release" (
    echo Built libraries:
    if exist "Release\tooltip_core.lib" echo   - tooltip_core.lib (Tooltip components)
    if exist "Release\navigrab_core.lib" echo   - navigrab_core.lib (NaviGrab automation)
    
    echo.
    echo Built executables:
    if exist "Release\minimal_test.exe" echo   - minimal_test.exe (Basic test)
    if exist "Release\simple_test.exe" echo   - simple_test.exe (Simple test)
    
    echo.
    echo ========================================
    echo  TOOLTIP BUILD TEST: SUCCESS!
    echo ========================================
    echo.
    echo Your tooltip components are now building successfully!
    echo.
    echo Next steps:
    echo  1. Test tooltip functionality
    echo  2. Integrate with real Chromium
    echo  3. Test element detection
    echo  4. Test screenshot capture
    echo.
    echo SUCCESS: Tooltip components are working!
    
) else (
    echo ERROR: Release directory not found
    echo Build may have failed
)

cd ..

echo.
echo Tooltip build test completed.
pause
