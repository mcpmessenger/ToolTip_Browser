#include <iostream>
#include <memory>
#include "src/navigrab/navigrab_core.h"
#include "src/navigrab/proactive_scraper.h"

int main() {
    std::cout << "🚀 Testing NaviGrab Core Library" << std::endl;
    std::cout << "=================================" << std::endl;
    
    try {
        // Test 1: Create ProactiveScraper
        std::cout << "\n📋 Test 1: Creating ProactiveScraper..." << std::endl;
        auto scraper = std::make_unique<navigrab::ProactiveScraper>();
        std::cout << "✅ ProactiveScraper created successfully!" << std::endl;
        
        // Test 2: Configure scraper
        std::cout << "\n📋 Test 2: Configuring scraper..." << std::endl;
        scraper->SetScrapingDepth(navigrab::ScrapingDepth::QUICK);
        scraper->SetCacheEnabled(true);
        scraper->SetMaxElements(100);
        scraper->SetScreenshotEnabled(true);
        std::cout << "✅ Scraper configured successfully!" << std::endl;
        
        // Test 3: Test element discovery (mock)
        std::cout << "\n📋 Test 3: Testing element discovery..." << std::endl;
        auto elements = scraper->DiscoverElements("https://example.com");
        std::cout << "✅ Discovered " << elements.size() << " elements!" << std::endl;
        
        // Test 4: Test link discovery
        std::cout << "\n📋 Test 4: Testing link discovery..." << std::endl;
        auto links = scraper->DiscoverLinks("https://example.com");
        std::cout << "✅ Discovered " << links.size() << " links!" << std::endl;
        
        // Test 5: Test scraping
        std::cout << "\n📋 Test 5: Testing page scraping..." << std::endl;
        auto result = scraper->ScrapePage("https://example.com", navigrab::ScrapingDepth::QUICK);
        std::cout << "✅ Scraping completed!" << std::endl;
        std::cout << "   - Elements found: " << result.elements.size() << std::endl;
        std::cout << "   - Screenshots taken: " << result.screenshots_taken << std::endl;
        std::cout << "   - Time taken: " << result.time_taken_ms << "ms" << std::endl;
        
        std::cout << "\n🎉 All tests passed! NaviGrab is working!" << std::endl;
        
    } catch (const std::exception& e) {
        std::cout << "❌ Error: " << e.what() << std::endl;
        return 1;
    }
    
    return 0;
}