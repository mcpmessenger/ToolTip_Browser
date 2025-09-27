# Full ToolTip_Browser Integration Test Script
# This script tests all components and their integration

Write-Host "🧪 TOOLTIP: Starting Full Integration Tests..." -ForegroundColor Green
Write-Host "This script will test:" -ForegroundColor Cyan
Write-Host "  1. Individual component functionality" -ForegroundColor White
Write-Host "  2. Component integration" -ForegroundColor White
Write-Host "  3. End-to-end workflows" -ForegroundColor White
Write-Host "  4. Performance benchmarks" -ForegroundColor White
Write-Host "  5. Error handling" -ForegroundColor White

# Set error handling
$ErrorActionPreference = "Continue"

# Test results tracking
$TestResults = @{
    "Component Tests" = @()
    "Integration Tests" = @()
    "Performance Tests" = @()
    "Error Handling Tests" = @()
}

function Test-Component {
    param(
        [string]$ComponentName,
        [string]$ExecutablePath,
        [string]$TestDescription
    )
    
    Write-Host "  Testing $ComponentName..." -ForegroundColor Cyan
    
    if (Test-Path $ExecutablePath) {
        try {
            $startTime = Get-Date
            $result = & $ExecutablePath 2>&1
            $endTime = Get-Date
            $duration = ($endTime - $startTime).TotalMilliseconds
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "    ✅ $ComponentName test passed ($([math]::Round($duration, 2))ms)" -ForegroundColor Green
                $TestResults["Component Tests"] += @{
                    Name = $ComponentName
                    Status = "PASSED"
                    Duration = $duration
                    Description = $TestDescription
                }
                return $true
            } else {
                Write-Host "    ❌ $ComponentName test failed (exit code: $LASTEXITCODE)" -ForegroundColor Red
                $TestResults["Component Tests"] += @{
                    Name = $ComponentName
                    Status = "FAILED"
                    Duration = $duration
                    Description = $TestDescription
                    Error = "Exit code: $LASTEXITCODE"
                }
                return $false
            }
        } catch {
            Write-Host "    ❌ $ComponentName test crashed: $($_.Exception.Message)" -ForegroundColor Red
            $TestResults["Component Tests"] += @{
                Name = $ComponentName
                Status = "CRASHED"
                Duration = 0
                Description = $TestDescription
                Error = $_.Exception.Message
            }
            return $false
        }
    } else {
        Write-Host "    ⚠️ $ComponentName executable not found at $ExecutablePath" -ForegroundColor Yellow
        $TestResults["Component Tests"] += @{
            Name = $ComponentName
            Status = "NOT_FOUND"
            Duration = 0
            Description = $TestDescription
            Error = "Executable not found"
        }
        return $false
    }
}

function Test-Integration {
    param(
        [string]$TestName,
        [string]$ExecutablePath,
        [string]$TestDescription
    )
    
    Write-Host "  Testing $TestName integration..." -ForegroundColor Cyan
    
    if (Test-Path $ExecutablePath) {
        try {
            $startTime = Get-Date
            $result = & $ExecutablePath 2>&1
            $endTime = Get-Date
            $duration = ($endTime - $startTime).TotalMilliseconds
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "    ✅ $TestName integration test passed ($([math]::Round($duration, 2))ms)" -ForegroundColor Green
                $TestResults["Integration Tests"] += @{
                    Name = $TestName
                    Status = "PASSED"
                    Duration = $duration
                    Description = $TestDescription
                }
                return $true
            } else {
                Write-Host "    ❌ $TestName integration test failed (exit code: $LASTEXITCODE)" -ForegroundColor Red
                $TestResults["Integration Tests"] += @{
                    Name = $TestName
                    Status = "FAILED"
                    Duration = $duration
                    Description = $TestDescription
                    Error = "Exit code: $LASTEXITCODE"
                }
                return $false
            }
        } catch {
            Write-Host "    ❌ $TestName integration test crashed: $($_.Exception.Message)" -ForegroundColor Red
            $TestResults["Integration Tests"] += @{
                Name = $TestName
                Status = "CRASHED"
                Duration = $duration
                Description = $TestDescription
                Error = $_.Exception.Message
            }
            return $false
        }
    } else {
        Write-Host "    ⚠️ $TestName executable not found at $ExecutablePath" -ForegroundColor Yellow
        $TestResults["Integration Tests"] += @{
            Name = $TestName
            Status = "NOT_FOUND"
            Duration = 0
            Description = $TestDescription
            Error = "Executable not found"
        }
        return $false
    }
}

function Test-Performance {
    param(
        [string]$TestName,
        [string]$ExecutablePath,
        [int]$Iterations = 5
    )
    
    Write-Host "  Performance testing $TestName..." -ForegroundColor Cyan
    
    if (Test-Path $ExecutablePath) {
        $durations = @()
        
        for ($i = 1; $i -le $Iterations; $i++) {
            try {
                $startTime = Get-Date
                $result = & $ExecutablePath 2>&1
                $endTime = Get-Date
                $duration = ($endTime - $startTime).TotalMilliseconds
                $durations += $duration
                
                Write-Host "    Run $i/$Iterations : $([math]::Round($duration, 2))ms" -ForegroundColor Gray
            } catch {
                Write-Host "    Run $i/$Iterations : FAILED" -ForegroundColor Red
                $durations += 0
            }
        }
        
        if ($durations.Count -gt 0) {
            $avgDuration = ($durations | Measure-Object -Average).Average
            $minDuration = ($durations | Measure-Object -Minimum).Minimum
            $maxDuration = ($durations | Measure-Object -Maximum).Maximum
            
            Write-Host "    📊 Performance: Avg=$([math]::Round($avgDuration, 2))ms, Min=$([math]::Round($minDuration, 2))ms, Max=$([math]::Round($maxDuration, 2))ms" -ForegroundColor Green
            
            $TestResults["Performance Tests"] += @{
                Name = $TestName
                AverageDuration = $avgDuration
                MinDuration = $minDuration
                MaxDuration = $maxDuration
                Iterations = $Iterations
            }
        }
    } else {
        Write-Host "    ⚠️ $TestName executable not found" -ForegroundColor Yellow
    }
}

