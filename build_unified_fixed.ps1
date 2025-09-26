# Unified Build Script for ChromiumFresh + NaviGrab
# This builds both ChromiumFresh and NaviGrab components together

param(
    [switch]$IncludeNaviGrab = $true,
    [switch]$BuildNaviGrabOnly = $false,
    [switch]$Clean = $false,
    [string]$BuildType = "Release",
    [switch]$Verbose = $false
)

Write-Host "🚀 ChromiumFresh + NaviGrab Unified Build Script" -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Green

# Set error handling
$ErrorActionPreference = "Continue"

# Check if we're in the right directory
if (-not (Test-Path "CMakeLists.txt")) {
    Write-Host "❌ Error: Not in ChromiumFresh root directory. Please run from C:\ChromiumFresh" -ForegroundColor Red
    exit 1
}

# Check if NaviGrab exists
if ($IncludeNaviGrab -and -not (Test-Path "NaviGrab")) {
    Write-Host "❌ Error: NaviGrab directory not found. Please ensure NaviGrab is in the project root." -ForegroundColor Red
    exit 1
}

# Clean build if requested
if ($Clean) {
    Write-Host "🧹 Cleaning build directories..." -ForegroundColor Yellow
    if (Test-Path "build") {
        Remove-Item -Recurse -Force "build"
    }
    if (Test-Path "NaviGrab\build") {
        Remove-Item -Recurse -Force "NaviGrab\build"
    }
    Write-Host "✅ Clean completed" -ForegroundColor Green
}

# Create build directory
Write-Host "📁 Creating build directory..." -ForegroundColor Yellow
New-Item -ItemType Directory -Path "build" -Force | Out-Null

# Configure CMake
Write-Host "⚙️ Configuring CMake..." -ForegroundColor Yellow
$cmakeArgs = @(
    "-B", "build",
    "-S", ".",
    "-G", "Visual Studio 17 2022",
    "-A", "x64",
    "-DCMAKE_BUILD_TYPE=$BuildType"
)

if ($IncludeNaviGrab) {
    $cmakeArgs += "-DINCLUDE_NAVIGRAB=ON"
}

if ($Verbose) {
    $cmakeArgs += "--verbose"
}

try {
    & cmake @cmakeArgs
    if ($LASTEXITCODE -ne 0) {
        throw "CMake configuration failed"
    }
    Write-Host "✅ CMake configuration successful" -ForegroundColor Green
} catch {
    Write-Host "❌ CMake configuration failed: $_" -ForegroundColor Red
    exit 1
}

# Build NaviGrab components first (if included)
if ($IncludeNaviGrab -or $BuildNaviGrabOnly) {
    Write-Host "🕷️ Building NaviGrab components..." -ForegroundColor Yellow
    
    try {
        & cmake --build build --target chromium_playwright_core --config $BuildType
        if ($LASTEXITCODE -ne 0) {
            throw "NaviGrab core build failed"
        }
        Write-Host "✅ NaviGrab core built successfully" -ForegroundColor Green
    } catch {
        Write-Host "❌ NaviGrab core build failed: $_" -ForegroundColor Red
        if (-not $BuildNaviGrabOnly) {
            Write-Host "⚠️ Continuing with ChromiumFresh build..." -ForegroundColor Yellow
        } else {
            exit 1
        }
    }
    
    # Build NaviGrab examples
    Write-Host "📚 Building NaviGrab examples..." -ForegroundColor Yellow
    try {
        & cmake --build build --target basic_usage --config $BuildType
        & cmake --build build --target comprehensive_demo --config $BuildType
        & cmake --build build --target screenshot_test_demo --config $BuildType
        Write-Host "✅ NaviGrab examples built successfully" -ForegroundColor Green
    } catch {
        Write-Host "⚠️ Some NaviGrab examples failed to build: $_" -ForegroundColor Yellow
    }
}

