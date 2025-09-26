@echo off
echo 🧪 Building NaviGrab Test
echo =========================

echo.
echo 🔧 Compiling test...
cl.exe /std:c++20 /I. test_navigrab_simple.cpp /link build\Release\navigrab_core.lib build\_deps\spdlog-build\Release\spdlog.lib /out:test_navigrab.exe

if %ERRORLEVEL% neq 0 (
    echo ❌ Compilation failed!
    pause
    exit /b 1
)

echo.
echo ✅ Test compiled successfully!
echo.
echo 🚀 Running test...
echo ==================
test_navigrab.exe

echo.
echo 🎉 Test completed!
pause
