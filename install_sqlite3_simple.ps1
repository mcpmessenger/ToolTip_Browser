# Install SQLite3 for NaviGrab integration
Write-Host "Installing SQLite3 for NaviGrab integration" -ForegroundColor Green

# Create sqlite3 directory
$sqliteDir = "sqlite3"
if (-not (Test-Path $sqliteDir)) {
    New-Item -ItemType Directory -Path $sqliteDir | Out-Null
    Write-Host "Created sqlite3 directory" -ForegroundColor Green
}

# Download SQLite3
Write-Host "Downloading SQLite3..." -ForegroundColor Yellow
try {
    $sqliteUrl = "https://www.sqlite.org/2024/sqlite-dll-win64-x64-3460000.zip"
    $sqliteZip = "sqlite3.zip"
    
    Invoke-WebRequest -Uri $sqliteUrl -OutFile $sqliteZip
    Write-Host "SQLite3 downloaded successfully" -ForegroundColor Green
    
    # Extract SQLite3
    Write-Host "Extracting SQLite3..." -ForegroundColor Yellow
    Expand-Archive -Path $sqliteZip -DestinationPath $sqliteDir -Force
    Write-Host "SQLite3 extracted successfully" -ForegroundColor Green
    
    # Clean up zip file
    Remove-Item $sqliteZip
    Write-Host "Cleaned up zip file" -ForegroundColor Green
    
} catch {
    Write-Host "Failed to download SQLite3: $_" -ForegroundColor Red
    Write-Host "Let's try building without SQLite3..." -ForegroundColor Yellow
}

# Check what we got
Write-Host "SQLite3 files:" -ForegroundColor Cyan
Get-ChildItem -Path $sqliteDir -Recurse | Select-Object Name, FullName

Write-Host "SQLite3 installation completed!" -ForegroundColor Green
Write-Host "Now you can run: .\build_with_cmake_path.bat" -ForegroundColor White

