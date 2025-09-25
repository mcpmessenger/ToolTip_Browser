# Quick Build Script for Chromium Fork Development
# This script performs an incremental build of only the changed components

Write-Host "🚀 Starting Quick Chromium Build..." -ForegroundColor Green

# Set up environment
& "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
$env:DEPOT_TOOLS_WIN_TOOLCHAIN = "0"
$env:PATH = "C:\depot_tools;C:\Users\senti\AppData\Local\Programs\Python\Python311;C:\Users\senti\AppData\Local\Programs\Python\Python311\Scripts;$env:PATH"
$env:PYTHON = "C:\Users\senti\AppData\Local\Programs\Python\Python311\python.exe"

# Change to Chromium source directory
Set-Location "C:\chromium\src\src"

Write-Host "📦 Running incremental build..." -ForegroundColor Yellow
& autoninja -C out/Default chrome

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Build successful! Chrome executable updated." -ForegroundColor Green
    Write-Host "📍 Location: C:\chromium\src\src\out\Default\chrome.exe" -ForegroundColor Cyan
} else {
    Write-Host "❌ Build failed. Check the output above for errors." -ForegroundColor Red
}

# Return to project directory
Set-Location "C:\ChromiumFresh"
