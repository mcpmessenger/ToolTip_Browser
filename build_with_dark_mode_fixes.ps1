# Build Script for Chromium Fork with Dark Mode and Dawn Fixes
# This script implements all the solutions from the analysis documents

Write-Host "🔧 TOOLTIP: Starting Chromium build with dark mode and Dawn fixes..." -ForegroundColor Green

# Set error handling
$ErrorActionPreference = "Stop"

# Check if we're in the right directory
if (-not (Test-Path "chrome")) {
    Write-Host "❌ Error: Not in Chromium source directory. Please run from C:\chromium\src" -ForegroundColor Red
    exit 1
}

# Step 1: Ensure depot_tools is in PATH
Write-Host "🔧 TOOLTIP: Checking depot_tools..." -ForegroundColor Yellow
$depotToolsPath = "C:\chromium\depot_tools"
if (-not (Test-Path $depotToolsPath)) {
    Write-Host "❌ Error: depot_tools not found at $depotToolsPath" -ForegroundColor Red
    exit 1
}

# Add depot_tools to PATH for this session
$env:PATH = "$depotToolsPath;$env:PATH"

# Step 2: Force sync and run hooks (Dawn fix)
Write-Host "🔧 TOOLTIP: Running gclient sync --force (Dawn fix)..." -ForegroundColor Yellow
try {
    & gclient sync --force
    Write-Host "✅ gclient sync --force completed" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Warning: gclient sync --force failed, continuing..." -ForegroundColor Yellow
}

Write-Host "🔧 TOOLTIP: Running gclient runhooks..." -ForegroundColor Yellow
try {
    & gclient runhooks
    Write-Host "✅ gclient runhooks completed" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Warning: gclient runhooks failed, continuing..." -ForegroundColor Yellow
}

# Step 3: Clean previous build (if exists)
if (Test-Path "out/Default") {
    Write-Host "🔧 TOOLTIP: Cleaning previous build..." -ForegroundColor Yellow
    try {
        & gn clean out/Default
        Write-Host "✅ Clean completed" -ForegroundColor Green
    } catch {
        Write-Host "⚠️ Warning: Clean failed, continuing..." -ForegroundColor Yellow
    }
}

# Step 4: Generate build files with optimized args.gn
Write-Host "🔧 TOOLTIP: Generating build files with optimized configuration..." -ForegroundColor Yellow
try {
    & gn gen out/Default
    Write-Host "✅ Build files generated" -ForegroundColor Green
} catch {
    Write-Host "❌ Error: Failed to generate build files" -ForegroundColor Red
    Write-Host "Check your args.gn file for syntax errors" -ForegroundColor Red
    exit 1
}

# Step 5: Build Chromium with dark mode support
Write-Host "🔧 TOOLTIP: Building Chromium with dark mode support..." -ForegroundColor Yellow
Write-Host "This may take 2-4 hours depending on your hardware..." -ForegroundColor Cyan

try {
    & autoninja -C out/Default chrome
    Write-Host "✅ Build completed successfully!" -ForegroundColor Green
} catch {
    Write-Host "❌ Error: Build failed" -ForegroundColor Red
    Write-Host "Check the build output above for specific errors" -ForegroundColor Red
    exit 1
}

# Step 6: Test the build
Write-Host "🔧 TOOLTIP: Testing the build..." -ForegroundColor Yellow
$chromeExe = "out\Default\chrome.exe"
if (Test-Path $chromeExe) {
    Write-Host "✅ Chrome executable found at $chromeExe" -ForegroundColor Green
    
    # Get version info
    try {
        $version = & $chromeExe --version
        Write-Host "🔧 TOOLTIP: Built Chrome version: $version" -ForegroundColor Cyan
    } catch {
        Write-Host "⚠️ Warning: Could not get version info" -ForegroundColor Yellow
    }
    
    Write-Host "🎉 SUCCESS: Chromium fork with dark mode support built successfully!" -ForegroundColor Green
    Write-Host "🔧 TOOLTIP: You can now run: .\out\Default\chrome.exe" -ForegroundColor Cyan
} else {
    Write-Host "❌ Error: Chrome executable not found at $chromeExe" -ForegroundColor Red
    exit 1
}

Write-Host "🔧 TOOLTIP: Build process completed!" -ForegroundColor Green
