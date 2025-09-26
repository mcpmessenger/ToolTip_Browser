@echo off
echo 🚀 Building NaviGrab + ChromiumFresh Integration
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
echo 🔧 Step 3: Building the project...
cmake --build . --config Release

if %ERRORLEVEL% neq 0 (
    echo ❌ Build failed!
    pause
    exit /b 1
)

echo.
echo ✅ Build completed successfully!
echo.
echo 📋 Built executables:
echo    - navigrab_integration_demo.exe
echo    - web_automation_demo.exe
echo    - tooltip_automation_demo.exe
echo    - client_side_tooltip_demo.exe
echo    - test_page_automation_demo.exe
echo.

echo 🧪 Step 4: Testing NaviGrab Integration...
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
echo 🎉 All tests passed! NaviGrab + ChromiumFresh integration is working!
echo.
echo 📁 Output directory: %CD%\Release
echo.
echo 🚀 Ready for ChromiumFresh integration!
echo.
pause

