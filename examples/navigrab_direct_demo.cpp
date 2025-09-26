// Direct NaviGrab Integration Demo
// Shows how to use NaviGrab as a library in your application

#include <iostream>
#include <memory>
#include <string>
#include <thread>
#include <chrono>

#include "navigrab/navigrab_core.h"

using namespace navigrab;

int main() {
    std::cout << "🚀 NaviGrab Direct Integration Demo" << std::endl;
    std::cout << "===================================" << std::endl;
    std::cout << "This shows how to use NaviGrab as a C++ library" << std::endl;
    std::cout << "in your ChromiumFresh tooltip browser application." << std::endl;
    std::cout << std::endl;
    
    try {
        // 1. Initialize NaviGrab
        std::cout << "📦 Step 1: Initializing NaviGrab..." << std::endl;
        auto automation = CreateWebAutomation();
        std::cout << "   ✅ NaviGrab initialized successfully!" << std::endl;
        std::cout << std::endl;
        
        // 2. Create browser
        std::cout << "🌐 Step 2: Creating browser..." << std::endl;
        auto browser = automation->CreateBrowser();
        std::cout << "   ✅ Browser created successfully!" << std::endl;
        std::cout << std::endl;
        
        // 3. Launch browser
        std::cout << "🚀 Step 3: Launching browser..." << std::endl;
        if (browser->Launch("https://www.google.com")) {
            std::cout << "   ✅ Browser launched successfully!" << std::endl;
            std::cout << "   📍 Current URL: " << browser->GetCurrentUrl() << std::endl;
            std::cout << "   📄 Page Title: " << browser->GetTitle() << std::endl;
        } else {
            std::cout << "   ❌ Failed to launch browser" << std::endl;
            return 1;
        }
        std::cout << std::endl;
        
        // 4. Create page for interaction
        std::cout << "📄 Step 4: Creating page for interaction..." << std::endl;
        auto page = automation->CreatePage();
        std::cout << "   ✅ Page created successfully!" << std::endl;
        std::cout << std::endl;
        
        // 5. Demonstrate web automation
        std::cout << "🎯 Step 5: Demonstrating web automation..." << std::endl;
        
        // Click search box
        std::cout << "   🖱️ Clicking search box..." << std::endl;
        if (page->ClickElement("input[name='q']")) {
            std::cout << "   ✅ Search box clicked!" << std::endl;
        } else {
            std::cout << "   ❌ Failed to click search box" << std::endl;
        }
        
        // Type search query
        std::cout << "   ⌨️ Typing search query..." << std::endl;
        if (page->TypeText("input[name='q']", "NaviGrab web automation")) {
            std::cout << "   ✅ Search query typed!" << std::endl;
        } else {
            std::cout << "   ❌ Failed to type search query" << std::endl;
        }
        
        // Hover over search button
        std::cout << "   👆 Hovering over search button..." << std::endl;
        if (page->HoverElement("input[value='Google Search']")) {
            std::cout << "   ✅ Hover successful!" << std::endl;
        } else {
            std::cout << "   ❌ Hover failed" << std::endl;
        }
        std::cout << std::endl;
        
        // 6. Demonstrate screenshot capture
        std::cout << "📸 Step 6: Demonstrating screenshot capture..." << std::endl;
        auto screenshot_capture = automation->CreateScreenshotCapture();
        
        if (screenshot_capture->CapturePage("google_page.png")) {
            std::cout << "   ✅ Page screenshot captured!" << std::endl;
        } else {
            std::cout << "   ❌ Failed to capture page screenshot" << std::endl;
        }
        
        if (screenshot_capture->CaptureElement("input[name='q']", "search_box.png")) {
            std::cout << "   ✅ Element screenshot captured!" << std::endl;
        } else {
            std::cout << "   ❌ Failed to capture element screenshot" << std::endl;
        }
        std::cout << std::endl;
        
        // 7. Demonstrate content extraction
        std::cout << "📄 Step 7: Demonstrating content extraction..." << std::endl;
        std::string pageSource = automation->GetPageSource("https://www.google.com");
        std::cout << "   📊 Page source length: " << pageSource.length() << " characters" << std::endl;
        
        std::vector<std::string> links = automation->GetLinks("https://www.google.com");
        std::cout << "   🔗 Found " << links.size() << " links" << std::endl;
        
        std::vector<std::string> images = automation->GetImages("https://www.google.com");
        std::cout << "   🖼️ Found " << images.size() << " images" << std::endl;
        std::cout << std::endl;
        
        // 8. Demonstrate form interaction
        std::cout << "📝 Step 8: Demonstrating form interaction..." << std::endl;
        std::map<std::string, std::string> formData = {
            {"username", "testuser"},
            {"password", "testpass"},
            {"email", "test@example.com"}
        };
        
        if (automation->FillForm("form", formData)) {
            std::cout << "   ✅ Form filled successfully!" << std::endl;
        } else {
            std::cout << "   ❌ Failed to fill form" << std::endl;
        }
        
        if (automation->SubmitForm("form")) {
            std::cout << "   ✅ Form submitted successfully!" << std::endl;
        } else {
            std::cout << "   ❌ Failed to submit form" << std::endl;
        }
        std::cout << std::endl;
        
        // 9. Demonstrate JavaScript execution
        std::cout << "🔧 Step 9: Demonstrating JavaScript execution..." << std::endl;
        std::string scriptResult = automation->ExecuteScript("return document.title;");
        std::cout << "   📊 Script result: " << scriptResult << std::endl;
        
        std::string elementScriptResult = automation->ExecuteScriptOnElement("input[name='q']", "return this.value;");
        std::cout << "   📊 Element script result: " << elementScriptResult << std::endl;
        std::cout << std::endl;
        
        // 10. Demonstrate navigation
        std::cout << "🧭 Step 10: Demonstrating navigation..." << std::endl;
        if (browser->NavigateTo("https://www.github.com")) {
            std::cout << "   ✅ Navigated to GitHub!" << std::endl;
            std::cout << "   📍 Current URL: " << browser->GetCurrentUrl() << std::endl;
        } else {
            std::cout << "   ❌ Navigation to GitHub failed" << std::endl;
        }
        
        if (browser->GoBack()) {
            std::cout << "   ✅ Went back to previous page!" << std::endl;
            std::cout << "   📍 Current URL: " << browser->GetCurrentUrl() << std::endl;
        } else {
            std::cout << "   ❌ Back navigation failed" << std::endl;
        }
        std::cout << std::endl;
        
        // 11. Close browser
        std::cout << "🔒 Step 11: Closing browser..." << std::endl;
        browser->Close();
        std::cout << "   ✅ Browser closed successfully!" << std::endl;
        std::cout << std::endl;
        
        // Summary
        std::cout << "🎉 NaviGrab Integration Demo Completed!" << std::endl;
        std::cout << "=======================================" << std::endl;
        std::cout << std::endl;
        std::cout << "📊 What NaviGrab provides:" << std::endl;
        std::cout << "   ✅ Browser control (launch, navigate, close)" << std::endl;
        std::cout << "   ✅ Element interaction (click, type, hover)" << std::endl;
        std::cout << "   ✅ Screenshot capture (page and element)" << std::endl;
        std::cout << "   ✅ Form interaction (fill, submit)" << std::endl;
        std::cout << "   ✅ Content extraction (links, images, source)" << std::endl;
        std::cout << "   ✅ JavaScript execution" << std::endl;
        std::cout << "   ✅ Navigation control (back, forward, reload)" << std::endl;
        std::cout << std::endl;
        std::cout << "💡 How to integrate into ChromiumFresh:" << std::endl;
        std::cout << "   1. Include navigrab_core.h in your tooltip browser code" << std::endl;
        std::cout << "   2. Create WebAutomation instance" << std::endl;
        std::cout << "   3. Use it to automate web interactions" << std::endl;
        std::cout << "   4. Combine with your tooltip functionality" << std::endl;
        std::cout << std::endl;
        
    } catch (const std::exception& e) {
        std::cerr << "❌ Error: " << e.what() << std::endl;
        return 1;
    }
    
    return 0;
}
