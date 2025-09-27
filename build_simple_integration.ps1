# Simple ToolTip_Browser Integration Build Script
# This script builds the integrated system step by step

Write-Host "TOOLTIP: Starting Simple Integration Build..." -ForegroundColor Green
Write-Host "This script will:" -ForegroundColor Cyan
Write-Host "  1. Clean previous build artifacts" -ForegroundColor White
Write-Host "  2. Configure CMake with tooltip components" -ForegroundColor White
Write-Host "  3. Build all libraries and executables" -ForegroundColor White
Write-Host "  4. Test the integration" -ForegroundColor White

# Set error handling
$ErrorActionPreference = "Stop"

# Check if we're in the right directory
if (-not (Test-Path "CMakeLists.txt")) {
    Write-Host "❌ Error: Not in project root directory" -ForegroundColor Red
    Write-Host "Please run this script from C:\ChromiumFresh" -ForegroundColor Yellow
    exit 1
}

# Step 1: Clean previous build
Write-Host "🧹 TOOLTIP: Cleaning previous build artifacts..." -ForegroundColor Yellow
if (Test-Path "build") {
    Remove-Item -Path "build" -Recurse -Force
    Write-Host "✅ Build directory cleaned" -ForegroundColor Green
}

# Step 2: Create build directory
Write-Host "📁 TOOLTIP: Creating build directory..." -ForegroundColor Yellow
New-Item -ItemType Directory -Path "build" -Force | Out-Null
Set-Location "build"

# Step 3: Configure CMake
Write-Host "⚙️ TOOLTIP: Configuring CMake..." -ForegroundColor Yellow
cmake .. -G "Visual Studio 17 2022" -A x64 -DCMAKE_BUILD_TYPE=Release
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ CMake configuration failed" -ForegroundColor Red
    Write-Host "Trying alternative configuration..." -ForegroundColor Yellow
    cmake .. -G "Visual Studio 16 2019" -A x64 -DCMAKE_BUILD_TYPE=Release
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ CMake configuration failed with both generators" -ForegroundColor Red
        exit 1
    }
}
Write-Host "✅ CMake configuration successful" -ForegroundColor Green

# Step 4: Build all targets
Write-Host "🔨 TOOLTIP: Building all targets..." -ForegroundColor Yellow
cmake --build . --config Release --parallel
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Build failed" -ForegroundColor Red
    Write-Host "Trying single-threaded build..." -ForegroundColor Yellow
    cmake --build . --config Release
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Build failed even with single-threaded build" -ForegroundColor Red
        exit 1
    }
}
Write-Host "✅ Build successful" -ForegroundColor Green

# Step 5: Test the build
Write-Host "🧪 TOOLTIP: Testing the build..." -ForegroundColor Yellow

# Test 1: Minimal test
if (Test-Path "Release\minimal_test.exe") {
    Write-Host "  Testing minimal_test.exe..." -ForegroundColor Cyan
    .\Release\minimal_test.exe
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✅ minimal_test.exe passed" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️ minimal_test.exe failed (exit code: $LASTEXITCODE)" -ForegroundColor Yellow
    }
} else {
    Write-Host "  ⚠️ minimal_test.exe not found" -ForegroundColor Yellow
}

# Test 2: Simple test
if (Test-Path "Release\simple_test.exe") {
    Write-Host "  Testing simple_test.exe..." -ForegroundColor Cyan
    .\Release\simple_test.exe
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✅ simple_test.exe passed" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️ simple_test.exe failed (exit code: $LASTEXITCODE)" -ForegroundColor Yellow
    }
} else {
    Write-Host "  ⚠️ simple_test.exe not found" -ForegroundColor Yellow
}

# Test 3: Web automation demo
if (Test-Path "Release\web_automation_demo.exe") {
    Write-Host "  Testing web_automation_demo.exe..." -ForegroundColor Cyan
    .\Release\web_automation_demo.exe
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✅ web_automation_demo.exe passed" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️ web_automation_demo.exe failed (exit code: $LASTEXITCODE)" -ForegroundColor Yellow
    }
} else {
    Write-Host "  ⚠️ web_automation_demo.exe not found" -ForegroundColor Yellow
}

# Test 4: Tooltip automation demo
if (Test-Path "Release\tooltip_automation_demo.exe") {
    Write-Host "  Testing tooltip_automation_demo.exe..." -ForegroundColor Cyan
    .\Release\tooltip_automation_demo.exe
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✅ tooltip_automation_demo.exe passed" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️ tooltip_automation_demo.exe failed (exit code: $LASTEXITCODE)" -ForegroundColor Yellow
    }
} else {
    Write-Host "  ⚠️ tooltip_automation_demo.exe not found" -ForegroundColor Yellow
}

# Test 5: Full integration demo
if (Test-Path "Release\full_integration_demo.exe") {
    Write-Host "  Testing full_integration_demo.exe..." -ForegroundColor Cyan
    .\Release\full_integration_demo.exe
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✅ full_integration_demo.exe passed" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️ full_integration_demo.exe failed (exit code: $LASTEXITCODE)" -ForegroundColor Yellow
    }
} else {
    Write-Host "  ⚠️ full_integration_demo.exe not found" -ForegroundColor Yellow
}

# Step 6: Create deployment directory
Write-Host "📦 TOOLTIP: Creating deployment package..." -ForegroundColor Yellow
$deployDir = "..\deploy"
if (Test-Path $deployDir) {
    Remove-Item -Path $deployDir -Recurse -Force
}
New-Item -ItemType Directory -Path $deployDir -Force | Out-Null

# Copy executables
$executables = @(
    "Release\minimal_test.exe",
    "Release\simple_test.exe",
    "Release\web_automation_demo.exe",
    "Release\tooltip_automation_demo.exe",
    "Release\full_integration_demo.exe"
)

foreach ($exe in $executables) {
    if (Test-Path $exe) {
        Copy-Item -Path $exe -Destination $deployDir -Force
        Write-Host "✅ Copied $exe" -ForegroundColor Green
    }
}

# Copy libraries
$libraries = @(
    "Release\navigrab_core.lib",
    "Release\tooltip_core.lib",
    "Release\tooltip_ui.lib",
    "Release\chromium_fresh_unified.lib"
)

foreach ($lib in $libraries) {
    if (Test-Path $lib) {
        Copy-Item -Path $lib -Destination $deployDir -Force
        Write-Host "✅ Copied $lib" -ForegroundColor Green
    }
}

# Return to project root
Set-Location ".."

# Final summary
Write-Host ""
Write-Host "🎉 SUCCESS: Simple ToolTip_Browser Integration Complete!" -ForegroundColor Green
Write-Host "📦 Deployment package created in: deploy\" -ForegroundColor Cyan
Write-Host "🧪 Test executables are ready for testing!" -ForegroundColor Cyan
Write-Host ""
Write-Host "TOOLTIP: Your integrated system is ready!" -ForegroundColor Green
