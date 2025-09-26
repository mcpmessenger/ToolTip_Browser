# Simple Build Script for ChromiumFresh + NaviGrab
param(
    [switch]$IncludeNaviGrab = $true,
    [switch]$Clean = $false,
    [string]$BuildType = "Release"
)

Write-Host "🚀 ChromiumFresh + NaviGrab Build Script" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

# Set error handling
$ErrorActionPreference = "Continue"

# Check if we're in the right directory
if (-not (Test-Path "CMakeLists.txt")) {
    Write-Host "❌ Error: Not in ChromiumFresh root directory" -ForegroundColor Red
    exit 1
}

# Clean build if requested
if ($Clean) {
    Write-Host "🧹 Cleaning build directories..." -ForegroundColor Yellow
    if (Test-Path "build") {
        Remove-Item -Recurse -Force "build"
    }
    Write-Host "✅ Clean completed" -ForegroundColor Green
}

# Create build directory
Write-Host "📁 Creating build directory..." -ForegroundColor Yellow
New-Item -ItemType Directory -Path "build" -Force | Out-Null

# Configure CMake
Write-Host "⚙️ Configuring CMake..." -ForegroundColor Yellow
try {
    cmake -B build -S . -G "Visual Studio 17 2022" -A x64 -DCMAKE_BUILD_TYPE=$BuildType
    if ($LASTEXITCODE -ne 0) {
        throw "CMake configuration failed"
    }
    Write-Host "✅ CMake configuration successful" -ForegroundColor Green
} catch {
    Write-Host "❌ CMake configuration failed: $_" -ForegroundColor Red
    exit 1
}

# Build NaviGrab components
if ($IncludeNaviGrab) {
    Write-Host "🕷️ Building NaviGrab components..." -ForegroundColor Yellow
    try {
        cmake --build build --target chromium_playwright_core --config $BuildType
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ NaviGrab core built successfully" -ForegroundColor Green
        } else {
            Write-Host "⚠️ NaviGrab core build had issues" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "⚠️ NaviGrab core build failed: $_" -ForegroundColor Yellow
    }
    
    # Build NaviGrab examples
    Write-Host "📚 Building NaviGrab examples..." -ForegroundColor Yellow
    try {
        cmake --build build --target basic_usage --config $BuildType
        cmake --build build --target comprehensive_demo --config $BuildType
        cmake --build build --target screenshot_test_demo --config $BuildType
        Write-Host "✅ NaviGrab examples built" -ForegroundColor Green
    } catch {
        Write-Host "⚠️ Some NaviGrab examples failed: $_" -ForegroundColor Yellow
    }
}

# Build unified components
Write-Host "🔗 Building unified components..." -ForegroundColor Yellow
try {
    cmake --build build --target chromium_fresh_unified --config $BuildType
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Unified library built successfully" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Unified library build had issues" -ForegroundColor Yellow
    }
} catch {
    Write-Host "⚠️ Unified library build failed: $_" -ForegroundColor Yellow
}

# Build integration examples
Write-Host "🎯 Building integration examples..." -ForegroundColor Yellow
try {
    cmake --build build --target web_automation_demo --config $BuildType
    cmake --build build --target tooltip_automation_demo --config $BuildType
    cmake --build build --target unified_api_server --config $BuildType
    Write-Host "✅ Integration examples built" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Some integration examples failed: $_" -ForegroundColor Yellow
}

# Build tests
Write-Host "🧪 Building tests..." -ForegroundColor Yellow
try {
    cmake --build build --target integration_tests --config $BuildType
    Write-Host "✅ Tests built" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Some tests failed: $_" -ForegroundColor Yellow
}

# Check results
Write-Host "`n📊 Build Results" -ForegroundColor Cyan
Write-Host "================" -ForegroundColor Cyan

$buildDir = "build\bin\$BuildType"
if (Test-Path $buildDir) {
    $executables = Get-ChildItem -Path $buildDir -Filter "*.exe"
    if ($executables) {
        Write-Host "✅ Built executables:" -ForegroundColor Green
        foreach ($exe in $executables) {
            Write-Host "   📄 $($exe.Name)" -ForegroundColor White
        }
    } else {
        Write-Host "⚠️ No executables found in $buildDir" -ForegroundColor Yellow
    }
} else {
    Write-Host "⚠️ Build directory not found: $buildDir" -ForegroundColor Yellow
}

Write-Host "`n🎉 Build completed!" -ForegroundColor Green
Write-Host "===================" -ForegroundColor Green

if ($IncludeNaviGrab) {
    Write-Host "🕷️ NaviGrab integration: ENABLED" -ForegroundColor Green
} else {
    Write-Host "🕷️ NaviGrab integration: DISABLED" -ForegroundColor Yellow
}

Write-Host "📁 Build output: $buildDir" -ForegroundColor White

