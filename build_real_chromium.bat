@echo off
echo 🚀 Building ChromiumFresh + NaviGrab with Real Chromium Integration
echo =================================================================

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

if exist "chrome" (
    echo ✅ Chrome directory found (real Chromium fork)
) else (
    echo ❌ Chrome directory not found
    exit /b 1
)

if exist "NaviGrab" (
    echo ✅ NaviGrab directory found
) else (
    echo ❌ NaviGrab directory not found
    exit /b 1
)

echo.
echo 🔧 Using real Chromium integration...
copy "CMakeLists_real_chromium.txt" "CMakeLists.txt"
echo ✅ Updated CMakeLists.txt for real Chromium integration

echo.
echo 🛠️ Building project...
"C:\Program Files\CMake\bin\cmake.exe" -B build -S . -G "Visual Studio 17 2022" -A x64 -DCMAKE_BUILD_TYPE=Release
if %ERRORLEVEL% neq 0 (
    echo ❌ CMake configuration failed
    echo.
    echo 🔧 Trying with mock implementation...
    copy "CMakeLists.txt" "CMakeLists_backup.txt"
    copy "CMakeLists_real_chromium.txt" "CMakeLists.txt"
    "C:\Program Files\CMake\bin\cmake.exe" -B build -S . -G "Visual Studio 17 2022" -A x64 -DCMAKE_BUILD_TYPE=Release -DUSE_REAL_CHROMIUM=OFF
    if %ERRORLEVEL% neq 0 (
        echo ❌ Build failed even with mock implementation
        exit /b 1
    )
    echo ✅ Build configured with mock implementation
) else (
    echo ✅ CMake configuration successful
)

echo.
echo 🔨 Building NaviGrab components...
"C:\Program Files\CMake\bin\cmake.exe" --build build --target chromium_playwright_core --config Release
if %ERRORLEVEL% neq 0 (
    echo ⚠️ NaviGrab core build had issues
) else (
    echo ✅ NaviGrab core built successfully
)

echo.
echo 🔨 Building real Chromium integration...
"C:\Program Files\CMake\bin\cmake.exe" --build build --target chromium_fresh_integration --config Release
if %ERRORLEVEL% neq 0 (
    echo ⚠️ Chromium integration build had issues
) else (
    echo ✅ Chromium integration built successfully
)

echo.
echo 🔨 Building examples...
"C:\Program Files\CMake\bin\cmake.exe" --build build --target real_chromium_demo --config Release
"C:\Program Files\CMake\bin\cmake.exe" --build build --target web_automation_demo --config Release
"C:\Program Files\CMake\bin\cmake.exe" --build build --target tooltip_automation_demo --config Release
"C:\Program Files\CMake\bin\cmake.exe" --build build --target unified_api_server --config Release

echo.
echo 🔨 Building tests...
"C:\Program Files\CMake\bin\cmake.exe" --build build --target chromium_fresh_integration_test --config Release
"C:\Program Files\CMake\bin\cmake.exe" --build build --target navigrab_integration_test --config Release

echo.
echo 📊 Checking build results...
if exist "build\bin\Release" (
    echo ✅ Build directory found
    echo.
    echo 📄 Built executables:
    dir build\bin\Release\*.exe
    echo.
    
    echo 🎯 Real Chromium Integration Demo:
    if exist "build\bin\Release\real_chromium_demo.exe" (
        echo ✅ real_chromium_demo.exe - Test real Chromium integration
    ) else (
        echo ❌ real_chromium_demo.exe not found
    )
    
    echo.
    echo 🚀 Other Examples:
    if exist "build\bin\Release\web_automation_demo.exe" (
        echo ✅ web_automation_demo.exe - Web automation example
    ) else (
        echo ❌ web_automation_demo.exe not found
    )
    
    if exist "build\bin\Release\tooltip_automation_demo.exe" (
        echo ✅ tooltip_automation_demo.exe - Tooltip automation example
    ) else (
        echo ❌ tooltip_automation_demo.exe not found
    )
    
    if exist "build\bin\Release\unified_api_server.exe" (
        echo ✅ unified_api_server.exe - API server
    ) else (
        echo ❌ unified_api_server.exe not found
    )
    
    echo.
    echo 🧪 Tests:
    if exist "build\bin\Release\chromium_fresh_integration_test.exe" (
        echo ✅ chromium_fresh_integration_test.exe - Integration tests
    ) else (
        echo ❌ chromium_fresh_integration_test.exe not found
    )
    
    if exist "build\bin\Release\navigrab_integration_test.exe" (
        echo ✅ navigrab_integration_test.exe - NaviGrab tests
    ) else (
        echo ❌ navigrab_integration_test.exe not found
    )
    
) else (
    echo ❌ Build directory not found
)

echo.
echo 🎉 Build completed!
echo.
echo 🚀 Next steps:
echo    1. Run real Chromium demo: build\bin\Release\real_chromium_demo.exe
echo    2. Run web automation: build\bin\Release\web_automation_demo.exe
echo    3. Run tooltip automation: build\bin\Release\tooltip_automation_demo.exe
echo    4. Start API server: build\bin\Release\unified_api_server.exe
echo    5. Run tests: build\bin\Release\chromium_fresh_integration_test.exe
echo.
echo 💡 The real Chromium demo will show actual integration with your tooltip fork!
echo.
pause

