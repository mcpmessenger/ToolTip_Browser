@echo off
echo 🚀 ChromiumFresh + NaviGrab Build (Optional SQLite3)
echo ===================================================

echo.
echo 📁 Current directory: %CD%
echo.

echo 🔍 Checking files...
if exist "CMakeLists.txt" (
    echo ✅ CMakeLists.txt found
) else (
    echo ❌ CMakeLists.txt not found
    exit /b 1
)

if exist "NaviGrab" (
    echo ✅ NaviGrab directory found
) else (
    echo ❌ NaviGrab directory not found
    exit /b 1
)

echo.
echo 🔧 Using optional SQLite3 version...
copy "NaviGrab\CMakeLists_optional_sqlite.txt" "NaviGrab\CMakeLists.txt"
echo ✅ Updated NaviGrab CMakeLists.txt

echo.
echo 🛠️ Building project...
"C:\Program Files\CMake\bin\cmake.exe" -B build -S . -G "Visual Studio 17 2022" -A x64 -DCMAKE_BUILD_TYPE=Release
if %ERRORLEVEL% neq 0 (
    echo ❌ CMake configuration failed
    exit /b 1
)

echo ✅ CMake configuration successful

echo.
echo 🔨 Building NaviGrab components...
"C:\Program Files\CMake\bin\cmake.exe" --build build --target chromium_playwright_core --config Release
if %ERRORLEVEL% neq 0 (
    echo ⚠️ NaviGrab core build had issues
) else (
    echo ✅ NaviGrab core built successfully
)

echo.
echo 🔨 Building examples...
"C:\Program Files\CMake\bin\cmake.exe" --build build --target basic_usage --config Release
"C:\Program Files\CMake\bin\cmake.exe" --build build --target comprehensive_demo --config Release
"C:\Program Files\CMake\bin\cmake.exe" --build build --target screenshot_test_demo --config Release

echo.
echo 🔨 Building integration examples...
"C:\Program Files\CMake\bin\cmake.exe" --build build --target web_automation_demo --config Release
"C:\Program Files\CMake\bin\cmake.exe" --build build --target tooltip_automation_demo --config Release
"C:\Program Files\CMake\bin\cmake.exe" --build build --target unified_api_server --config Release

echo.
echo 🔨 Building tests...
"C:\Program Files\CMake\bin\cmake.exe" --build build --target integration_tests --config Release

echo.
echo 📊 Checking build results...
if exist "build\bin\Release" (
    echo ✅ Build directory found
    echo.
    echo 📄 Built executables:
    dir build\bin\Release\*.exe
) else (
    echo ❌ Build directory not found
)

echo.
echo 🎉 Build completed!
echo.
echo 🚀 Next steps:
echo    1. Run examples: build\bin\Release\web_automation_demo.exe
echo    2. Run tests: build\bin\Release\integration_tests.exe
echo    3. Start API server: build\bin\Release\unified_api_server.exe
echo.
pause

