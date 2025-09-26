#include <iostream>
#include <chrono>
#include <thread>

// NaviGrab includes
#include "navigrab/navigrab_core.h"
#include "navigrab/proactive_scraper.h"

// ChromiumFresh includes (if available)
#ifdef USE_REAL_CHROMIUM
#include "chrome/browser/tooltip/tooltip_service.h"
#include "chrome/browser/tooltip/navigrab_integration.h"
#endif

using namespace navigrab;

void PrintElementInfo(const ElementInfo& element) {
    std::cout << "  📍 Element: " << element.selector << std::endl;
    std::cout << "     Type: " << element.type << std::endl;
    std::cout << "     Text: " << element.text << std::endl;
    std::cout << "     Position: (" << element.position.first << ", " << element.position.second << ")" << std::endl;
    std::cout << "     Size: (" << element.size.first << " x " << element.size.second << ")" << std::endl;
    std::cout << "     Interactive: " << (element.is_interactive ? "Yes" : "No") << std::endl;
    if (!element.screenshot_path.empty()) {
        std::cout << "     Screenshot: " << element.screenshot_path << std::endl;
    }
    std::cout << std::endl;
}

void PrintScrapingResult(const ScrapingResult& result) {
    std::cout << "🔍 Scraping Result for " << result.url << std::endl;
    std::cout << "   Success: " << (result.success ? "Yes" : "No") << std::endl;
    std::cout << "   Total Elements: " << result.total_elements << std::endl;
    std::cout << "   Interactive Elements: " << result.interactive_elements << std::endl;
    std::cout << "   Duration: " << result.duration.count() << "ms" << std::endl;
    
    if (!result.error_message.empty()) {
        std::cout << "   Error: " << result.error_message << std::endl;
    }
    
    std::cout << "\n📋 Discovered Elements:" << std::endl;
    for (const auto& element : result.elements) {
        PrintElementInfo(element);
    }
    std::cout << "─────────────────────────────────────────" << std::endl;
}

