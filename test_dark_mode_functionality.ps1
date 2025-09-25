# Test Script for Dark Mode Functionality
# This script tests the dark mode implementation in the built Chromium fork

Write-Host "🔧 TOOLTIP: Testing Dark Mode Functionality..." -ForegroundColor Green

# Check if Chrome executable exists
$chromeExe = "out\Default\chrome.exe"
if (-not (Test-Path $chromeExe)) {
    Write-Host "❌ Error: Chrome executable not found at $chromeExe" -ForegroundColor Red
    Write-Host "Please run the build script first: .\build_with_dark_mode_fixes.ps1" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Chrome executable found" -ForegroundColor Green

# Create a test HTML file to verify dark mode
$testHtml = @"
<!DOCTYPE html>
<html>
<head>
    <title>Dark Mode Test</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            padding: 20px; 
            background-color: white; 
            color: black; 
        }
        .test-section { 
            margin: 20px 0; 
            padding: 15px; 
            border: 1px solid #ccc; 
        }
        button { 
            padding: 10px 20px; 
            margin: 5px; 
            background-color: #007bff; 
            color: white; 
            border: none; 
            cursor: pointer; 
        }
        input, textarea { 
            padding: 8px; 
            margin: 5px; 
            border: 1px solid #ccc; 
        }
        table { 
            border-collapse: collapse; 
            width: 100%; 
        }
        th, td { 
            border: 1px solid #ccc; 
            padding: 8px; 
            text-align: left; 
        }
        th { 
            background-color: #f2f2f2; 
        }
    </style>
</head>
<body>
    <h1>🔧 TOOLTIP Dark Mode Test Page</h1>
    
    <div class="test-section">
        <h2>Text Elements</h2>
        <p>This is a paragraph with <strong>bold text</strong> and <em>italic text</em>.</p>
        <a href="#">This is a link</a>
        <ul>
            <li>List item 1</li>
            <li>List item 2</li>
            <li>List item 3</li>
        </ul>
    </div>
    
    <div class="test-section">
        <h2>Form Elements</h2>
        <input type="text" placeholder="Text input" />
        <input type="email" placeholder="Email input" />
        <textarea placeholder="Textarea"></textarea>
        <button>Button</button>
        <select>
            <option>Option 1</option>
            <option>Option 2</option>
        </select>
    </div>
    
    <div class="test-section">
        <h2>Table</h2>
        <table>
            <thead>
                <tr>
                    <th>Header 1</th>
                    <th>Header 2</th>
                    <th>Header 3</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>Row 1, Cell 1</td>
                    <td>Row 1, Cell 2</td>
                    <td>Row 1, Cell 3</td>
                </tr>
                <tr>
                    <td>Row 2, Cell 1</td>
                    <td>Row 2, Cell 2</td>
                    <td>Row 2, Cell 3</td>
                </tr>
            </tbody>
        </table>
    </div>
    
    <div class="test-section">
        <h2>Code Block</h2>
        <pre><code>// This is a code block
function testDarkMode() {
    console.log("Dark mode test");
}</code></pre>
    </div>
    
    <script>
        // Test script to verify dark mode injection
        console.log("🔧 TOOLTIP: Test page loaded");
        
        // Check if dark mode CSS is injected
        setTimeout(() => {
            const darkModeStyle = document.getElementById('tooltip-dark-mode-style');
            if (darkModeStyle) {
                console.log("✅ Dark mode CSS found!");
                document.title = "✅ Dark Mode Active - TOOLTIP Test";
            } else {
                console.log("❌ Dark mode CSS not found");
                document.title = "❌ Dark Mode Not Active - TOOLTIP Test";
            }
        }, 1000);
    </script>
</body>
</html>
"@

# Write test HTML file
$testHtmlPath = "dark_mode_test.html"
$testHtml | Out-File -FilePath $testHtmlPath -Encoding UTF8
Write-Host "✅ Test HTML file created: $testHtmlPath" -ForegroundColor Green

# Launch Chrome with the test page
Write-Host "🔧 TOOLTIP: Launching Chrome with test page..." -ForegroundColor Yellow
Write-Host "Look for dark mode styling and check the browser console for tooltip logs" -ForegroundColor Cyan

try {
    $fullPath = (Resolve-Path $testHtmlPath).Path
    Start-Process -FilePath $chromeExe -ArgumentList $fullPath
    Write-Host "✅ Chrome launched with test page" -ForegroundColor Green
} catch {
    Write-Host "❌ Error launching Chrome: $_" -ForegroundColor Red
    exit 1
}

Write-Host "🔧 TOOLTIP: Test completed!" -ForegroundColor Green
Write-Host "Check the browser console (F12) for tooltip logs and verify dark mode styling" -ForegroundColor Cyan