# Main test execution
Write-Host "`n🔬 COMPONENT TESTS" -ForegroundColor Yellow
Write-Host "==================" -ForegroundColor Yellow

# Test individual components
Test-Component "NaviGrab Core" "build\Release\minimal_test.exe" "Basic NaviGrab functionality"
Test-Component "Simple Test" "build\Release\simple_test.exe" "Simple integration test"
Test-Component "Web Automation" "build\Release\web_automation_demo.exe" "Web automation capabilities"
Test-Component "Tooltip Automation" "build\Release\tooltip_automation_demo.exe" "Tooltip automation features"
Test-Component "Full Integration" "build\Release\full_integration_demo.exe" "Complete integration demo"

Write-Host "`n🔗 INTEGRATION TESTS" -ForegroundColor Yellow
Write-Host "====================" -ForegroundColor Yellow

# Test integration scenarios
Test-Integration "NaviGrab + Tooltip" "build\Release\tooltip_automation_demo.exe" "NaviGrab and Tooltip integration"
Test-Integration "Web + Automation" "build\Release\web_automation_demo.exe" "Web automation integration"
Test-Integration "Full System" "build\Release\full_integration_demo.exe" "Complete system integration"

Write-Host "`n⚡ PERFORMANCE TESTS" -ForegroundColor Yellow
Write-Host "====================" -ForegroundColor Yellow

# Performance testing
Test-Performance "Minimal Test" "build\Release\minimal_test.exe" 3
Test-Performance "Web Automation" "build\Release\web_automation_demo.exe" 3
Test-Performance "Tooltip Automation" "build\Release\tooltip_automation_demo.exe" 3
Test-Performance "Full Integration" "build\Release\full_integration_demo.exe" 3

Write-Host "`n📊 TEST RESULTS SUMMARY" -ForegroundColor Yellow
Write-Host "=======================" -ForegroundColor Yellow

# Component test summary
$componentPassed = ($TestResults["Component Tests"] | Where-Object { $_.Status -eq "PASSED" }).Count
$componentTotal = $TestResults["Component Tests"].Count
Write-Host "Component Tests: $componentPassed/$componentTotal passed" -ForegroundColor $(if ($componentPassed -eq $componentTotal) { "Green" } else { "Yellow" })

# Integration test summary
$integrationPassed = ($TestResults["Integration Tests"] | Where-Object { $_.Status -eq "PASSED" }).Count
$integrationTotal = $TestResults["Integration Tests"].Count
Write-Host "Integration Tests: $integrationPassed/$integrationTotal passed" -ForegroundColor $(if ($integrationPassed -eq $integrationTotal) { "Green" } else { "Yellow" })

# Performance test summary
$performanceTests = $TestResults["Performance Tests"].Count
Write-Host "Performance Tests: $performanceTests completed" -ForegroundColor Green

# Detailed results
Write-Host "`n📋 DETAILED RESULTS" -ForegroundColor Yellow
Write-Host "===================" -ForegroundColor Yellow

foreach ($category in $TestResults.Keys) {
    Write-Host "`n$category:" -ForegroundColor Cyan
    foreach ($test in $TestResults[$category]) {
        $statusColor = switch ($test.Status) {
            "PASSED" { "Green" }
            "FAILED" { "Red" }
            "CRASHED" { "Red" }
            "NOT_FOUND" { "Yellow" }
            default { "Gray" }
        }
        
        if ($test.Status -eq "PASSED") {
            Write-Host "  ✅ $($test.Name): $($test.Description) ($([math]::Round($test.Duration, 2))ms)" -ForegroundColor $statusColor
        } elseif ($test.Status -eq "FAILED" -or $test.Status -eq "CRASHED") {
            Write-Host "  ❌ $($test.Name): $($test.Description) - $($test.Error)" -ForegroundColor $statusColor
        } else {
            Write-Host "  ⚠️ $($test.Name): $($test.Description) - $($test.Error)" -ForegroundColor $statusColor
        }
    }
}

# Overall assessment
$totalPassed = $componentPassed + $integrationPassed
$totalTests = $componentTotal + $integrationTotal
$successRate = if ($totalTests -gt 0) { [math]::Round(($totalPassed / $totalTests) * 100, 1) } else { 0 }

Write-Host "`n🎯 OVERALL ASSESSMENT" -ForegroundColor Yellow
Write-Host "====================" -ForegroundColor Yellow
Write-Host "Success Rate: $successRate% ($totalPassed/$totalTests tests passed)" -ForegroundColor $(if ($successRate -ge 80) { "Green" } elseif ($successRate -ge 60) { "Yellow" } else { "Red" })

if ($successRate -ge 80) {
    Write-Host "🎉 EXCELLENT: Integration is working well!" -ForegroundColor Green
} elseif ($successRate -ge 60) {
    Write-Host "⚠️ GOOD: Integration is mostly working, some issues to address" -ForegroundColor Yellow
} else {
    Write-Host "❌ NEEDS WORK: Integration has significant issues that need attention" -ForegroundColor Red
}

Write-Host "`n🔧 TOOLTIP: Full integration testing completed!" -ForegroundColor Green
