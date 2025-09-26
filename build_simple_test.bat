@echo off
echo 🧪 Building Simple NaviGrab Test
echo ================================

echo.
echo 📦 Compiling simple test...
cl /std:c++20 /I"src\navigrab_simple" test_navigrab_simple.cpp /link "build\Release\navigrab_core.lib" "build\Release\chromium_fresh_unified.lib" /out:test_navigrab_simple.exe

if %ERRORLEVEL% EQU 0 (
    echo ✅ Simple test compiled successfully!
    echo.
    echo 🚀 Running simple test...
    echo ========================
    test_navigrab_simple.exe
) else (
    echo ❌ Compilation failed
    echo.
    echo 💡 Alternative: Use the existing working demos
    echo    - build\Release\web_automation_demo.exe
    echo    - build\Release\unified_api_server.exe
)

pause