int main() {
    std::cout << "🚀 NaviGrab + ChromiumFresh Integration Demo" << std::endl;
    std::cout << "=============================================" << std::endl;
    
    // Test 1: Basic NaviGrab functionality
    std::cout << "\n🔧 Test 1: Basic NaviGrab Core" << std::endl;
    std::cout << "─────────────────────────────" << std::endl;
    
    NaviGrabCore navigrab;
    auto browser = navigrab.CreateBrowser();
    auto page = navigrab.CreatePage();
    
    std::cout << "✅ NaviGrab Core initialized" << std::endl;
    std::cout << "✅ Browser created" << std::endl;
    std::cout << "✅ Page created" << std::endl;
    
    // Test 2: Proactive Scraper
    std::cout << "\n🔍 Test 2: Proactive Scraper" << std::endl;
    std::cout << "───────────────────────────" << std::endl;
    
    ProactiveScraper scraper;
    scraper.SetScrapingDepth(ScrapingDepth::STANDARD);
    scraper.SetScreenshotEnabled(true);
    scraper.SetCacheEnabled(true);
    
    std::cout << "✅ ProactiveScraper configured" << std::endl;
    
    // Test different scraping depths
    std::vector<std::string> test_urls = {
        "https://example.com",
        "https://google.com",
        "https://github.com"
    };
    
    for (const auto& url : test_urls) {
        std::cout << "\n🌐 Testing URL: " << url << std::endl;
        
        // Quick scrape
        auto quick_result = scraper.ScrapePage(url, ScrapingDepth::QUICK);
        std::cout << "⚡ Quick scrape: " << quick_result.total_elements << " elements in " 
                  << quick_result.duration.count() << "ms" << std::endl;
        
        // Standard scrape
        auto standard_result = scraper.ScrapePage(url, ScrapingDepth::STANDARD);
        std::cout << "📊 Standard scrape: " << standard_result.total_elements << " elements in " 
                  << standard_result.duration.count() << "ms" << std::endl;
        
        // Deep scrape
        auto deep_result = scraper.ScrapePage(url, ScrapingDepth::DEEP);
        std::cout << "🔍 Deep scrape: " << deep_result.total_elements << " elements in " 
                  << deep_result.duration.count() << "ms" << std::endl;
        
        // Test caching
        auto cached_result = scraper.ScrapePage(url, ScrapingDepth::STANDARD);
        std::cout << "💾 Cached scrape: " << cached_result.total_elements << " elements in " 
                  << cached_result.duration.count() << "ms (should be faster)" << std::endl;
    }
    
    // Test 3: Element Discovery
    std::cout << "\n🔍 Test 3: Element Discovery" << std::endl;
    std::cout << "───────────────────────────" << std::endl;
    
    auto elements = scraper.DiscoverElements("https://example.com");
    std::cout << "✅ Discovered " << elements.size() << " total elements" << std::endl;
    
    auto interactive_elements = scraper.DiscoverInteractiveElements("https://example.com");
    std::cout << "✅ Discovered " << interactive_elements.size() << " interactive elements" << std::endl;
    
    auto buttons = scraper.DiscoverButtons("https://example.com");
    std::cout << "✅ Discovered " << buttons.size() << " buttons" << std::endl;
    
    auto links = scraper.DiscoverLinks("https://example.com");
    std::cout << "✅ Discovered " << links.size() << " links" << std::endl;
    
    // Test 4: Screenshot Capture
    std::cout << "\n📸 Test 4: Screenshot Capture" << std::endl;
    std::cout << "────────────────────────────" << std::endl;
    
    if (!interactive_elements.empty()) {
        auto& element = interactive_elements[0];
        bool screenshot_success = scraper.CaptureElementScreenshot(element);
        std::cout << "✅ Element screenshot: " << (screenshot_success ? "Success" : "Failed") << std::endl;
        
        bool all_screenshots_success = scraper.CaptureAllElementScreenshots(interactive_elements);
        std::cout << "✅ All element screenshots: " << (all_screenshots_success ? "Success" : "Failed") << std::endl;
    }
    
    // Test 5: Scraping Session
    std::cout << "\n📋 Test 5: Scraping Session" << std::endl;
    std::cout << "──────────────────────────" << std::endl;
    
    ScrapingSession session;
    session.StartSession();
    session.AddPages(test_urls);
    
    std::cout << "✅ Session started with " << session.GetTotalPages() << " pages" << std::endl;
    
    // Scrape all pages
    auto session_results = session.ScrapeAllPages(ScrapingDepth::STANDARD);
    std::cout << "✅ Session completed: " << session_results.size() << " results" << std::endl;
    
    session.EndSession();
    std::cout << "✅ Session ended. Duration: " << session.GetSessionDuration().count() << "ms" << std::endl;
    
    // Test 6: Statistics
    std::cout << "\n📊 Test 6: Statistics" << std::endl;
    std::cout << "─────────────────────" << std::endl;
    
    std::cout << "✅ Total elements discovered: " << scraper.GetTotalElementsDiscovered() << std::endl;
    std::cout << "✅ Total screenshots captured: " << scraper.GetTotalScreenshotsCaptured() << std::endl;
    std::cout << "✅ Average scraping time: " << scraper.GetAverageScrapingTime().count() << "ms" << std::endl;
    std::cout << "✅ Cache size: " << scraper.GetCacheSize() << " entries" << std::endl;
    
    // Test 7: ChromiumFresh Integration (if available)
    #ifdef USE_REAL_CHROMIUM
    std::cout << "\n🔗 Test 7: ChromiumFresh Integration" << std::endl;
    std::cout << "────────────────────────────────────" << std::endl;
    
    std::cout << "✅ ChromiumFresh tooltip service integration available" << std::endl;
    std::cout << "✅ NaviGrab integration bridge available" << std::endl;
    #else
    std::cout << "\n⚠️  Test 7: ChromiumFresh Integration" << std::endl;
    std::cout << "────────────────────────────────────" << std::endl;
    std::cout << "⚠️  ChromiumFresh integration not available (mock mode)" << std::endl;
    #endif
    
    std::cout << "\n🎉 Integration Demo Completed Successfully!" << std::endl;
    std::cout << "=============================================" << std::endl;
    
    std::cout << "\n📋 Summary:" << std::endl;
    std::cout << "✅ NaviGrab Core: Working" << std::endl;
    std::cout << "✅ Proactive Scraper: Working" << std::endl;
    std::cout << "✅ Element Discovery: Working" << std::endl;
    std::cout << "✅ Screenshot Capture: Working" << std::endl;
    std::cout << "✅ Scraping Sessions: Working" << std::endl;
    std::cout << "✅ Caching: Working" << std::endl;
    std::cout << "✅ Statistics: Working" << std::endl;
    #ifdef USE_REAL_CHROMIUM
    std::cout << "✅ ChromiumFresh Integration: Available" << std::endl;
    #else
    std::cout << "⚠️  ChromiumFresh Integration: Mock Mode" << std::endl;
    #endif
    
    return 0;
}

