@echo off
echo 🧪 Testing NaviGrab Integration
echo ===============================

echo.
echo 📁 Current directory: %CD%
echo.

echo 🔍 Checking integration files...
if exist "CMakeLists.txt" (
    echo ✅ CMakeLists.txt found
) else (
    echo ❌ CMakeLists.txt not found
    exit /b 1
)

if exist "NaviGrab\CMakeLists.txt" (
    echo ✅ NaviGrab\CMakeLists.txt found
) else (
    echo ❌ NaviGrab\CMakeLists.txt not found
    exit /b 1
)

if exist "examples\web_automation_demo.cpp" (
    echo ✅ Integration examples found
) else (
    echo ❌ Integration examples not found
    exit /b 1
)

if exist "src\api\unified_api_server.cpp" (
    echo ✅ API server found
) else (
    echo ❌ API server not found
    exit /b 1
)

echo.
echo 🛠️ Testing build...
if exist "build\bin\Release" (
    echo ✅ Build directory exists
    echo.
    echo 📄 Built executables:
    dir build\bin\Release\*.exe
    echo.
    
    echo 🚀 Testing examples...
    if exist "build\bin\Release\web_automation_demo.exe" (
        echo ✅ Web automation demo found
        echo Running web automation demo...
        build\bin\Release\web_automation_demo.exe
    ) else (
        echo ❌ Web automation demo not found
    )
    
    echo.
    if exist "build\bin\Release\tooltip_automation_demo.exe" (
        echo ✅ Tooltip automation demo found
        echo Running tooltip automation demo...
        build\bin\Release\tooltip_automation_demo.exe
    ) else (
        echo ❌ Tooltip automation demo not found
    )
    
    echo.
    if exist "build\bin\Release\integration_tests.exe" (
        echo ✅ Integration tests found
        echo Running integration tests...
        build\bin\Release\integration_tests.exe
    ) else (
        echo ❌ Integration tests not found
    )
    
) else (
    echo ❌ Build directory not found
    echo Please run build_and_test.bat first
)

echo.
echo 🎉 Integration test completed!
echo.
pause

