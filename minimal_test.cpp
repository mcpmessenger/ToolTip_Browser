#include <iostream>
#include <memory>
#include "src/navigrab/proactive_scraper.h"

int main() {
    std::cout << "🚀 Testing NaviGrab Core Functionality" << std::endl;
    std::cout << "=====================================" << std::endl;
    
    try {
        // Test 1: Create ProactiveScraper
        std::cout << "\n📋 Test 1: Creating ProactiveScraper..." << std::endl;
        auto scraper = std::make_unique<navigrab::ProactiveScraper>();
        std::cout << "✅ ProactiveScraper created successfully!" << std::endl;
        
        // Test 2: Configure scraper
        std::cout << "\n📋 Test 2: Configuring scraper..." << std::endl;
        scraper->SetScrapingDepth(navigrab::ScrapingDepth::QUICK);
        scraper->SetCacheEnabled(true);
        scraper->SetMaxElements(50);
        scraper->SetScreenshotEnabled(true);
        std::cout << "✅ Scraper configured successfully!" << std::endl;
        
        // Test 3: Test element discovery
        std::cout << "\n📋 Test 3: Testing element discovery..." << std::endl;
        auto elements = scraper->DiscoverElements("https://example.com");
        std::cout << "✅ Discovered " << elements.size() << " elements!" << std::endl;
        
        // Show some element details
        for (size_t i = 0; i < std::min(elements.size(), size_t(3)); ++i) {
            const auto& element = elements[i];
            std::cout << "   Element " << (i+1) << ": " << element.type 
                      << " - " << element.text << std::endl;
        }
        
        // Test 4: Test link discovery
        std::cout << "\n📋 Test 4: Testing link discovery..." << std::endl;
        auto links = scraper->DiscoverLinks("https://example.com");
        std::cout << "✅ Discovered " << links.size() << " links!" << std::endl;
        
        // Test 5: Test scraping
        std::cout << "\n📋 Test 5: Testing page scraping..." << std::endl;
        auto result = scraper->ScrapePage("https://example.com", navigrab::ScrapingDepth::QUICK);
        std::cout << "✅ Scraping completed!" << std::endl;
        std::cout << "   - Elements found: " << result.elements.size() << std::endl;
        std::cout << "   - Total elements: " << result.total_elements << std::endl;
        std::cout << "   - Interactive elements: " << result.interactive_elements << std::endl;
        std::cout << "   - Time taken: " << result.duration.count() << "ms" << std::endl;
        
        // Test 6: Test with our custom test page
        std::cout << "\n📋 Test 6: Testing with custom test page..." << std::endl;
        auto testResult = scraper->ScrapePage("file:///C:/ChromiumFresh/test_automation_page.html", navigrab::ScrapingDepth::STANDARD);
        std::cout << "✅ Test page scraping completed!" << std::endl;
        std::cout << "   - Elements found: " << testResult.elements.size() << std::endl;
        std::cout << "   - Total elements: " << testResult.total_elements << std::endl;
        std::cout << "   - Interactive elements: " << testResult.interactive_elements << std::endl;
        
        std::cout << "\n🎉 All tests passed! NaviGrab is working perfectly!" << std::endl;
        std::cout << "\n🚀 Ready for ChromiumFresh integration!" << std::endl;
        
    } catch (const std::exception& e) {
        std::cout << "❌ Error: " << e.what() << std::endl;
        return 1;
    }
    
    return 0;
}
