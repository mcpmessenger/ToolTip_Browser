# Build Script for Tooltip Chromium - Multiple Approaches
# This script tries different build configurations to avoid Dawn issues

Write-Host "🔧 TOOLTIP: Starting Tooltip Chromium build with multiple approaches..." -ForegroundColor Green

# Set error handling
$ErrorActionPreference = "Continue"

# Check if we're in the right directory
if (-not (Test-Path "chrome")) {
    Write-Host "❌ Error: Not in Chromium source directory. Please run from C:\chromium\src\src" -ForegroundColor Red
    exit 1
}

# Add depot_tools to PATH
$env:PATH = "C:\chromium\depot_tools;$env:PATH"

Write-Host "🔧 TOOLTIP: Attempting Approach 1: Build browser only (no GPU process)..." -ForegroundColor Yellow

# Approach 1: Build browser only
try {
    # Clean previous build
    if (Test-Path "out/Default") {
        gn clean out/Default
    }
    
    # Generate build files
    gn gen out/Default --args="
        is_debug=false
        is_component_build=true
        symbol_level=1
        use_dawn=false
        skia_use_dawn=false
        use_webgpu=false
        use_gpu=false
        enable_gpu=false
        enable_gpu_service=false
        enable_hardware_acceleration=false
        target_os=\"win\"
        target_cpu=\"x64\"
    "
    
    # Try to build browser only
    autoninja -C out/Default chrome
    Write-Host "✅ Approach 1 SUCCESS: Browser built without GPU!" -ForegroundColor Green
    exit 0
    
} catch {
    Write-Host "❌ Approach 1 FAILED: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "🔧 TOOLTIP: Attempting Approach 2: Build with software rendering..." -ForegroundColor Yellow

# Approach 2: Software rendering only
try {
    # Clean previous build
    if (Test-Path "out/Default") {
        gn clean out/Default
    }
    
    # Generate build files with software rendering
    gn gen out/Default --args="
        is_debug=false
        is_component_build=true
        symbol_level=1
        use_dawn=false
        skia_use_dawn=false
        use_webgpu=false
        use_gpu=false
        enable_gpu=false
        enable_gpu_service=false
        enable_hardware_acceleration=false
        use_gl=false
        use_angle=false
        use_vulkan=false
        use_metal=false
        use_d3d11=false
        use_d3d12=false
        target_os=\"win\"
        target_cpu=\"x64\"
    "
    
    # Try to build with software rendering
    autoninja -C out/Default chrome
    Write-Host "✅ Approach 2 SUCCESS: Browser built with software rendering!" -ForegroundColor Green
    exit 0
    
} catch {
    Write-Host "❌ Approach 2 FAILED: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "🔧 TOOLTIP: Attempting Approach 3: Build headless browser..." -ForegroundColor Yellow

# Approach 3: Headless browser
try {
    # Clean previous build
    if (Test-Path "out/Default") {
        gn clean out/Default
    }
    
    # Generate build files for headless
    gn gen out/Default --args="
        is_debug=false
        is_component_build=true
        symbol_level=1
        use_dawn=false
        skia_use_dawn=false
        use_webgpu=false
        use_gpu=false
        enable_gpu=false
        enable_gpu_service=false
        enable_hardware_acceleration=false
        target_os=\"win\"
        target_cpu=\"x64\"
    "
    
    # Try to build headless browser
    autoninja -C out/Default headless_shell
    Write-Host "✅ Approach 3 SUCCESS: Headless browser built!" -ForegroundColor Green
    exit 0
    
} catch {
    Write-Host "❌ Approach 3 FAILED: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "❌ All approaches failed. The Dawn issue persists." -ForegroundColor Red
Write-Host "🔧 TOOLTIP: Consider using the prebuilt Chromium with a browser extension for dark mode." -ForegroundColor Yellow
exit 1
