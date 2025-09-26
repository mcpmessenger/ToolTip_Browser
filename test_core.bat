@echo off
echo 🧪 Testing NaviGrab Core Library
echo ================================

echo.
echo 🔧 Setting up Visual Studio environment...
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"

echo.
echo 🔧 Compiling test...
cl.exe /std:c++20 /I. test_core.cpp /link build\Release\navigrab_core.lib build\_deps\spdlog-build\Release\spdlog.lib /out:test_core.exe

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
test_core.exe

echo.
echo 🎉 Test completed!
pause
