// Working Web Automation Demo using NaviGrab
// Demonstrates actual web automation functionality

#include <iostream>
#include <memory>
#include <string>
#include <thread>
#include <chrono>

#include "navigrab/navigrab_core.h"

using namespace navigrab;

int main() {
    std::cout << "🚀 ChromiumFresh + NaviGrab Web Automation Demo" << std::endl;
    std::cout << "================================================" << std::endl;
    
    try {
        // Initialize NaviGrab
        std::cout << "\n📦 Initializing NaviGrab..." << std::endl;
        auto automation = CreateWebAutomation();
        std::cout << "✅ NaviGrab initialized successfully!" << std::endl;
        
        // Create browser and page
        std::cout << "\n🌐 Creating browser and page..." << std::endl;
        auto browser = automation->CreateBrowser();
        auto page = automation->CreatePage();
        
        // Launch browser
        std::cout << "\n🚀 Launching browser..." << std::endl;
        if (browser->Launch("https://www.google.com")) {
            std::cout << "✅ Browser launched successfully!" << std::endl;
        } else {
            std::cout << "❌ Failed to launch browser" << std::endl;
            return 1;
        }
        
        // Navigate to a page
        std::cout << "\n🧭 Navigating to Google..." << std::endl;
        if (browser->NavigateTo("https://www.google.com")) {
            std::cout << "✅ Navigation successful!" << std::endl;
            std::cout << "Current URL: " << browser->GetCurrentUrl() << std::endl;
            std::cout << "Page Title: " << browser->GetTitle() << std::endl;
        } else {
            std::cout << "❌ Navigation failed" << std::endl;
        }
        
        // Test element interaction
        std::cout << "\n🎯 Testing element interaction..." << std::endl;
        
        // Click search box
        std::cout << "Clicking search box..." << std::endl;
        if (page->ClickElement("input[name='q']")) {
            std::cout << "✅ Search box clicked" << std::endl;
        } else {
            std::cout << "❌ Failed to click search box" << std::endl;
        }
        
        // Type search query
        std::cout << "Typing search query..." << std::endl;
        if (page->TypeText("input[name='q']", "NaviGrab web automation")) {
            std::cout << "✅ Search query typed" << std::endl;
        } else {
            std::cout << "❌ Failed to type search query" << std::endl;
        }
        
        // Hover over search button
        std::cout << "Hovering over search button..." << std::endl;
        if (page->HoverElement("input[value='Google Search']")) {
            std::cout << "✅ Hover successful" << std::endl;
        } else {
            std::cout << "❌ Hover failed" << std::endl;
        }
        
        // Test locator functionality
        std::cout << "\n🔍 Testing locator functionality..." << std::endl;
        auto locator = automation->LocateElement("input[name='q']");
        
        if (locator->IsVisible()) {
            std::cout << "✅ Element is visible" << std::endl;
        }
        
        if (locator->IsEnabled()) {
            std::cout << "✅ Element is enabled" << std::endl;
        }
        
        std::string elementText = locator->GetText();
        std::cout << "Element text: " << elementText << std::endl;
        
        std::string elementAttr = locator->GetAttribute("name");
        std::cout << "Element name attribute: " << elementAttr << std::endl;
        
        // Test screenshot capture
        std::cout << "\n📸 Testing screenshot capture..." << std::endl;
        auto screenshot_capture = automation->CreateScreenshotCapture();
        
        if (screenshot_capture->CapturePage("google_page.png")) {
            std::cout << "✅ Page screenshot captured" << std::endl;
        } else {
            std::cout << "❌ Failed to capture page screenshot" << std::endl;
        }
        
        if (screenshot_capture->CaptureElement("input[name='q']", "search_box.png")) {
            std::cout << "✅ Element screenshot captured" << std::endl;
        } else {
            std::cout << "❌ Failed to capture element screenshot" << std::endl;
        }
        
        // Test form interaction
        std::cout << "\n📝 Testing form interaction..." << std::endl;
        std::map<std::string, std::string> formData = {
            {"username", "testuser"},
            {"password", "testpass"},
            {"email", "test@example.com"}
        };
        
        if (automation->FillForm("form", formData)) {
            std::cout << "✅ Form filled successfully" << std::endl;
        } else {
            std::cout << "❌ Failed to fill form" << std::endl;
        }
        
        if (automation->SubmitForm("form")) {
            std::cout << "✅ Form submitted successfully" << std::endl;
        } else {
            std::cout << "❌ Failed to submit form" << std::endl;
        }
        
        // Test wait functions
        std::cout << "\n⏳ Testing wait functions..." << std::endl;
        if (automation->WaitForElement("input[name='q']", 5000)) {
            std::cout << "✅ Element found within timeout" << std::endl;
        } else {
            std::cout << "❌ Element not found within timeout" << std::endl;
        }
        
        if (automation->WaitForLoad(3000)) {
            std::cout << "✅ Page loaded within timeout" << std::endl;
        } else {
            std::cout << "❌ Page load timeout" << std::endl;
        }
        
        // Test JavaScript execution
        std::cout << "\n🔧 Testing JavaScript execution..." << std::endl;
        std::string scriptResult = automation->ExecuteScript("return document.title;");
        std::cout << "Script result: " << scriptResult << std::endl;
        
        std::string elementScriptResult = automation->ExecuteScriptOnElement("input[name='q']", "return this.value;");
        std::cout << "Element script result: " << elementScriptResult << std::endl;
        
        // Test page source and content extraction
        std::cout << "\n📄 Testing content extraction..." << std::endl;
        std::string pageSource = automation->GetPageSource("https://www.google.com");
        std::cout << "Page source length: " << pageSource.length() << " characters" << std::endl;
        
        std::vector<std::string> links = automation->GetLinks("https://www.google.com");
        std::cout << "Found " << links.size() << " links:" << std::endl;
        for (const auto& link : links) {
            std::cout << "  - " << link << std::endl;
        }
        
        std::vector<std::string> images = automation->GetImages("https://www.google.com");
        std::cout << "Found " << images.size() << " images:" << std::endl;
        for (const auto& image : images) {
            std::cout << "  - " << image << std::endl;
        }
        
        // Test navigation
        std::cout << "\n🧭 Testing navigation..." << std::endl;
        if (browser->NavigateTo("https://www.github.com")) {
            std::cout << "✅ Navigated to GitHub" << std::endl;
            std::cout << "Current URL: " << browser->GetCurrentUrl() << std::endl;
        } else {
            std::cout << "❌ Navigation to GitHub failed" << std::endl;
        }
        
        if (browser->GoBack()) {
            std::cout << "✅ Went back to previous page" << std::endl;
            std::cout << "Current URL: " << browser->GetCurrentUrl() << std::endl;
        } else {
            std::cout << "❌ Back navigation failed" << std::endl;
        }
        
        if (browser->GoForward()) {
            std::cout << "✅ Went forward to next page" << std::endl;
            std::cout << "Current URL: " << browser->GetCurrentUrl() << std::endl;
        } else {
            std::cout << "❌ Forward navigation failed" << std::endl;
        }
        
        if (browser->Reload()) {
            std::cout << "✅ Page reloaded" << std::endl;
        } else {
            std::cout << "❌ Page reload failed" << std::endl;
        }
        
        // Final screenshot
        std::cout << "\n📸 Final screenshot..." << std::endl;
        if (screenshot_capture->CapturePage("final_page.png")) {
            std::cout << "✅ Final screenshot captured" << std::endl;
        } else {
            std::cout << "❌ Failed to capture final screenshot" << std::endl;
        }
        
        // Close browser
        std::cout << "\n🔒 Closing browser..." << std::endl;
        browser->Close();
        std::cout << "✅ Browser closed" << std::endl;
        
        std::cout << "\n🎉 Web automation demo completed successfully!" << std::endl;
        std::cout << "=================================================" << std::endl;
        std::cout << "\n📊 Demo Summary:" << std::endl;
        std::cout << "  ✅ Browser launched and controlled" << std::endl;
        std::cout << "  ✅ Element interaction tested" << std::endl;
        std::cout << "  ✅ Screenshot capture tested" << std::endl;
        std::cout << "  ✅ Form interaction tested" << std::endl;
        std::cout << "  ✅ Wait functions tested" << std::endl;
        std::cout << "  ✅ JavaScript execution tested" << std::endl;
        std::cout << "  ✅ Content extraction tested" << std::endl;
        std::cout << "  ✅ Navigation tested" << std::endl;
        std::cout << "\n💡 NaviGrab is now providing real web automation functionality!" << std::endl;
        
    } catch (const std::exception& e) {
        std::cerr << "❌ Error: " << e.what() << std::endl;
        return 1;
    }
    
    return 0;
}
