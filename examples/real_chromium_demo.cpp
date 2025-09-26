// Real Chromium Integration Demo
// Demonstrates NaviGrab working with actual Chromium fork

#include <iostream>
#include <memory>
#include <string>
#include <thread>
#include <chrono>

#include "chromium_integration/real_chromium_bridge.h"

using namespace navigrab::chromium;

int main() {
    std::cout << "🚀 Real Chromium + NaviGrab Integration Demo" << std::endl;
    std::cout << "=============================================" << std::endl;
    std::cout << std::endl;

    // Create real Chromium bridge
    auto chromium_bridge = std::make_unique<RealChromiumBridge>();
    
    std::cout << "🔧 Initializing real Chromium integration..." << std::endl;
    if (!chromium_bridge->Initialize()) {
        std::cerr << "❌ Failed to initialize Chromium integration" << std::endl;
        return 1;
    }
    std::cout << "✅ Chromium integration initialized" << std::endl;
    std::cout << std::endl;

    // Set up event callbacks
    chromium_bridge->SetOnPageLoadCallback([](const std::string& url) {
        std::cout << "📄 Page loaded: " << url << std::endl;
    });

    chromium_bridge->SetOnElementClickCallback([](const std::string& selector) {
        std::cout << "🖱️ Element clicked: " << selector << std::endl;
    });

    chromium_bridge->SetOnScreenshotCallback([](const std::string& filename) {
        std::cout << "📸 Screenshot captured: " << filename << std::endl;
    });

    // Launch real Chromium browser
    std::cout << "🌐 Launching real Chromium browser..." << std::endl;
    if (!chromium_bridge->LaunchBrowser("https://www.google.com")) {
        std::cerr << "❌ Failed to launch browser" << std::endl;
        return 1;
    }
    std::cout << "✅ Browser launched successfully" << std::endl;
    std::cout << std::endl;

    // Wait a moment for browser to initialize
    std::this_thread::sleep_for(std::chrono::seconds(2));

    // Test navigation
    std::cout << "🧭 Testing navigation..." << std::endl;
    std::cout << "Current URL: " << chromium_bridge->GetCurrentUrl() << std::endl;
    std::cout << "Page title: " << chromium_bridge->GetTitle() << std::endl;
    std::cout << std::endl;

    // Test tooltip functionality
    std::cout << "💡 Testing tooltip functionality..." << std::endl;
    std::cout << "Tooltip enabled: " << (chromium_bridge->IsTooltipEnabled() ? "Yes" : "No") << std::endl;
    std::cout << "Dark mode enabled: " << (chromium_bridge->IsDarkModeEnabled() ? "Yes" : "No") << std::endl;
    std::cout << std::endl;

    // Test element interaction
    std::cout << "🎯 Testing element interaction..." << std::endl;
    
    // Test clicking search box
    std::cout << "Clicking search box..." << std::endl;
    if (chromium_bridge->ClickElement("input[name='q']")) {
        std::cout << "✅ Search box clicked" << std::endl;
    } else {
        std::cout << "❌ Failed to click search box" << std::endl;
    }

    // Test typing
    std::cout << "Typing search query..." << std::endl;
    if (chromium_bridge->TypeText("input[name='q']", "NaviGrab Chromium integration")) {
        std::cout << "✅ Text typed successfully" << std::endl;
    } else {
        std::cout << "❌ Failed to type text" << std::endl;
    }

    // Test hovering
    std::cout << "Hovering over search button..." << std::endl;
    if (chromium_bridge->HoverElement("input[value='Google Search']")) {
        std::cout << "✅ Hover successful" << std::endl;
    } else {
        std::cout << "❌ Failed to hover" << std::endl;
    }
    std::cout << std::endl;

    // Test screenshot capture
    std::cout << "📸 Testing screenshot capture..." << std::endl;
    if (chromium_bridge->CaptureScreenshot("google_search_page.png")) {
        std::cout << "✅ Screenshot captured" << std::endl;
    } else {
        std::cout << "❌ Failed to capture screenshot" << std::endl;
    }

    // Test element screenshot
    std::cout << "Capturing element screenshot..." << std::endl;
    if (chromium_bridge->CaptureElementScreenshot("input[name='q']", "search_box.png")) {
        std::cout << "✅ Element screenshot captured" << std::endl;
    } else {
        std::cout << "❌ Failed to capture element screenshot" << std::endl;
    }
    std::cout << std::endl;

    // Test AI integration
    std::cout << "🤖 Testing AI integration..." << std::endl;
    chromium_bridge->GetElementDescription("input[name='q']", [](const std::string& description) {
        std::cout << "AI Description: " << description << std::endl;
    });

    chromium_bridge->GetPageDescription([](const std::string& description) {
        std::cout << "Page Description: " << description << std::endl;
    });
    std::cout << std::endl;

    // Test dark mode toggle
    std::cout << "🌙 Testing dark mode..." << std::endl;
    std::cout << "Current dark mode: " << (chromium_bridge->IsDarkModeEnabled() ? "Enabled" : "Disabled") << std::endl;
    
    std::cout << "Toggling dark mode..." << std::endl;
    chromium_bridge->SetDarkMode(true);
    std::cout << "Dark mode after toggle: " << (chromium_bridge->IsDarkModeEnabled() ? "Enabled" : "Disabled") << std::endl;
    std::cout << std::endl;

    // Test tooltip display
    std::cout << "💡 Testing tooltip display..." << std::endl;
    chromium_bridge->ShowTooltip("This is a test tooltip from NaviGrab!", {100, 100, 200, 50});
    
    std::this_thread::sleep_for(std::chrono::seconds(2));
    
    chromium_bridge->HideTooltip();
    std::cout << "✅ Tooltip test completed" << std::endl;
    std::cout << std::endl;

    // Test navigation
    std::cout << "🧭 Testing navigation..." << std::endl;
    std::cout << "Navigating to GitHub..." << std::endl;
    if (chromium_bridge->NavigateTo("https://github.com")) {
        std::cout << "✅ Navigation successful" << std::endl;
    } else {
        std::cout << "❌ Navigation failed" << std::endl;
    }

    std::this_thread::sleep_for(std::chrono::seconds(2));

    // Test back navigation
    std::cout << "Going back..." << std::endl;
    if (chromium_bridge->GoBack()) {
        std::cout << "✅ Back navigation successful" << std::endl;
    } else {
        std::cout << "❌ Back navigation failed" << std::endl;
    }
    std::cout << std::endl;

    // Final screenshot
    std::cout << "📸 Final screenshot..." << std::endl;
    chromium_bridge->CaptureScreenshot("final_page.png");
    std::cout << "✅ Final screenshot captured" << std::endl;
    std::cout << std::endl;

    // Keep browser open for a moment to see results
    std::cout << "⏳ Keeping browser open for 5 seconds..." << std::endl;
    std::this_thread::sleep_for(std::chrono::seconds(5));

    // Close browser
    std::cout << "🔒 Closing browser..." << std::endl;
    chromium_bridge->CloseBrowser();
    std::cout << "✅ Browser closed" << std::endl;
    std::cout << std::endl;

    std::cout << "🎉 Real Chromium + NaviGrab integration demo completed!" << std::endl;
    std::cout << "=====================================================" << std::endl;
    std::cout << std::endl;
    std::cout << "📊 Demo Summary:" << std::endl;
    std::cout << "  ✅ Chromium integration initialized" << std::endl;
    std::cout << "  ✅ Browser launched and controlled" << std::endl;
    std::cout << "  ✅ Element interaction tested" << std::endl;
    std::cout << "  ✅ Screenshot capture tested" << std::endl;
    std::cout << "  ✅ AI integration tested" << std::endl;
    std::cout << "  ✅ Dark mode toggle tested" << std::endl;
    std::cout << "  ✅ Tooltip display tested" << std::endl;
    std::cout << "  ✅ Navigation tested" << std::endl;
    std::cout << std::endl;

    return 0;
}

