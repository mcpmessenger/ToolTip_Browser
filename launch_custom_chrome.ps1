# Launch Custom Chromium Build
# This script launches our custom Chrome with development flags

Write-Host "🌐 Launching Custom Chromium..." -ForegroundColor Green

$chromePath = "C:\chromium\src\src\out\Default\chrome.exe"

if (Test-Path $chromePath) {
    Write-Host "✅ Found custom Chrome executable" -ForegroundColor Green
    
    # Launch with development flags
    & $chromePath --enable-extensions --disable-web-security --user-data-dir=".\custom_chrome_data" --disable-features=VizDisplayCompositor --enable-logging --log-level=0
    
    Write-Host "🚀 Custom Chrome launched!" -ForegroundColor Cyan
} else {
    Write-Host "❌ Custom Chrome executable not found at: $chromePath" -ForegroundColor Red
    Write-Host "💡 Run quick_build.ps1 first to build the custom Chrome" -ForegroundColor Yellow
}