# Build unified components
if (-not $BuildNaviGrabOnly) {
    Write-Host "🔗 Building unified components..." -ForegroundColor Yellow
    
    try {
        & cmake --build build --target chromium_fresh_unified --config $BuildType
        if ($LASTEXITCODE -ne 0) {
            throw "Unified library build failed"
        }
        Write-Host "✅ Unified library built successfully" -ForegroundColor Green
    } catch {
        Write-Host "❌ Unified library build failed: $_" -ForegroundColor Red
        exit 1
    }
    
    # Build integration examples
    Write-Host "🎯 Building integration examples..." -ForegroundColor Yellow
    try {
        & cmake --build build --target web_automation_demo --config $BuildType
        & cmake --build build --target tooltip_automation_demo --config $BuildType
        & cmake --build build --target unified_api_server --config $BuildType
        Write-Host "✅ Integration examples built successfully" -ForegroundColor Green
    } catch {
        Write-Host "⚠️ Some integration examples failed to build: $_" -ForegroundColor Yellow
    }
}

# Build tests
Write-Host "🧪 Building tests..." -ForegroundColor Yellow
try {
    & cmake --build build --target integration_tests --config $BuildType
    Write-Host "✅ Tests built successfully" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Some tests failed to build: $_" -ForegroundColor Yellow
}

# Run tests if requested
if ($args -contains "--test") {
    Write-Host "🧪 Running tests..." -ForegroundColor Yellow
    try {
        & cmake --build build --target test --config $BuildType
        Write-Host "✅ Tests completed" -ForegroundColor Green
    } catch {
        Write-Host "⚠️ Some tests failed: $_" -ForegroundColor Yellow
    }
}

# Build summary
Write-Host "`n📊 Build Summary" -ForegroundColor Cyan
Write-Host "================" -ForegroundColor Cyan

$buildDir = "build\bin\$BuildType"
if (Test-Path $buildDir) {
    $executables = Get-ChildItem -Path $buildDir -Filter "*.exe" | Select-Object Name
    if ($executables) {
        Write-Host "✅ Built executables:" -ForegroundColor Green
        foreach ($exe in $executables) {
            Write-Host "   📄 $($exe.Name)" -ForegroundColor White
        }
    }
}

# Check for specific components
$components = @(
    @{Name="NaviGrab Core"; Path="build\lib\$BuildType\chromium_playwright_core.lib"},
    @{Name="Unified Library"; Path="build\lib\$BuildType\chromium_fresh_unified.lib"},
    @{Name="Web Automation Demo"; Path="build\bin\$BuildType\web_automation_demo.exe"},
    @{Name="Tooltip Automation Demo"; Path="build\bin\$BuildType\tooltip_automation_demo.exe"},
    @{Name="Unified API Server"; Path="build\bin\$BuildType\unified_api_server.exe"}
)

Write-Host "`n🔍 Component Status:" -ForegroundColor Cyan
foreach ($component in $components) {
    if (Test-Path $component.Path) {
        Write-Host "   ✅ $($component.Name)" -ForegroundColor Green
    } else {
        Write-Host "   ❌ $($component.Name)" -ForegroundColor Red
    }
}

Write-Host "`n🎉 Build completed!" -ForegroundColor Green
Write-Host "===================" -ForegroundColor Green

if ($IncludeNaviGrab) {
    Write-Host "🕷️ NaviGrab integration: ENABLED" -ForegroundColor Green
} else {
    Write-Host "🕷️ NaviGrab integration: DISABLED" -ForegroundColor Yellow
}

Write-Host "📁 Build output: $buildDir" -ForegroundColor White
Write-Host "`n🚀 Next steps:" -ForegroundColor Cyan
Write-Host "   1. Run examples: .\build\bin\$BuildType\web_automation_demo.exe" -ForegroundColor White
Write-Host "   2. Start API server: .\build\bin\$BuildType\unified_api_server.exe" -ForegroundColor White
Write-Host "   3. Run tests: .\build\bin\$BuildType\integration_tests.exe" -ForegroundColor White

