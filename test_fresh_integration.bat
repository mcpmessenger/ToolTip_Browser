@echo off
echo ========================================
echo  FRESH INTEGRATION TEST SUITE
echo ========================================
echo.
echo This script will test all components of your
echo ChromiumFresh fork integration.
echo.

REM Set error handling
setlocal enabledelayedexpansion

REM Check if we're in the right directory
if not exist "CMakeLists.txt" (
    echo ERROR: Not in project root directory
    echo Please run this script from C:\ChromiumFresh
    pause
    exit /b 1
)

echo Step 1: Checking build artifacts...
echo.

REM Check for build directory
if not exist "build\Release" (
    echo ERROR: Build directory not found
    echo Please run build_fresh_fork.bat first
    pause
    exit /b 1
)

echo Build directory found: build\Release
echo.

REM Check for executables
set /a EXE_COUNT=0
set /a TEST_PASSED=0
set /a TEST_FAILED=0

echo Step 2: Testing individual components...
echo.

REM Test 1: Minimal Test
if exist "build\Release\minimal_test.exe" (
    echo Testing minimal_test.exe...
    echo ----------------------------------------
    build\Release\minimal_test.exe
    if !ERRORLEVEL! equ 0 (
        echo SUCCESS: minimal_test.exe passed
        set /a TEST_PASSED+=1
    ) else (
        echo FAILED: minimal_test.exe failed (exit code: !ERRORLEVEL!)
        set /a TEST_FAILED+=1
    )
    set /a EXE_COUNT+=1
    echo.
) else (
    echo WARNING: minimal_test.exe not found
    echo.
)

REM Test 2: Simple Test
if exist "build\Release\simple_test.exe" (
    echo Testing simple_test.exe...
    echo ----------------------------------------
    build\Release\simple_test.exe
    if !ERRORLEVEL! equ 0 (
        echo SUCCESS: simple_test.exe passed
        set /a TEST_PASSED+=1
    ) else (
        echo FAILED: simple_test.exe failed (exit code: !ERRORLEVEL!)
        set /a TEST_FAILED+=1
    )
    set /a EXE_COUNT+=1
    echo.
) else (
    echo WARNING: simple_test.exe not found
    echo.
)

REM Test 3: Web Automation Demo
if exist "build\Release\web_automation_demo.exe" (
    echo Testing web_automation_demo.exe...
    echo ----------------------------------------
    build\Release\web_automation_demo.exe
    if !ERRORLEVEL! equ 0 (
        echo SUCCESS: web_automation_demo.exe passed
        set /a TEST_PASSED+=1
    ) else (
        echo FAILED: web_automation_demo.exe failed (exit code: !ERRORLEVEL!)
        set /a TEST_FAILED+=1
    )
    set /a EXE_COUNT+=1
    echo.
) else (
    echo WARNING: web_automation_demo.exe not found
    echo.
)

REM Test 4: Tooltip Automation Demo
if exist "build\Release\tooltip_automation_demo.exe" (
    echo Testing tooltip_automation_demo.exe...
    echo ----------------------------------------
    build\Release\tooltip_automation_demo.exe
    if !ERRORLEVEL! equ 0 (
        echo SUCCESS: tooltip_automation_demo.exe passed
        set /a TEST_PASSED+=1
    ) else (
        echo FAILED: tooltip_automation_demo.exe failed (exit code: !ERRORLEVEL!)
        set /a TEST_FAILED+=1
    )
    set /a EXE_COUNT+=1
    echo.
) else (
    echo WARNING: tooltip_automation_demo.exe not found
    echo.
)

REM Test 5: Full Integration Demo
if exist "build\Release\full_integration_demo.exe" (
    echo Testing full_integration_demo.exe...
    echo ----------------------------------------
    build\Release\full_integration_demo.exe
    if !ERRORLEVEL! equ 0 (
        echo SUCCESS: full_integration_demo.exe passed
        set /a TEST_PASSED+=1
    ) else (
        echo FAILED: full_integration_demo.exe failed (exit code: !ERRORLEVEL!)
        set /a TEST_FAILED+=1
    )
    set /a EXE_COUNT+=1
    echo.
) else (
    echo WARNING: full_integration_demo.exe not found
    echo.
)

echo Step 3: Integration test results...
echo.

echo ========================================
echo  TEST RESULTS SUMMARY
echo ========================================
echo.
echo Total executables found: !EXE_COUNT!
echo Tests passed: !TEST_PASSED!
echo Tests failed: !TEST_FAILED!
echo.

if !EXE_COUNT! equ 0 (
    echo ERROR: No executables found for testing
    echo Please run build_fresh_fork.bat first
    echo.
    pause
    exit /b 1
)

REM Calculate success rate
set /a SUCCESS_RATE=0
if !EXE_COUNT! gtr 0 (
    set /a SUCCESS_RATE=(!TEST_PASSED! * 100) / !EXE_COUNT!
)

echo Success rate: !SUCCESS_RATE!%
echo.

if !SUCCESS_RATE! geq 80 (
    echo ========================================
    echo  INTEGRATION TEST: EXCELLENT!
    echo ========================================
    echo.
    echo Your ChromiumFresh fork is working well!
    echo Most components are functioning correctly.
    echo.
    echo Next steps:
    echo  1. Test with real web pages
    echo  2. Verify tooltip functionality
    echo  3. Test NaviGrab automation
    echo  4. Check dark mode integration
    echo.
) else if !SUCCESS_RATE! geq 60 (
    echo ========================================
    echo  INTEGRATION TEST: GOOD
    echo ========================================
    echo.
    echo Your ChromiumFresh fork is mostly working.
    echo Some components may need attention.
    echo.
    echo Recommendations:
    echo  1. Check failed tests above
    echo  2. Review build output for errors
    echo  3. Test individual components
    echo.
) else (
    echo ========================================
    echo  INTEGRATION TEST: NEEDS WORK
    echo ========================================
    echo.
    echo Your ChromiumFresh fork has significant issues.
    echo Please review the failed tests above.
    echo.
    echo Troubleshooting:
    echo  1. Check build errors
    echo  2. Verify all dependencies
    echo  3. Review source code
    echo  4. Run individual tests
    echo.
)

echo Step 4: Checking deployment package...
echo.

if exist "deploy" (
    echo Deployment package found: deploy\
    echo.
    echo Contents:
    dir deploy\*.exe /b
    echo.
    echo You can test the executables in the deploy folder
) else (
    echo WARNING: Deployment package not found
    echo Run build_fresh_fork.bat to create it
)

echo.
echo ========================================
echo  INTEGRATION TEST COMPLETED
echo ========================================
echo.
echo Test summary:
echo   - Executables found: !EXE_COUNT!
echo   - Tests passed: !TEST_PASSED!
echo   - Tests failed: !TEST_FAILED!
echo   - Success rate: !SUCCESS_RATE!%
echo.
echo Your ChromiumFresh fork integration test is complete!
echo.
pause
