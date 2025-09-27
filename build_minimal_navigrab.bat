@echo off
echo ========================================
echo  MINIMAL NAVIGRAB BUILD TEST
echo ========================================
echo.
echo This script will build only NaviGrab components
echo to verify the build system is working.
echo.

echo Step 1: Cleaning previous build...
if exist build rmdir /s /q build
echo Build directory cleaned
echo.

echo Step 2: Configuring CMake build...
copy CMakeLists_minimal_navigrab.txt CMakeLists.txt
if errorlevel 1 (
    echo ERROR: Failed to copy CMakeLists file
    pause
    exit /b 1
)

mkdir build
cd build

"C:\Program Files\CMake\bin\cmake.exe" ..
if errorlevel 1 (
    echo ERROR: CMake configuration failed
    cd ..
    pause
    exit /b 1
)

echo CMake configuration successful!
echo.

echo Step 3: Building project...
"C:\Program Files\CMake\bin\cmake.exe" --build . --config Release
if errorlevel 1 (
    echo ERROR: Build failed
    cd ..
    pause
    exit /b 1
)

echo.
echo ========================================
echo  BUILD SUCCESSFUL!
echo ========================================
echo.
echo NaviGrab core library built successfully.
echo Build system is working correctly.
echo.
echo Next steps:
echo 1. Test the minimal_navigrab_test.exe
echo 2. Add tooltip components incrementally
echo 3. Fix remaining compilation issues
echo.

cd ..
echo Press any key to continue...
pause >nul
