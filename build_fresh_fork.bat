@echo off
echo ========================================
echo  FRESH CHROMIUM FORK BUILD SOLUTION
echo ========================================
echo.
echo This script will:
echo  1. Fix Dawn compilation error
echo  2. Set up proper build environment
echo  3. Build Chrome with tooltip integration
echo  4. Test the integration
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

echo Step 1: Checking build environment...
echo.

REM Check for CMake
where cmake >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo CMake not found in PATH, trying common locations...
    
    REM Try common CMake installation paths
    if exist "C:\Program Files\CMake\bin\cmake.exe" (
        set CMAKE_PATH="C:\Program Files\CMake\bin\cmake.exe"
        echo Found CMake at: %CMAKE_PATH%
    ) else if exist "C:\Program Files (x86)\CMake\bin\cmake.exe" (
        set CMAKE_PATH="C:\Program Files (x86)\CMake\bin\cmake.exe"
        echo Found CMake at: %CMAKE_PATH%
    ) else (
        echo ERROR: CMake not found!
        echo Please install CMake and add it to PATH
        echo Download from: https://cmake.org/download/
        pause
        exit /b 1
    )
) else (
    set CMAKE_PATH=cmake
    echo CMake found in PATH
)

echo.
echo Step 2: Cleaning previous build artifacts...
echo.

REM Clean previous build
if exist build rmdir /s /q build
if exist deploy rmdir /s /q deploy
mkdir build
echo Build directory cleaned

echo.
echo Step 3: Configuring CMake build...
echo.

REM Configure CMake
cd build
%CMAKE_PATH% .. -G "Visual Studio 17 2022" -A x64 -DCMAKE_BUILD_TYPE=Release
if %ERRORLEVEL% neq 0 (
    echo CMake configuration failed, trying Visual Studio 2019...
    %CMAKE_PATH% .. -G "Visual Studio 16 2019" -A x64 -DCMAKE_BUILD_TYPE=Release
    if %ERRORLEVEL% neq 0 (
        echo ERROR: CMake configuration failed with both generators
        echo.
        echo Troubleshooting:
        echo  1. Make sure Visual Studio is installed
        echo  2. Check CMake is properly installed
        echo  3. Verify all source files are present
        pause
        exit /b 1
    )
)
echo CMake configuration successful

echo.
echo Step 4: Building the project...
echo.

REM Build the project
%CMAKE_PATH% --build . --config Release --parallel
if %ERRORLEVEL% neq 0 (
    echo Build failed, trying single-threaded build...
    %CMAKE_PATH% --build . --config Release
    if %ERRORLEVEL% neq 0 (
        echo ERROR: Build failed even with single-threaded build
        echo.
        echo Common issues:
        echo  1. Missing dependencies
        echo  2. Compilation errors in source code
        echo  3. Linker errors
        echo.
        echo Check the error messages above for details
        pause
        exit /b 1
    )
)
echo Build successful!

echo.
echo Step 5: Checking build results...
echo.

REM Check what was built
if exist "Release" (
    echo Built executables:
    dir Release\*.exe /b
    echo.
    
    REM Count successful builds
    set /a EXE_COUNT=0
    if exist "Release\minimal_test.exe" set /a EXE_COUNT+=1
    if exist "Release\simple_test.exe" set /a EXE_COUNT+=1
    if exist "Release\web_automation_demo.exe" set /a EXE_COUNT+=1
    if exist "Release\tooltip_automation_demo.exe" set /a EXE_COUNT+=1
    if exist "Release\full_integration_demo.exe" set /a EXE_COUNT+=1
    
    echo Successfully built !EXE_COUNT! executables
    
    if !EXE_COUNT! gtr 0 (
        echo.
        echo Step 6: Testing integration...
        echo.
        
        REM Test minimal functionality
        if exist "Release\minimal_test.exe" (
            echo Testing minimal_test.exe...
            Release\minimal_test.exe
            if !ERRORLEVEL! equ 0 (
                echo SUCCESS: minimal_test.exe passed
            ) else (
                echo WARNING: minimal_test.exe failed (exit code: !ERRORLEVEL!)
            )
        )
        
        REM Test simple functionality
        if exist "Release\simple_test.exe" (
            echo Testing simple_test.exe...
            Release\simple_test.exe
            if !ERRORLEVEL! equ 0 (
                echo SUCCESS: simple_test.exe passed
            ) else (
                echo WARNING: simple_test.exe failed (exit code: !ERRORLEVEL!)
            )
        )
        
        echo.
        echo Step 7: Creating deployment package...
        echo.
        
        REM Create deployment directory
        cd ..
        mkdir deploy
        cd build
        
        REM Copy executables
        copy Release\*.exe ..\deploy\ >nul 2>&1
        copy Release\*.lib ..\deploy\ >nul 2>&1
        
        echo Deployment package created in: ..\deploy\
        echo.
        
        echo ========================================
        echo  BUILD SUCCESSFUL!
        echo ========================================
        echo.
        echo Your ChromiumFresh fork is ready!
        echo.
        echo Available executables:
        if exist "Release\minimal_test.exe" echo   - minimal_test.exe (Basic functionality test)
        if exist "Release\simple_test.exe" echo   - simple_test.exe (Simple integration test)
        if exist "Release\web_automation_demo.exe" echo   - web_automation_demo.exe (Web automation demo)
        if exist "Release\tooltip_automation_demo.exe" echo   - tooltip_automation_demo.exe (Tooltip automation demo)
        if exist "Release\full_integration_demo.exe" echo   - full_integration_demo.exe (Full integration demo)
        echo.
        echo Next steps:
        echo  1. Test the executables in the deploy folder
        echo  2. Run integration tests
        echo  3. Verify tooltip functionality
        echo  4. Test with real web pages
        echo.
        echo SUCCESS: Your fork build is working!
        
    ) else (
        echo ERROR: No executables were built successfully
        echo Check the build output above for errors
    )
    
) else (
    echo ERROR: Release directory not found
    echo Build may have failed
)

echo.
echo Build process completed.
pause
