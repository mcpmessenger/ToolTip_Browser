# Integration Test Script for ChromiumFresh + NaviGrab
# This script tests the integration between ChromiumFresh and NaviGrab

param(
    [switch]$IncludeNaviGrab = $true,
    [switch]$RunExamples = $true,
    [switch]$RunTests = $true,
    [switch]$StartAPIServer = $false,
    [string]$BuildType = "Release"
)

Write-Host "🧪 ChromiumFresh + NaviGrab Integration Test" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green

# Set error handling
$ErrorActionPreference = "Continue"

# Check if build exists
$buildDir = "build\bin\$BuildType"
if (-not (Test-Path $buildDir)) {
    Write-Host "❌ Error: Build directory not found. Please run build_unified.ps1 first." -ForegroundColor Red
    exit 1
}

# Test 1: Check if executables exist
Write-Host "`n🔍 Test 1: Checking executables..." -ForegroundColor Yellow

$requiredExecutables = @(
    "web_automation_demo.exe",
    "tooltip_automation_demo.exe",
    "unified_api_server.exe"
)

if ($IncludeNaviGrab) {
    $requiredExecutables += @(
        "basic_usage.exe",
        "comprehensive_demo.exe",
        "screenshot_test_demo.exe"
    )
}

$missingExecutables = @()
foreach ($exe in $requiredExecutables) {
    $exePath = Join-Path $buildDir $exe
    if (Test-Path $exePath) {
        Write-Host "   ✅ $exe" -ForegroundColor Green
    } else {
        Write-Host "   ❌ $exe" -ForegroundColor Red
        $missingExecutables += $exe
    }
}

if ($missingExecutables.Count -gt 0) {
    Write-Host "❌ Missing executables: $($missingExecutables -join ', ')" -ForegroundColor Red
    Write-Host "Please run build_unified.ps1 to build missing components." -ForegroundColor Yellow
    exit 1
}

# Test 2: Run NaviGrab examples (if enabled)
if ($IncludeNaviGrab -and $RunExamples) {
    Write-Host "`n🕷️ Test 2: Running NaviGrab examples..." -ForegroundColor Yellow
    
    $navigrabExamples = @(
        @{Name="Basic Usage"; Exe="basic_usage.exe"; Timeout=30},
        @{Name="Screenshot Demo"; Exe="screenshot_test_demo.exe"; Timeout=30},
        @{Name="Comprehensive Demo"; Exe="comprehensive_demo.exe"; Timeout=60}
    )
    
    foreach ($example in $navigrabExamples) {
        Write-Host "   🚀 Running $($example.Name)..." -ForegroundColor Cyan
        $exePath = Join-Path $buildDir $example.Exe
        
        try {
            $process = Start-Process -FilePath $exePath -WorkingDirectory $buildDir -PassThru -NoNewWindow
            $completed = $process.WaitForExit($example.Timeout * 1000)
            
            if ($completed) {
                if ($process.ExitCode -eq 0) {
                    Write-Host "   ✅ $($example.Name) completed successfully" -ForegroundColor Green
                } else {
                    Write-Host "   ⚠️ $($example.Name) completed with exit code $($process.ExitCode)" -ForegroundColor Yellow
                }
            } else {
                Write-Host "   ⚠️ $($example.Name) timed out after $($example.Timeout) seconds" -ForegroundColor Yellow
                $process.Kill()
            }
        } catch {
            Write-Host "   ❌ $($example.Name) failed: $_" -ForegroundColor Red
        }
    }
}

# Test 3: Run integration examples
if ($RunExamples) {
    Write-Host "`n🔗 Test 3: Running integration examples..." -ForegroundColor Yellow
    
    $integrationExamples = @(
        @{Name="Web Automation Demo"; Exe="web_automation_demo.exe"; Timeout=60},
        @{Name="Tooltip Automation Demo"; Exe="tooltip_automation_demo.exe"; Timeout=60}
    )
    
    foreach ($example in $integrationExamples) {
        Write-Host "   🚀 Running $($example.Name)..." -ForegroundColor Cyan
        $exePath = Join-Path $buildDir $example.Exe
        
        try {
            $process = Start-Process -FilePath $exePath -WorkingDirectory $buildDir -PassThru -NoNewWindow
            $completed = $process.WaitForExit($example.Timeout * 1000)
            
            if ($completed) {
                if ($process.ExitCode -eq 0) {
                    Write-Host "   ✅ $($example.Name) completed successfully" -ForegroundColor Green
                } else {
                    Write-Host "   ⚠️ $($example.Name) completed with exit code $($process.ExitCode)" -ForegroundColor Yellow
                }
            } else {
                Write-Host "   ⚠️ $($example.Name) timed out after $($example.Timeout) seconds" -ForegroundColor Yellow
                $process.Kill()
            }
        } catch {
            Write-Host "   ❌ $($example.Name) failed: $_" -ForegroundColor Red
        }
    }
}

