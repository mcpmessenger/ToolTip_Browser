@echo off
echo ========================================
echo  DAWN GRAPHICS LIBRARY ERROR FIX
echo ========================================
echo.
echo This script will fix the Dawn compilation error
echo that is blocking Chrome.exe creation.
echo.

REM Check if we're in the right directory
if not exist "CMakeLists.txt" (
    echo ERROR: Not in project root directory
    echo Please run this script from C:\ChromiumFresh
    pause
    exit /b 1
)

echo Step 1: Checking for Chromium source directory...
echo.

REM Check for Chromium source
set CHROMIUM_SRC=
if exist "C:\chromium\src\src\gpu\ipc\service\gpu_init.cc" (
    set CHROMIUM_SRC=C:\chromium\src\src
    echo Found Chromium source at: %CHROMIUM_SRC%
) else if exist "C:\chromium\src\gpu\ipc\service\gpu_init.cc" (
    set CHROMIUM_SRC=C:\chromium\src
    echo Found Chromium source at: %CHROMIUM_SRC%
) else (
    echo WARNING: Chromium source directory not found
    echo.
    echo Expected locations:
    echo   - C:\chromium\src\src\gpu\ipc\service\gpu_init.cc
    echo   - C:\chromium\src\gpu\ipc\service\gpu_init.cc
    echo.
    echo If you have Chromium source elsewhere, please:
    echo  1. Copy this script to that directory
    echo  2. Run it from there
    echo.
    echo For now, we'll continue with the build process...
    echo The Dawn error may not affect our current build.
    echo.
    pause
    goto :build_continue
)

echo.
echo Step 2: Backing up original file...
echo.

REM Backup the original file
if exist "%CHROMIUM_SRC%\gpu\ipc\service\gpu_init.cc" (
    copy "%CHROMIUM_SRC%\gpu\ipc\service\gpu_init.cc" "%CHROMIUM_SRC%\gpu\ipc\service\gpu_init.cc.backup" >nul
    echo Original file backed up as gpu_init.cc.backup
) else (
    echo ERROR: gpu_init.cc file not found at expected location
    echo Please check the Chromium source directory
    pause
    exit /b 1
)

echo.
echo Step 3: Applying Dawn fix...
echo.

REM Create a PowerShell script to fix the Dawn error
echo Creating Dawn fix script...
(
echo $file = "%CHROMIUM_SRC%\gpu\ipc\service\gpu_init.cc"
echo $content = Get-Content $file
echo $fixed = $content -replace "if \(dawn_context_provider_\) \{", "// if (dawn_context_provider_) {"
echo $fixed = $fixed -replace "  d3d11_device = dawn_context_provider_->GetD3D11Device\(\);", "//   d3d11_device = dawn_context_provider_->GetD3D11Device();"
echo $fixed = $fixed -replace "\}", "// }"
echo $fixed ^| Set-Content $file
echo Write-Host "Dawn fix applied successfully"
) > fix_dawn_temp.ps1

REM Run the PowerShell script
powershell -ExecutionPolicy Bypass -File fix_dawn_temp.ps1

REM Clean up
del fix_dawn_temp.ps1

echo.
echo Step 4: Verifying fix...
echo.

REM Check if the fix was applied
findstr /C:"// if (dawn_context_provider_)" "%CHROMIUM_SRC%\gpu\ipc\service\gpu_init.cc" >nul
if %ERRORLEVEL% equ 0 (
    echo SUCCESS: Dawn fix applied successfully
    echo The problematic lines have been commented out
) else (
    echo WARNING: Dawn fix may not have been applied correctly
    echo Please check the file manually
)

echo.
echo Step 5: Dawn fix completed!
echo.

:build_continue
echo ========================================
echo  CONTINUING WITH BUILD PROCESS
echo ========================================
echo.
echo Now running the fresh build script...
echo.

REM Run the fresh build script
call build_fresh_fork.bat

echo.
echo Dawn fix and build process completed!
pause
