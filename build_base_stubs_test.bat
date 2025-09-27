@echo off
echo ========================================
echo  BASE STUBS TEST
echo ========================================
echo.
echo This script will test if the base stubs compile correctly.
echo.

REM Set error handling
setlocal enabledelayedexpansion

echo Step 1: Compiling base stubs test...
echo.

REM Compile the test
cl /EHsc /std:c++20 /I. test_base_stubs.cpp /Fe:test_base_stubs.exe
if %ERRORLEVEL% neq 0 (
    echo ERROR: Compilation failed
    echo Check the error messages above for details.
    pause
    exit /b 1
)
echo Compilation successful!

echo.
echo Step 2: Running base stubs test...
echo.

REM Run the test
test_base_stubs.exe
if %ERRORLEVEL% equ 0 (
    echo SUCCESS: Base stubs test passed!
) else (
    echo WARNING: Base stubs test failed (exit code: %ERRORLEVEL%)
)

echo.
echo Base stubs test completed.
pause
