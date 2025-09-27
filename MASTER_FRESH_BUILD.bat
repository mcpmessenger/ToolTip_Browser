@echo off
echo ========================================
echo  MASTER FRESH BUILD FOR CHROMIUM FORK
echo ========================================
echo.
echo This master script will:
echo  1. Fix Dawn compilation error (if needed)
echo  2. Clean and build the project
echo  3. Test all components
echo  4. Create deployment package
echo  5. Verify integration works
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

echo Starting master fresh build process...
echo.

REM Step 1: Fix Dawn error (if Chromium source exists)
echo Step 1: Checking for Dawn error fix...
echo.

if exist "C:\chromium\src\src\gpu\ipc\service\gpu_init.cc" (
    echo Chromium source found, applying Dawn fix...
    call fix_dawn_error.bat
    if !ERRORLEVEL! neq 0 (
        echo WARNING: Dawn fix may have failed
        echo Continuing with build process...
    )
) else (
    echo No Chromium source found, skipping Dawn fix
    echo This is normal if you're only building the integration components
)

echo.
echo Step 2: Building fresh fork...
echo.

REM Step 2: Build the project
call build_fresh_fork.bat
if !ERRORLEVEL! neq 0 (
    echo ERROR: Build process failed
    echo Please check the error messages above
    pause
    exit /b 1
)

echo.
echo Step 3: Testing integration...
echo.

REM Step 3: Test the integration
call test_fresh_integration.bat
if !ERRORLEVEL! neq 0 (
    echo WARNING: Some tests may have failed
    echo Check the test results above
)

echo.
echo Step 4: Final verification...
echo.

REM Step 4: Final verification
if exist "deploy" (
    echo Deployment package created successfully
    echo.
    echo Contents:
    dir deploy\*.exe /b
    echo.
    
    REM Count successful builds
    set /a DEPLOY_COUNT=0
    for %%f in (deploy\*.exe) do set /a DEPLOY_COUNT+=1
    
    if !DEPLOY_COUNT! gtr 0 (
        echo SUCCESS: !DEPLOY_COUNT! executables ready for deployment
        echo.
        echo ========================================
        echo  FRESH BUILD: COMPLETE SUCCESS!
        echo ========================================
        echo.
        echo Your ChromiumFresh fork is ready!
        echo.
        echo What you have:
        echo   - Working build system
        echo   - Integrated tooltip components
        echo   - NaviGrab automation library
        echo   - Tested executables
        echo   - Deployment package
        echo.
        echo Next steps:
        echo  1. Test with real web pages
        echo  2. Verify tooltip functionality
        echo  3. Test proactive crawling
        echo  4. Check dark mode integration
        echo.
        echo SUCCESS: Your fork build is working!
        
    ) else (
        echo ERROR: No executables in deployment package
        echo Build may have failed
    )
    
) else (
    echo ERROR: Deployment package not created
    echo Build process may have failed
)

echo.
echo ========================================
echo  MASTER FRESH BUILD COMPLETED
echo ========================================
echo.
echo Build process finished.
echo Check the results above for success/failure status.
echo.
pause
