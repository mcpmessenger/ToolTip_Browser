# Complete Setup Script for Chromium Fork with Dark Mode
# This script sets up the entire development environment and builds the fork

Write-Host "🔧 TOOLTIP: Setting up Chromium Fork with Dark Mode Support..." -ForegroundColor Green
Write-Host "This script will:" -ForegroundColor Cyan
Write-Host "  1. Set up the Chromium source directory" -ForegroundColor White
Write-Host "  2. Copy tooltip files to the correct location" -ForegroundColor White
Write-Host "  3. Configure build settings with Dawn fixes" -ForegroundColor White
Write-Host "  4. Build the Chromium fork" -ForegroundColor White
Write-Host "  5. Test dark mode functionality" -ForegroundColor White

# Set error handling
$ErrorActionPreference = "Stop"

# Check if we're in the right directory
if (-not (Test-Path "chrome")) {
    Write-Host "❌ Error: Not in Chromium source directory" -ForegroundColor Red
    Write-Host "Please run this script from C:\chromium\src" -ForegroundColor Yellow
    exit 1
}

# Step 1: Copy tooltip files to Chromium source
Write-Host "🔧 TOOLTIP: Copying tooltip files to Chromium source..." -ForegroundColor Yellow

$tooltipSourceDir = "C:\ChromiumFresh\chrome\browser\tooltip"
$tooltipTargetDir = "chrome\browser\tooltip"

if (Test-Path $tooltipSourceDir) {
    if (-not (Test-Path $tooltipTargetDir)) {
        New-Item -ItemType Directory -Path $tooltipTargetDir -Force
    }
    
    # Copy all tooltip files
    Copy-Item -Path "$tooltipSourceDir\*" -Destination $tooltipTargetDir -Recurse -Force
    Write-Host "✅ Tooltip files copied successfully" -ForegroundColor Green
} else {
    Write-Host "⚠️ Warning: Tooltip source directory not found at $tooltipSourceDir" -ForegroundColor Yellow
    Write-Host "Make sure you're running from the correct directory" -ForegroundColor Yellow
}

# Step 2: Copy UI tooltip files
$uiTooltipSourceDir = "C:\ChromiumFresh\chrome\browser\ui\views\tooltip"
$uiTooltipTargetDir = "chrome\browser\ui\views\tooltip"

if (Test-Path $uiTooltipSourceDir) {
    if (-not (Test-Path $uiTooltipTargetDir)) {
        New-Item -ItemType Directory -Path $uiTooltipTargetDir -Force
    }
    
    Copy-Item -Path "$uiTooltipSourceDir\*" -Destination $uiTooltipTargetDir -Recurse -Force
    Write-Host "✅ UI tooltip files copied successfully" -ForegroundColor Green
} else {
    Write-Host "⚠️ Warning: UI tooltip source directory not found at $uiTooltipSourceDir" -ForegroundColor Yellow
}

# Step 3: Copy build configuration
Write-Host "🔧 TOOLTIP: Setting up build configuration..." -ForegroundColor Yellow

$argsGnSource = "C:\ChromiumFresh\args.gn"
if (Test-Path $argsGnSource) {
    Copy-Item -Path $argsGnSource -Destination "args.gn" -Force
    Write-Host "✅ Build configuration copied" -ForegroundColor Green
} else {
    Write-Host "⚠️ Warning: args.gn not found at $argsGnSource" -ForegroundColor Yellow
}

# Step 4: Run the build script
Write-Host "🔧 TOOLTIP: Starting build process..." -ForegroundColor Yellow

$buildScript = "C:\ChromiumFresh\build_with_dark_mode_fixes.ps1"
if (Test-Path $buildScript) {
    Write-Host "Running build script..." -ForegroundColor Cyan
    & $buildScript
} else {
    Write-Host "⚠️ Warning: Build script not found at $buildScript" -ForegroundColor Yellow
    Write-Host "Please run the build manually" -ForegroundColor Yellow
}

# Step 5: Run the test script
Write-Host "🔧 TOOLTIP: Running dark mode test..." -ForegroundColor Yellow

$testScript = "C:\ChromiumFresh\test_dark_mode_functionality.ps1"
if (Test-Path $testScript) {
    Write-Host "Running test script..." -ForegroundColor Cyan
    & $testScript
} else {
    Write-Host "⚠️ Warning: Test script not found at $testScript" -ForegroundColor Yellow
    Write-Host "Please run the test manually" -ForegroundColor Yellow
}

Write-Host "🎉 SUCCESS: Chromium fork setup completed!" -ForegroundColor Green
Write-Host "🔧 TOOLTIP: Your Chromium fork with dark mode support is ready!" -ForegroundColor Cyan
