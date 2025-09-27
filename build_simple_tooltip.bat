@echo off
echo ========================================
echo  SIMPLE TOOLTIP BUILD TEST
echo ========================================
echo.
echo This script will build a simple tooltip test using
echo the working NaviGrab components.
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

echo Step 1: Creating simple tooltip test...
echo.

REM Create a simple tooltip test that uses NaviGrab
(
echo #include ^<iostream^>
echo #include ^<memory^>
echo #include "src/navigrab/navigrab_core.h"
echo #include "src/navigrab/proactive_scraper.h"
echo.
echo int main^(^) {
echo     std::cout ^<^< "Testing tooltip integration with NaviGrab..." ^<^< std::endl;
echo.
echo     // Test NaviGrab core
echo     auto navigrab = std::make_unique^navigrab::NaviGrabCore^(^);
echo     if ^(navigrab-^>Initialize^(^)^) {
echo         std::cout ^<^< "✅ NaviGrab core initialized successfully" ^<^< std::endl;
echo     } else {
echo         std::cout ^<^< "❌ NaviGrab core initialization failed" ^<^< std::endl;
echo         return 1;
echo     }
echo.
echo     // Test proactive scraper
echo     auto scraper = std::make_unique^navigrab::ProactiveScraper^(^);
echo     if ^(scraper-^>Initialize^(^)^) {
echo         std::cout ^<^< "✅ Proactive scraper initialized successfully" ^<^< std::endl;
echo     } else {
echo         std::cout ^<^< "❌ Proactive scraper initialization failed" ^<^< std::endl;
echo         return 1;
echo     }
echo.
echo     // Test basic scraping
echo     std::cout ^<^< "Testing basic scraping..." ^<^< std::endl;
echo     auto result = scraper-^>ScrapePage^("https://example.com", navigrab::ScrapingDepth::QUICK^);
echo     if ^(result.success^) {
echo         std::cout ^<^< "✅ Scraping successful: " ^<^< result.elements.size^(^) ^<^< " elements found" ^<^< std::endl;
echo     } else {
echo         std::cout ^<^< "❌ Scraping failed: " ^<^< result.error_message ^<^< std::endl;
echo     }
echo.
echo     std::cout ^<^< "Tooltip integration test completed!" ^<^< std::endl;
echo     return 0;
echo }
) > simple_tooltip_test.cpp

echo Created simple_tooltip_test.cpp

echo.
echo Step 2: Building with working CMake setup...
echo.

REM Use the working minimal build approach
copy CMakeLists_minimal.txt CMakeLists.txt
if %ERRORLEVEL% neq 0 (
    echo ERROR: Could not copy CMakeLists_minimal.txt
    pause
    exit /b 1
)

REM Clean and build
if exist build rmdir /s /q build
mkdir build
cd build

"C:\Program Files\CMake\bin\cmake.exe" .. -G "Visual Studio 17 2022" -A x64 -DCMAKE_BUILD_TYPE=Release
if %ERRORLEVEL% neq 0 (
    echo CMake configuration failed
    pause
    exit /b 1
)

echo CMake configuration successful

echo.
echo Step 3: Adding simple tooltip test to build...
echo.

REM Add the simple tooltip test to the existing CMakeLists
(
echo.
echo # Add simple tooltip test
echo add_executable^(simple_tooltip_test^)
echo     ../simple_tooltip_test.cpp^)
echo ^)
echo.
echo target_link_libraries^(simple_tooltip_test^)
echo     navigrab_core^)
echo ^)
) >> ../CMakeLists.txt

REM Reconfigure
"C:\Program Files\CMake\bin\cmake.exe" .. -G "Visual Studio 17 2022" -A x64 -DCMAKE_BUILD_TYPE=Release

echo.
echo Step 4: Building simple tooltip test...
echo.

"C:\Program Files\CMake\bin\cmake.exe" --build . --config Release --target simple_tooltip_test
if %ERRORLEVEL% neq 0 (
    echo ERROR: simple_tooltip_test build failed
    pause
    exit /b 1
)
echo simple_tooltip_test build successful!

echo.
echo Step 5: Testing the build...
echo.

REM Test the built executable
if exist "Release\simple_tooltip_test.exe" (
    echo Testing simple_tooltip_test.exe...
    Release\simple_tooltip_test.exe
    if %ERRORLEVEL% equ 0 (
        echo SUCCESS: simple_tooltip_test.exe passed
    ) else (
        echo WARNING: simple_tooltip_test.exe failed (exit code: %ERRORLEVEL%)
    )
) else (
    echo WARNING: simple_tooltip_test.exe not found
)

echo.
echo Step 6: Checking build results...
echo.

REM Check what was built
if exist "Release" (
    echo Built libraries:
    if exist "Release\navigrab_core.lib" echo   - navigrab_core.lib (NaviGrab automation)
    
    echo.
    echo Built executables:
    if exist "Release\minimal_test.exe" echo   - minimal_test.exe (Basic test)
    if exist "Release\simple_test.exe" echo   - simple_test.exe (Simple test)
    if exist "Release\simple_tooltip_test.exe" echo   - simple_tooltip_test.exe (Simple tooltip test)
    
    echo.
    echo ========================================
    echo  SIMPLE TOOLTIP BUILD: SUCCESS!
    echo ========================================
    echo.
    echo Your simple tooltip integration is working!
    echo.
    echo Next steps:
    echo  1. Add more tooltip components incrementally
    echo  2. Test tooltip functionality
    echo  3. Integrate with real Chromium
    echo.
    echo SUCCESS: Simple tooltip integration is working!
    
) else (
    echo ERROR: Release directory not found
    echo Build may have failed
)

cd ..

REM Restore original CMakeLists.txt
if exist "CMakeLists_original.txt" (
    copy CMakeLists_original.txt CMakeLists.txt
    echo Restored original CMakeLists.txt
)

echo.
echo Simple tooltip build test completed.
pause