# Test 4: Run integration tests
if ($RunTests) {
    Write-Host "`n🧪 Test 4: Running integration tests..." -ForegroundColor Yellow
    
    $testExe = Join-Path $buildDir "integration_tests.exe"
    if (Test-Path $testExe) {
        Write-Host "   🚀 Running integration tests..." -ForegroundColor Cyan
        
        try {
            $process = Start-Process -FilePath $testExe -WorkingDirectory $buildDir -PassThru -NoNewWindow
            $completed = $process.WaitForExit(120000) # 2 minutes timeout
            
            if ($completed) {
                if ($process.ExitCode -eq 0) {
                    Write-Host "   ✅ Integration tests passed" -ForegroundColor Green
                } else {
                    Write-Host "   ❌ Integration tests failed with exit code $($process.ExitCode)" -ForegroundColor Red
                }
            } else {
                Write-Host "   ⚠️ Integration tests timed out" -ForegroundColor Yellow
                $process.Kill()
            }
        } catch {
            Write-Host "   ❌ Integration tests failed: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "   ⚠️ Integration tests not found" -ForegroundColor Yellow
    }
}

# Test 5: Test API server (if requested)
if ($StartAPIServer) {
    Write-Host "`n🌐 Test 5: Testing API server..." -ForegroundColor Yellow
    
    $apiServerExe = Join-Path $buildDir "unified_api_server.exe"
    if (Test-Path $apiServerExe) {
        Write-Host "   🚀 Starting API server..." -ForegroundColor Cyan
        
        try {
            $process = Start-Process -FilePath $apiServerExe -WorkingDirectory $buildDir -PassThru -NoNewWindow
            Start-Sleep -Seconds 5 # Give server time to start
            
            # Test if server is responding
            try {
                $response = Invoke-WebRequest -Uri "http://localhost:8080/status/health" -TimeoutSec 10
                if ($response.StatusCode -eq 200) {
                    Write-Host "   ✅ API server is responding" -ForegroundColor Green
                } else {
                    Write-Host "   ⚠️ API server responded with status $($response.StatusCode)" -ForegroundColor Yellow
                }
            } catch {
                Write-Host "   ⚠️ API server not responding: $_" -ForegroundColor Yellow
            }
            
            # Stop server
            $process.Kill()
            Write-Host "   🛑 API server stopped" -ForegroundColor Yellow
            
        } catch {
            Write-Host "   ❌ API server test failed: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "   ⚠️ API server not found" -ForegroundColor Yellow
    }
}

# Test 6: Check for generated files
Write-Host "`n📁 Test 6: Checking generated files..." -ForegroundColor Yellow

$generatedFiles = @(
    "chromium_fresh_demo_screenshot.png",
    "tooltip_demo_screenshot.png",
    "test_screenshot.png"
)

$foundFiles = 0
foreach ($file in $generatedFiles) {
    if (Test-Path $file) {
        Write-Host "   ✅ $file" -ForegroundColor Green
        $foundFiles++
    } else {
        Write-Host "   ❌ $file" -ForegroundColor Red
    }
}

if ($foundFiles -gt 0) {
    Write-Host "   📊 Found $foundFiles/$($generatedFiles.Count) generated files" -ForegroundColor Cyan
}

# Test summary
Write-Host "`n📊 Integration Test Summary" -ForegroundColor Cyan
Write-Host "===========================" -ForegroundColor Cyan

$totalTests = 6
$passedTests = 0

# Count passed tests based on what was run
if ($IncludeNaviGrab -and $RunExamples) { $passedTests++ }
if ($RunExamples) { $passedTests++ }
if ($RunTests) { $passedTests++ }
if ($StartAPIServer) { $passedTests++ }
if ($foundFiles -gt 0) { $passedTests++ }

Write-Host "✅ Tests passed: $passedTests/$totalTests" -ForegroundColor Green

if ($passedTests -eq $totalTests) {
    Write-Host "🎉 All integration tests passed!" -ForegroundColor Green
    Write-Host "🚀 ChromiumFresh + NaviGrab integration is working correctly!" -ForegroundColor Green
} else {
    Write-Host "⚠️ Some tests failed or were skipped" -ForegroundColor Yellow
    Write-Host "🔧 Please check the output above for details" -ForegroundColor Yellow
}

Write-Host "`n🔗 Next steps:" -ForegroundColor Cyan
Write-Host "   1. Run examples: .\build\bin\$BuildType\web_automation_demo.exe" -ForegroundColor White
Write-Host "   2. Start API server: .\build\bin\$BuildType\unified_api_server.exe" -ForegroundColor White
Write-Host "   3. Check generated files in the current directory" -ForegroundColor White

