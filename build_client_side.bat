@echo off
echo 🚀 Building ChromiumFresh Client-Side Integration
echo ================================================

echo.
echo 🔧 Step 1: Cleaning previous build...
if exist build rmdir /s /q build
mkdir build
cd build

echo.
echo 🔧 Step 2: Configuring with CMake...
cmake .. -G "Visual Studio 17 2022" -A x64

if %ERRORLEVEL% neq 0 (
    echo ❌ CMake configuration failed!
    pause
    exit /b 1
)

echo.
echo 🔧 Step 3: Building NaviGrab integration...
cmake --build . --config Release --target navigrab_core

if %ERRORLEVEL% neq 0 (
    echo ❌ NaviGrab core build failed!
    pause
    exit /b 1
)

echo.
echo 🔧 Step 4: Building demos...
cmake --build . --config Release --target navigrab_integration_demo
cmake --build . --config Release --target web_automation_demo
cmake --build . --config Release --target client_side_tooltip_demo

if %ERRORLEVEL% neq 0 (
    echo ❌ Demo build failed!
    pause
    exit /b 1
)

echo.
echo ✅ Build completed successfully!
echo.
echo 📋 Built executables:
echo    - navigrab_integration_demo.exe
echo    - web_automation_demo.exe
echo    - client_side_tooltip_demo.exe
echo.

echo 🧪 Step 5: Testing NaviGrab Integration...
echo.
echo Running NaviGrab Integration Demo...
echo =====================================
.\Release\navigrab_integration_demo.exe

if %ERRORLEVEL% neq 0 (
    echo ❌ Integration test failed!
    pause
    exit /b 1
)

echo.
echo 🎉 All tests passed! Client-side NaviGrab integration is working!
echo.
echo 📁 Output directory: %CD%\Release
echo.
echo 🚀 Ready for ChromiumFresh tooltip integration!
echo.
pause

