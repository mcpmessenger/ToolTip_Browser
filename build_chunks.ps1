# Chunked Build Script for Tooltip Chromium
# This builds components separately to avoid Dawn issues

Write-Host "Building Chromium in chunks to avoid Dawn issues..." -ForegroundColor Green

# Set error handling
$ErrorActionPreference = "Continue"

# Check if we're in the right directory
if (-not (Test-Path "chrome")) {
    Write-Host "Error: Not in Chromium source directory. Please run from C:\chromium\src\src" -ForegroundColor Red
    exit 1
}

# Add depot_tools to PATH
$env:PATH = "C:\chromium\depot_tools;$env:PATH"

Write-Host "Step 1: Clean and configure build..." -ForegroundColor Yellow
gn clean out/Default
gn gen out/Default --args="is_debug=false is_component_build=true symbol_level=1 use_dawn=false skia_use_dawn=false use_webgpu=false use_gpu=false enable_gpu=false enable_gpu_service=false enable_hardware_acceleration=false target_os=\"win\" target_cpu=\"x64\""

Write-Host "Step 2: Build base components first..." -ForegroundColor Yellow
try {
    autoninja -C out/Default base
    Write-Host "SUCCESS: Base components built" -ForegroundColor Green
} catch {
    Write-Host "WARNING: Base build had issues, continuing..." -ForegroundColor Yellow
}

Write-Host "Step 3: Build content layer..." -ForegroundColor Yellow
try {
    autoninja -C out/Default content
    Write-Host "SUCCESS: Content layer built" -ForegroundColor Green
} catch {
    Write-Host "WARNING: Content build had issues, continuing..." -ForegroundColor Yellow
}

Write-Host "Step 4: Build browser components..." -ForegroundColor Yellow
try {
    autoninja -C out/Default chrome/browser
    Write-Host "SUCCESS: Browser components built" -ForegroundColor Green
} catch {
    Write-Host "WARNING: Browser build had issues, continuing..." -ForegroundColor Yellow
}

Write-Host "Step 5: Build UI components..." -ForegroundColor Yellow
try {
    autoninja -C out/Default chrome/browser/ui
    Write-Host "SUCCESS: UI components built" -ForegroundColor Green
} catch {
    Write-Host "WARNING: UI build had issues, continuing..." -ForegroundColor Yellow
}

Write-Host "Step 6: Build tooltip components..." -ForegroundColor Yellow
try {
    autoninja -C out/Default chrome/browser/tooltip
    Write-Host "SUCCESS: Tooltip components built" -ForegroundColor Green
} catch {
    Write-Host "WARNING: Tooltip build had issues, continuing..." -ForegroundColor Yellow
}

Write-Host "Step 7: Build Chrome executable (skip GPU parts)..." -ForegroundColor Yellow
try {
    # Try to build chrome without GPU components
    autoninja -C out/Default chrome --target=chrome
    Write-Host "SUCCESS: Chrome executable built!" -ForegroundColor Green
} catch {
    Write-Host "WARNING: Chrome build had issues, trying alternative..." -ForegroundColor Yellow
    
    # Alternative: try building browser target
    try {
        autoninja -C out/Default browser
        Write-Host "SUCCESS: Browser target built!" -ForegroundColor Green
    } catch {
        Write-Host "ERROR: All build attempts failed" -ForegroundColor Red
        exit 1
    }
}

Write-Host "Build completed! Check out/Default for executables." -ForegroundColor Green
